"""
Build the source files for the Healthcare Revenue & AR Audit project.

Runs locally (outside Databricks) after Synthea has generated its CSV output.
It turns Synthea's claims data into the files a hospital would hand to its
auditors:

  1. billing_transactions/   - patient accounting subledger extract (monthly files)
  2. gl_journal_entries/     - general ledger detail (monthly files)
  3. chart_of_accounts/      - GL account master
  4. claims/, encounters/, payers/ - Synthea master data (rows filtered to the period)

Known errors are planted on purpose so the Bronze -> Silver -> Gold pipeline
has something to find. They are listed in answer_key.csv, which is NOT
uploaded to Databricks. It is only used afterwards to check the pipeline.

Usage:
    python build_source_files.py --synthea-dir ../synthea/output/csv --out-dir ./landing
"""

import argparse
import uuid
from pathlib import Path

import numpy as np
import pandas as pd

SEED = 2025
PERIOD_START = pd.Timestamp("2024-01-01")   # billing system "go-live": AR starts at zero
EXTRACT_END = pd.Timestamp("2026-01-31")    # date the client pulled the extracts

# GL accounts used by the billing interface
CASH, AR, REVENUE, BANK_FEES = "1100", "1200", "4000", "6100"

# Payment delay (days after service) by payer type: (min, max)
PAYMENT_LAG = {"GOVERNMENT": (14, 45), "PRIVATE": (20, 60), "NO_INSURANCE": (0, 90)}
SLOW_PAY_SHARE = 0.04           # claims stuck in denial/appeal
SLOW_PAY_EXTRA = (150, 400)     # extra days for those claims


def load_synthea(synthea_dir: Path):
    tx = pd.read_csv(
        synthea_dir / "claims_transactions.csv",
        usecols=["ID", "CLAIMID", "CHARGEID", "PATIENTID", "TYPE", "AMOUNT", "METHOD",
                 "FROMDATE", "PAYMENTS", "PROCEDURECODE", "NOTES", "DEPARTMENTID"],
    )
    claims = pd.read_csv(synthea_dir / "claims.csv")
    encounters = pd.read_csv(synthea_dir / "encounters.csv")
    payers = pd.read_csv(synthea_dir / "payers.csv")
    return tx, claims, encounters, payers


def build_billing_extract(tx, claims, encounters, payers, rng):
    """Turn Synthea CHARGE / PAYMENT rows into a subledger with posting dates."""
    tx["service_date"] = pd.to_datetime(tx["FROMDATE"]).dt.tz_localize(None).dt.normalize()
    tx = tx[(tx["service_date"] >= PERIOD_START) & (tx["service_date"] <= EXTRACT_END)]
    tx = tx[tx["TYPE"].isin(["CHARGE", "PAYMENT"])].copy()

    tx["amount"] = np.where(tx["TYPE"] == "CHARGE", tx["AMOUNT"], tx["PAYMENTS"])
    tx = tx[tx["amount"].fillna(0) > 0]

    # Payer type for each claim: claim -> encounter -> payer
    claim_payer = (
        claims[["Id", "APPOINTMENTID"]]
        .merge(encounters[["Id", "PAYER"]], left_on="APPOINTMENTID", right_on="Id",
               suffixes=("", "_enc"))
        .merge(payers[["Id", "OWNERSHIP"]], left_on="PAYER", right_on="Id",
               suffixes=("", "_payer"))
        [["Id", "OWNERSHIP"]].rename(columns={"Id": "CLAIMID"})
    )
    tx = tx.merge(claim_payer, on="CLAIMID", how="left")

    # Synthea pays everything on the day of service. Real payers don't, so add
    # a realistic delay per claim. That is what creates accounts receivable.
    claim_ids = tx["CLAIMID"].unique()
    slow = set(rng.choice(claim_ids, int(len(claim_ids) * SLOW_PAY_SHARE), replace=False))
    tx = tx.sort_values(["CLAIMID", "CHARGEID"])
    tx["pay_seq"] = tx[tx["TYPE"] == "PAYMENT"].groupby("CLAIMID").cumcount()

    def lag(row):
        if row["TYPE"] == "CHARGE":
            return 0
        if row["METHOD"] == "COPAY":
            return 0
        lo, hi = PAYMENT_LAG.get(row["OWNERSHIP"], (20, 60))
        days = int(rng.integers(lo, hi + 1))
        if row["pay_seq"] > 0:                      # patient's share is billed later
            days += int(rng.integers(15, 46))
        if row["CLAIMID"] in slow and row["OWNERSHIP"] != "NO_INSURANCE":
            days += int(rng.integers(*SLOW_PAY_EXTRA))
        return days

    tx["lag_days"] = tx.apply(lag, axis=1)
    tx["posting_date"] = tx["service_date"] + pd.to_timedelta(tx["lag_days"], unit="D")
    tx = tx[tx["posting_date"] <= EXTRACT_END]     # not yet paid at extract date

    out = pd.DataFrame({
        "transaction_id": tx["ID"],
        "claim_id": tx["CLAIMID"],
        "charge_line_id": tx["CHARGEID"],
        "patient_id": tx["PATIENTID"],
        "transaction_type": tx["TYPE"],
        "service_date": tx["service_date"].dt.strftime("%Y-%m-%d"),
        "posting_date": tx["posting_date"].dt.strftime("%Y-%m-%d"),
        "amount": tx["amount"].round(2),
        "payment_method": tx["METHOD"],
        "procedure_code": tx["PROCEDURECODE"],
        "procedure_description": tx["NOTES"],
        "department_id": tx["DEPARTMENTID"],
    })
    out["posted_to_gl"] = True      # helper flag; dropped before writing files
    return out.reset_index(drop=True)


def plant_subledger_errors(bill, valid_claim_ids, rng, key):
    fy = bill[(bill["posting_date"] >= "2025-01-01") & (bill["posting_date"] <= "2025-12-31")]
    pays = fy[fy["transaction_type"] == "PAYMENT"]

    # S1: the same payment keyed in twice (new transaction id) -> real overpayment, posted to GL
    dup = pays.sample(30, random_state=SEED).copy()
    dup["transaction_id"] = [str(uuid.UUID(int=int(rng.integers(0, 2**63)))) for _ in range(len(dup))]
    for r in dup.itertuples():
        key.append(("S1", "Subledger", "Duplicate payment posted twice", r.posting_date, r.amount, r.claim_id))

    # S2: payments that point to a claim that doesn't exist -> unapplied cash, posted to GL
    orphan = pays.sample(12, random_state=SEED + 1).copy()
    orphan["transaction_id"] = [str(uuid.UUID(int=int(rng.integers(0, 2**63)))) for _ in range(len(orphan))]
    orphan["claim_id"] = [str(uuid.UUID(int=int(rng.integers(0, 2**63)))) for _ in range(len(orphan))]
    for r in orphan.itertuples():
        key.append(("S2", "Subledger", "Payment with no matching claim", r.posting_date, r.amount, r.claim_id))

    bill = pd.concat([bill, dup, orphan], ignore_index=True)

    # S3: data quality problems. The GL interface rejected these rows, so they
    # never reached the GL. Silver should quarantine them.
    bill["extract_month"] = bill["posting_date"].str[:7]
    idx = bill.sample(40, random_state=SEED + 2).index
    for i in idx:
        key.append(("S3", "Subledger", "Missing amount", bill.at[i, "posting_date"], None, bill.at[i, "claim_id"]))
    bill.loc[idx, "amount"] = np.nan
    bill.loc[idx, "posted_to_gl"] = False

    charges = bill[(bill["transaction_type"] == "CHARGE") & bill["posted_to_gl"]]
    idx = charges.sample(15, random_state=SEED + 3).index
    for i in idx:
        key.append(("S3", "Subledger", "Negative charge amount", bill.at[i, "posting_date"], -bill.at[i, "amount"], bill.at[i, "claim_id"]))
    bill.loc[idx, "amount"] = -bill.loc[idx, "amount"]
    bill.loc[idx, "posted_to_gl"] = False

    idx = bill[bill["posted_to_gl"]].sample(10, random_state=SEED + 4).index
    for i in idx:
        key.append(("S3", "Subledger", "Invalid posting date", bill.at[i, "posting_date"], bill.at[i, "amount"], bill.at[i, "claim_id"]))
    bill.loc[idx, "posting_date"] = "2025-13-45"
    bill.loc[idx, "posted_to_gl"] = False

    # Technical duplicates: identical rows from a re-run extract (same transaction id)
    tech = bill[bill["posted_to_gl"]].sample(50, random_state=SEED + 5).copy()
    tech["posted_to_gl"] = False
    for r in tech.itertuples():
        key.append(("S4", "Subledger", "Exact duplicate row from extract re-run", r.posting_date, r.amount, r.claim_id))
    bill = pd.concat([bill, tech], ignore_index=True)
    return bill


def build_gl(bill, key):
    """Daily batch postings from the billing interface, plus manual journal entries."""
    posted = bill[bill["posted_to_gl"]].copy()
    batches = (posted.groupby(["posting_date", "transaction_type"])["amount"].sum()
               .round(2).reset_index())

    lines, seq = [], 0

    def add_je(posting_date, entries, source, batch_ref, created_by, created_at, desc):
        nonlocal seq
        seq += 1
        je_id = f"JE{seq:06d}"
        for n, (acct, dr, cr) in enumerate(entries, start=1):
            lines.append({
                "je_id": je_id, "je_line": n, "posting_date": posting_date,
                "fiscal_period": posting_date[:7], "account_number": acct,
                "debit": round(dr, 2), "credit": round(cr, 2), "je_source": source,
                "batch_reference": batch_ref, "created_by": created_by,
                "created_at": created_at, "description": desc,
            })

    for b in batches.sort_values(["posting_date", "transaction_type"]).itertuples():
        d, amt = b.posting_date, b.amount
        if b.transaction_type == "CHARGE":
            ref, entries, desc = f"CHG-{d}", [(AR, amt, 0), (REVENUE, 0, amt)], "Daily patient charges"
        else:
            ref, entries, desc = f"PAY-{d}", [(CASH, amt, 0), (AR, 0, amt)], "Daily patient payments"
        post_date, created_at = d, f"{d} 23:30:00"

        # E2: the charge batch for 3 Sep 2025 never reached the GL
        if ref == "CHG-2025-09-03":
            key.append(("E2", "GL", "Charge batch missing from GL", d, amt, ref))
            continue
        # E3: year-end charges posted into January 2026 (cut-off error)
        if ref in ("CHG-2025-12-29", "CHG-2025-12-30", "CHG-2025-12-31"):
            key.append(("E3", "GL", "FY2025 charges posted in FY2026 (cut-off)", d, amt, ref))
            post_date, created_at = "2026-01-02", "2026-01-02 08:15:00"

        add_je(post_date, entries, "BILLING_INTERFACE", ref, "svc_billing_interface", created_at, desc)

        # E1: the payment batch for 16 Jun 2025 was posted twice
        if ref == "PAY-2025-06-16":
            key.append(("E1", "GL", "Payment batch posted twice", d, amt, ref))
            add_je("2025-06-17", entries, "BILLING_INTERFACE", ref, "svc_billing_interface",
                   "2025-06-17 09:12:00", desc)

    # Routine manual entries: monthly bank fees (not revenue or AR)
    for month_end in pd.date_range("2024-01-31", "2026-01-31", freq="BME"):
        d = month_end.strftime("%Y-%m-%d")
        fee = round(900 + (month_end.month * 37.15), 2)
        add_je(d, [(BANK_FEES, fee, 0), (CASH, 0, fee)], "MANUAL", "", "mlee_treasury",
               f"{d} 15:05:00", "Monthly bank service charges")

    # E4: unsupported round-number revenue entry on a Saturday just before year end
    add_je("2025-12-27", [(AR, 250000, 0), (REVENUE, 0, 250000)], "MANUAL", "",
           "jdoe_finance", "2025-12-27 21:47:00", "Revenue true-up per CFO")
    key.append(("E4", "GL", "Unsupported manual revenue entry (weekend, round amount)",
                "2025-12-27", 250000.0, "jdoe_finance"))

    return pd.DataFrame(lines)


def write_monthly(df, folder: Path, prefix: str, month_col: str):
    folder.mkdir(parents=True, exist_ok=True)
    for month, part in df.groupby(month_col):
        part.drop(columns=[month_col]).to_csv(
            folder / f"{prefix}_{month.replace('-', '_')}.csv", index=False)


def main(synthea_dir: Path, out_dir: Path):
    rng = np.random.default_rng(SEED)
    key = []
    tx, claims, encounters, payers = load_synthea(synthea_dir)

    bill = build_billing_extract(tx, claims, encounters, payers, rng)
    valid_claims = set(bill["claim_id"])
    bill = plant_subledger_errors(bill, valid_claims, rng, key)
    gl = build_gl(bill, key)

    # Billing extract: one file per posting month
    write_monthly(bill.drop(columns=["posted_to_gl"]), out_dir / "billing_transactions",
                  "billing_transactions", "extract_month")
    # GL detail: one file per fiscal period
    gl["_month"] = gl["fiscal_period"]
    write_monthly(gl, out_dir / "gl_journal_entries", "gl_journal_entries", "_month")

    coa = pd.DataFrame([
        (CASH, "Cash - Operating", "ASSET", "Cash and cash equivalents"),
        (AR, "Patient Accounts Receivable", "ASSET", "Patient accounts receivable"),
        (REVENUE, "Gross Patient Service Revenue", "REVENUE", "Patient service revenue"),
        (BANK_FEES, "Bank Service Charges", "EXPENSE", "Other operating expenses"),
    ], columns=["account_number", "account_name", "account_type", "fs_line"])
    (out_dir / "chart_of_accounts").mkdir(parents=True, exist_ok=True)
    coa.to_csv(out_dir / "chart_of_accounts" / "chart_of_accounts.csv", index=False)

    # Synthea master data, filtered to claims in the extract
    in_scope = claims[claims["Id"].isin(valid_claims)]
    for name, df in {"claims": in_scope,
                     "encounters": encounters[encounters["Id"].isin(in_scope["APPOINTMENTID"])],
                     "payers": payers}.items():
        (out_dir / name).mkdir(parents=True, exist_ok=True)
        df.to_csv(out_dir / name / f"{name}.csv", index=False)

    pd.DataFrame(key, columns=["error_id", "layer", "description", "date", "amount", "reference"]) \
        .to_csv(out_dir.parent / "answer_key.csv", index=False)
    print(f"billing rows: {len(bill):,} | GL lines: {len(gl):,} | planted errors: {len(key)}")


if __name__ == "__main__":
    p = argparse.ArgumentParser()
    p.add_argument("--synthea-dir", type=Path, required=True)
    p.add_argument("--out-dir", type=Path, required=True)
    a = p.parse_args()
    main(a.synthea_dir, a.out_dir)
