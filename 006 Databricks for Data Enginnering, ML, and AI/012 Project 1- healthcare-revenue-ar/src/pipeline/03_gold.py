# Databricks notebook source
# =============================================================================
# GOLD LAYER: audit outputs for revenue and accounts receivable (AR)
# -----------------------------------------------------------------------------
# The question the auditor wants answered:
#   "Do revenue and AR in the general ledger (what goes into the financial
#    statements) agree with the billing system (what actually happened)?
#    If not, why not?"
#
# Gold tables:
#   revenue_reconciliation_monthly  - subledger charges vs GL revenue by month
#   ar_rollforward_monthly          - opening + charges - payments = closing, subledger vs GL
#   daily_batch_reconciliation      - every daily billing batch matched to its GL posting
#   reconciling_items               - each difference explained, with its fiscal-year impact
#   ar_aging_year_end               - open AR at year end by payer and age
#   payment_exceptions              - duplicate, unmatched and over-applied payments
#   journal_entry_risk_flags        - manual journal entries scored for risk
#   data_quality_summary            - what was dropped or quarantined, and why
#   audit_summary                   - one-page results for the fiscal year
# =============================================================================

from pyspark import pipelines as dp
from pyspark.sql import functions as F
from pyspark.sql.window import Window

CATALOG = spark.conf.get("audit.catalog", "healthcare_audit")
BRONZE, SILVER, GOLD = f"{CATALOG}.bronze", f"{CATALOG}.silver", f"{CATALOG}.gold"

FISCAL_YEAR = spark.conf.get("audit.fiscal_year", "2025")
FY_START, FY_END = f"{FISCAL_YEAR}-01-01", f"{FISCAL_YEAR}-12-31"
AR_ACCOUNT = "1200"
TOLERANCE = 0.01      # differences smaller than a cent are treated as zero


def billing():
    return spark.read.table(f"{SILVER}.billing_transactions")


def gl():
    return spark.read.table(f"{SILVER}.gl_journal_lines")


def in_fy(col):
    return F.col(col).between(F.lit(FY_START).cast("date"), F.lit(FY_END).cast("date"))


def status(diff_col):
    return F.when(F.abs(F.col(diff_col)) <= TOLERANCE, "RECONCILED").otherwise("DIFFERENCE")


def subledger_batches():
    """Daily subledger totals: one row per posting date and transaction type."""
    return (
        billing()
        .groupBy("posting_date", "transaction_type")
        .agg(F.sum("amount").alias("subledger_amount"),
             F.count("*").alias("transaction_count"))
        .withColumn("batch_reference",
                    F.concat(F.when(F.col("transaction_type") == "CHARGE", "CHG-").otherwise("PAY-"),
                             F.date_format("posting_date", "yyyy-MM-dd")))
    )


def gl_interface_journals():
    """One row per GL journal entry created by the billing interface."""
    return (
        gl().filter(F.col("je_source") == "BILLING_INTERFACE")
        .groupBy("je_id", "batch_reference", "posting_date", "fiscal_period")
        .agg(F.sum("debit").alias("je_amount"))
    )


# -----------------------------------------------------------------------------
# 1. Revenue reconciliation by month
# -----------------------------------------------------------------------------

@dp.materialized_view(
    name=f"{GOLD}.revenue_reconciliation_monthly",
    comment="Gross charges per billing subledger vs revenue per GL, by month.",
)
def revenue_reconciliation_monthly():
    sub = (billing().filter("transaction_type = 'CHARGE'")
           .groupBy(F.col("posting_period").alias("period"))
           .agg(F.sum("amount").alias("subledger_gross_charges")))

    rev = (gl().filter("account_type = 'REVENUE'")
           .withColumn("revenue", F.col("credit") - F.col("debit"))
           .groupBy(F.col("fiscal_period").alias("period"))
           .agg(F.sum("revenue").alias("gl_revenue"),
                F.sum(F.when(~F.col("is_manual"), F.col("revenue")).otherwise(0)).alias("gl_revenue_interface"),
                F.sum(F.when(F.col("is_manual"), F.col("revenue")).otherwise(0)).alias("gl_revenue_manual")))

    return (sub.join(rev, "period", "full_outer")
            .fillna(0, ["subledger_gross_charges", "gl_revenue", "gl_revenue_interface", "gl_revenue_manual"])
            .withColumn("difference", F.col("gl_revenue") - F.col("subledger_gross_charges"))
            .withColumn("status", status("difference"))
            .orderBy("period"))


# -----------------------------------------------------------------------------
# 2. AR roll-forward by month
# -----------------------------------------------------------------------------

@dp.materialized_view(
    name=f"{GOLD}.ar_rollforward_monthly",
    comment="AR roll-forward (opening + charges - payments = closing) per subledger and per GL.",
)
def ar_rollforward_monthly():
    running = Window.orderBy("period").rowsBetween(Window.unboundedPreceding, Window.currentRow)

    sub = (billing()
           .groupBy(F.col("posting_period").alias("period"))
           .agg(F.sum(F.when(F.col("transaction_type") == "CHARGE", F.col("amount")).otherwise(0)).alias("charges"),
                F.sum(F.when(F.col("transaction_type") == "PAYMENT", F.col("amount")).otherwise(0)).alias("payments")))

    gl_ar = (gl().filter(F.col("account_number") == AR_ACCOUNT)
             .groupBy(F.col("fiscal_period").alias("period"))
             .agg(F.sum("net_debit").alias("gl_ar_movement")))

    return (sub.join(gl_ar, "period", "full_outer")
            .fillna(0, ["charges", "payments", "gl_ar_movement"])
            .withColumn("subledger_closing_ar", F.sum(F.col("charges") - F.col("payments")).over(running))
            .withColumn("subledger_opening_ar",
                        F.col("subledger_closing_ar") - F.col("charges") + F.col("payments"))
            .withColumn("gl_closing_ar", F.sum("gl_ar_movement").over(running))
            .withColumn("difference", F.col("gl_closing_ar") - F.col("subledger_closing_ar"))
            .withColumn("status", status("difference"))
            .select("period", "subledger_opening_ar", "charges", "payments", "subledger_closing_ar",
                    "gl_ar_movement", "gl_closing_ar", "difference", "status")
            .orderBy("period"))


# -----------------------------------------------------------------------------
# 3. Daily batch reconciliation: every billing batch vs its GL posting
# -----------------------------------------------------------------------------

@dp.materialized_view(
    name=f"{GOLD}.daily_batch_reconciliation",
    comment="Each daily subledger batch matched to the GL journal(s) that posted it.",
)
def daily_batch_reconciliation():
    gl_batches = (gl_interface_journals()
                  .groupBy("batch_reference")
                  .agg(F.sum("je_amount").alias("gl_amount"),
                       F.countDistinct("je_id").alias("gl_journal_count"),
                       F.array_join(F.array_sort(F.collect_set("fiscal_period")), ", ").alias("gl_periods"),
                       F.min("posting_date").alias("gl_first_posting_date")))

    batch_period = F.date_format("posting_date", "yyyy-MM")
    return (subledger_batches()
            .join(gl_batches, "batch_reference", "full_outer")
            .withColumn("batch_period", batch_period)
            .withColumn("difference",
                        F.coalesce("gl_amount", F.lit(0)) - F.coalesce("subledger_amount", F.lit(0)))
            .withColumn(
                "match_status",
                F.when(F.col("gl_amount").isNull(), "MISSING_IN_GL")
                 .when(F.col("subledger_amount").isNull(), "NOT_IN_SUBLEDGER")
                 .when(F.col("gl_journal_count") > 1, "DUPLICATE_POSTING")
                 .when(F.col("gl_periods") != F.col("batch_period"), "POSTED_IN_WRONG_PERIOD")
                 .when(F.abs(F.col("difference")) > TOLERANCE, "AMOUNT_MISMATCH")
                 .otherwise("MATCHED"))
            .orderBy("batch_reference"))


# -----------------------------------------------------------------------------
# 4. Reconciling items: why the GL differs from the subledger this fiscal year
# -----------------------------------------------------------------------------

@dp.materialized_view(
    name=f"{GOLD}.reconciling_items",
    comment="Every item that explains a fiscal-year difference in revenue or year-end AR.",
)
def reconciling_items():
    fy_end = F.lit(FY_END).cast("date")

    # Subledger side, per batch: amount inside the fiscal year / up to year end
    sub = (subledger_batches()
           .select("batch_reference", "transaction_type",
                   F.col("posting_date").alias("batch_date"),
                   F.when(in_fy("posting_date"), F.col("subledger_amount")).otherwise(0).alias("sub_in_fy"),
                   F.when(F.col("posting_date") <= fy_end, F.col("subledger_amount")).otherwise(0).alias("sub_to_fye")))

    # GL side, per batch: amount booked inside the fiscal year / up to year end
    glb = (gl_interface_journals()
           .groupBy("batch_reference")
           .agg(F.sum(F.when(in_fy("posting_date"), F.col("je_amount")).otherwise(0)).alias("gl_in_fy"),
                F.sum(F.when(F.col("posting_date") <= fy_end, F.col("je_amount")).otherwise(0)).alias("gl_to_fye"),
                F.countDistinct("je_id").alias("gl_journal_count"),
                F.array_join(F.array_sort(F.collect_set("fiscal_period")), ", ").alias("gl_periods")))

    batch_items = (
        sub.join(glb, "batch_reference", "full_outer")
        .fillna(0, ["sub_in_fy", "sub_to_fye", "gl_in_fy", "gl_to_fye", "gl_journal_count"])
        .withColumn("is_charge", F.col("batch_reference").startswith("CHG-"))
        # Charges raise revenue and AR; payments lower AR and don't touch revenue
        .withColumn("revenue_impact",
                    F.when(F.col("is_charge"), F.col("gl_in_fy") - F.col("sub_in_fy")).otherwise(0))
        .withColumn("ar_impact",
                    F.when(F.col("is_charge"), F.col("gl_to_fye") - F.col("sub_to_fye"))
                     .otherwise(-(F.col("gl_to_fye") - F.col("sub_to_fye"))))
        .filter((F.abs("revenue_impact") > TOLERANCE) | (F.abs("ar_impact") > TOLERANCE))
        .withColumn(
            "item_type",
            F.when(F.col("gl_journal_count") == 0, "Batch missing from GL")
             .when(F.col("gl_journal_count") > 1, "Batch posted more than once")
             .when(F.col("gl_to_fye") == 0, "Posted after year end (cut-off)")
             .otherwise("Amount differs"))
        .select("item_type", "batch_reference", "batch_date", "gl_periods",
                F.lit(None).cast("string").alias("je_id"),
                F.lit(None).cast("string").alias("created_by"),
                "revenue_impact", "ar_impact")
    )

    # Manual journal entries that hit revenue or AR during the fiscal year
    hits_rev_or_ar = (F.col("account_type") == "REVENUE") | (F.col("account_number") == AR_ACCOUNT)
    manual = (gl().filter(F.col("is_manual") & in_fy("posting_date") & hits_rev_or_ar)
              .groupBy("je_id", "posting_date", "fiscal_period", "created_by")
              .agg(F.sum(F.when(F.col("account_type") == "REVENUE", F.col("credit") - F.col("debit")).otherwise(0)).alias("revenue_impact"),
                   F.sum(F.when(F.col("account_number") == AR_ACCOUNT, F.col("net_debit")).otherwise(0)).alias("ar_impact"))
              .select(F.lit("Manual journal entry").alias("item_type"),
                      F.lit(None).cast("string").alias("batch_reference"),
                      F.col("posting_date").alias("batch_date"),
                      F.col("fiscal_period").alias("gl_periods"),
                      "je_id", "created_by", "revenue_impact", "ar_impact"))

    return batch_items.unionByName(manual).orderBy("batch_date")


# -----------------------------------------------------------------------------
# 5. AR aging at year end
# -----------------------------------------------------------------------------

@dp.materialized_view(
    name=f"{GOLD}.ar_aging_year_end",
    comment="Open AR per subledger at fiscal year end, by payer and days since service.",
)
def ar_aging_year_end():
    fy_end = F.lit(FY_END).cast("date")
    claim_balances = (
        billing()
        .filter((F.col("posting_date") <= fy_end) & F.col("has_matching_claim"))
        .groupBy("claim_id", "payer_type", "payer_name")
        .agg(F.sum(F.when(F.col("transaction_type") == "CHARGE", F.col("amount"))
                    .otherwise(-F.col("amount"))).alias("open_balance"),
             F.min("service_date").alias("service_date"))
        .filter(F.abs("open_balance") > TOLERANCE)
        .withColumn("days_outstanding", F.datediff(fy_end, F.col("service_date")))
    )
    bucket = (F.when(F.col("open_balance") < 0, "Credit balance")
               .when(F.col("days_outstanding") <= 30, "0-30 days")
               .when(F.col("days_outstanding") <= 60, "31-60 days")
               .when(F.col("days_outstanding") <= 90, "61-90 days")
               .when(F.col("days_outstanding") <= 180, "91-180 days")
               .otherwise("Over 180 days"))
    order = (F.when(F.col("aging_bucket") == "0-30 days", 1).when(F.col("aging_bucket") == "31-60 days", 2)
              .when(F.col("aging_bucket") == "61-90 days", 3).when(F.col("aging_bucket") == "91-180 days", 4)
              .when(F.col("aging_bucket") == "Over 180 days", 5).otherwise(6))
    return (claim_balances.withColumn("aging_bucket", bucket)
            .groupBy("payer_type", "payer_name", "aging_bucket")
            .agg(F.count("*").alias("claim_count"), F.sum("open_balance").alias("open_balance"))
            .withColumn("bucket_order", order)
            .orderBy("payer_type", "payer_name", "bucket_order"))


# -----------------------------------------------------------------------------
# 6. Payment exceptions
# -----------------------------------------------------------------------------

@dp.materialized_view(
    name=f"{GOLD}.payment_exceptions",
    comment="Payments needing follow-up: duplicates, payments without a claim, and claims paid more than billed.",
)
def payment_exceptions():
    pays = billing().filter("transaction_type = 'PAYMENT'")

    # The same charge line paid more than once (different transaction ids)
    dup_window = Window.partitionBy("claim_id", "charge_line_id").orderBy("posting_date", "transaction_id")
    duplicates = (pays.withColumn("_n", F.row_number().over(dup_window))
                  .filter("_n > 1")
                  .select(F.lit("Duplicate payment").alias("exception_type"), "claim_id",
                          "transaction_id", "posting_date", "payer_name", "amount"))

    # Cash received that can't be matched to any claim
    unmatched = (pays.filter(~F.col("has_matching_claim"))
                 .select(F.lit("Payment with no matching claim").alias("exception_type"), "claim_id",
                         "transaction_id", "posting_date", "payer_name", "amount"))

    # Claims where payments exceed charges (patient or insurer owed a refund)
    credit = (billing().filter(F.col("has_matching_claim"))
              .groupBy("claim_id", "payer_name")
              .agg(F.sum(F.when(F.col("transaction_type") == "CHARGE", F.col("amount")).otherwise(-F.col("amount"))).alias("balance"),
                   F.max("posting_date").alias("posting_date"))
              .filter(F.col("balance") < -TOLERANCE)
              .select(F.lit("Claim paid more than billed (credit balance)").alias("exception_type"), "claim_id",
                      F.lit(None).cast("string").alias("transaction_id"), "posting_date", "payer_name",
                      (-F.col("balance")).alias("amount")))

    # Why might a claim show a credit balance? Check the two usual suspects.
    dup_claims = duplicates.select("claim_id").distinct().withColumn("_dup", F.lit(True))
    quarantined_charges = (spark.read.table(f"{SILVER}.billing_transactions_quarantine")
                           .filter("transaction_type = 'CHARGE'")
                           .select("claim_id").distinct().withColumn("_qc", F.lit(True)))
    credit = (credit.join(dup_claims, "claim_id", "left").join(quarantined_charges, "claim_id", "left")
              .withColumn("likely_cause",
                          F.when(F.col("_dup"), "Duplicate payment on this claim")
                           .when(F.col("_qc"), "A charge on this claim failed data quality checks (quarantined)")
                           .otherwise("Needs investigation"))
              .drop("_dup", "_qc"))

    duplicates = duplicates.withColumn("likely_cause", F.lit("Same charge line paid twice under different transaction ids"))
    unmatched = unmatched.withColumn("likely_cause", F.lit("Claim id not found in claims master: unapplied cash"))
    return duplicates.unionByName(unmatched).unionByName(credit).orderBy("exception_type", "posting_date")


# -----------------------------------------------------------------------------
# 7. Manual journal entry risk flags
# -----------------------------------------------------------------------------

@dp.materialized_view(
    name=f"{GOLD}.journal_entry_risk_flags",
    comment="Manual journal entries scored on common fraud-risk indicators.",
)
def journal_entry_risk_flags():
    je = (gl().filter("is_manual")
          .groupBy("je_id", "posting_date", "fiscal_period", "created_by", "created_at", "description")
          .agg(F.sum("debit").alias("je_amount"),
               F.array_join(F.array_sort(F.collect_set("account_name")), ", ").alias("accounts"),
               F.max(F.when((F.col("account_type") == "REVENUE") | (F.col("account_number") == AR_ACCOUNT), 1)
                      .otherwise(0)).alias("hits_revenue_or_ar")))

    fy_end = F.lit(FY_END).cast("date")
    flags = {
        "flag_weekend": F.dayofweek("posting_date").isin(1, 7),
        "flag_round_amount": (F.col("je_amount") % 1000 == 0),
        "flag_near_year_end": F.datediff(fy_end, F.col("posting_date")).between(0, 7),
        "flag_after_hours": (F.hour("created_at") < 7) | (F.hour("created_at") >= 20),
        "flag_hits_revenue_or_ar": F.col("hits_revenue_or_ar") == 1,
    }
    for name, cond in flags.items():
        je = je.withColumn(name, cond)
    score = sum(F.col(n).cast("int") for n in flags)
    return (je.drop("hits_revenue_or_ar")
            .withColumn("risk_score", score)
            .withColumn("risk_level", F.when(F.col("risk_score") >= 3, "HIGH")
                        .when(F.col("risk_score") == 2, "MEDIUM").otherwise("LOW"))
            .orderBy(F.col("risk_score").desc(), "posting_date"))


# -----------------------------------------------------------------------------
# 8. Data quality summary
# -----------------------------------------------------------------------------
# Note: pipeline datasets must be built from DataFrame transformations only
# (no .count() / .collect()), so every metric below is an aggregation.

def _metric(df, label, count_expr, amount_expr=F.lit(None).cast("double")):
    return df.agg(count_expr.cast("long").alias("row_count"), amount_expr.cast("double").alias("amount")) \
             .select(F.lit(label).alias("metric"), "row_count", "amount")


@dp.materialized_view(
    name=f"{GOLD}.data_quality_summary",
    comment="Row counts through the billing pipeline: loaded, de-duplicated, quarantined, clean.",
)
def data_quality_summary():
    bronze = spark.read.table(f"{BRONZE}.billing_transactions")
    quarantine = (spark.read.table(f"{SILVER}.billing_transactions_quarantine")
                  .groupBy("quarantine_reason")
                  .agg(F.count("*").cast("long").alias("row_count"), F.sum("amount").cast("double").alias("amount"))
                  .select(F.concat(F.lit("3. Quarantined: "), "quarantine_reason").alias("metric"), "row_count", "amount"))
    return (_metric(bronze, "1. Rows loaded into Bronze", F.count("*"))
            .unionByName(_metric(bronze, "2. Exact duplicate rows removed",
                                 F.count("*") - F.countDistinct("transaction_id")))
            .unionByName(quarantine)
            .unionByName(_metric(billing(), "4. Clean rows in Silver", F.count("*"), F.sum("amount")))
            .orderBy("metric"))


# -----------------------------------------------------------------------------
# 9. Audit summary for the fiscal year
# -----------------------------------------------------------------------------

@dp.materialized_view(
    name=f"{GOLD}.audit_summary",
    comment="Headline revenue and AR results for the fiscal year under audit.",
)
def audit_summary():
    fy_end = F.lit(FY_END).cast("date")
    signed = F.when(F.col("transaction_type") == "CHARGE", F.col("amount")).otherwise(-F.col("amount"))

    sub = billing().agg(
        F.sum(F.when((F.col("transaction_type") == "CHARGE") & in_fy("posting_date"), F.col("amount"))).alias("sub_rev"),
        F.sum(F.when(F.col("posting_date") <= fy_end, signed)).alias("sub_ar"))
    gen = gl().agg(
        F.sum(F.when((F.col("account_type") == "REVENUE") & in_fy("posting_date"),
                     F.col("credit") - F.col("debit"))).alias("gl_rev"),
        F.sum(F.when((F.col("account_number") == AR_ACCOUNT) & (F.col("posting_date") <= fy_end),
                     F.col("net_debit"))).alias("gl_ar"))
    items = spark.read.table(f"{GOLD}.reconciling_items").agg(
        F.sum("revenue_impact").alias("items_rev"), F.sum("ar_impact").alias("items_ar"),
        F.sum(F.abs("revenue_impact")).alias("items_rev_gross"), F.count("*").alias("items_count"))
    old_ar = spark.read.table(f"{GOLD}.ar_aging_year_end").agg(
        F.sum(F.when(F.col("aging_bucket") == "Over 180 days", F.col("open_balance"))).alias("ar_over_180"))
    risky = spark.read.table(f"{GOLD}.journal_entry_risk_flags").agg(
        F.sum(F.when(F.col("risk_level") == "HIGH", 1).otherwise(0)).alias("high_risk_jes"))

    one_row = sub.crossJoin(gen).crossJoin(items).crossJoin(old_ar).crossJoin(risky)
    one_row = one_row.select([F.coalesce(F.col(c).cast("double"), F.lit(0.0)).alias(c) for c in one_row.columns])
    one_row = (one_row.withColumn("rev_diff", F.col("gl_rev") - F.col("sub_rev"))
                      .withColumn("ar_diff", F.col("gl_ar") - F.col("sub_ar")))

    metrics = [
        ("Revenue", "Gross charges per billing subledger", "sub_rev"),
        ("Revenue", "Revenue per general ledger", "gl_rev"),
        ("Revenue", "Difference (GL - subledger)", "rev_diff"),
        ("Revenue", "Explained by reconciling items (net)", "items_rev"),
        ("Revenue", "Gross value of reconciling items", "items_rev_gross"),
        ("Revenue", "Unexplained difference", "rev_diff - items_rev"),
        ("AR", "Year-end AR per billing subledger", "sub_ar"),
        ("AR", "Year-end AR per general ledger", "gl_ar"),
        ("AR", "Difference (GL - subledger)", "ar_diff"),
        ("AR", "Explained by reconciling items (net)", "items_ar"),
        ("AR", "Unexplained difference", "ar_diff - items_ar"),
        ("AR", "Open AR older than 180 days", "ar_over_180"),
        ("Exceptions", "Reconciling items (count)", "items_count"),
        ("Exceptions", "High-risk manual journal entries (count)", "high_risk_jes"),
    ]
    stack = "stack({n}, {rows}) AS (area, metric, value)".format(
        n=len(metrics), rows=", ".join(f"'{a}', '{m}', CAST({e} AS DOUBLE)" for a, m, e in metrics))
    headline = one_row.selectExpr(stack).withColumn("value", F.round("value", 2))

    exceptions = (spark.read.table(f"{GOLD}.payment_exceptions")
                  .groupBy("exception_type").agg(F.count("*").cast("double").alias("value"))
                  .select(F.lit("Exceptions").alias("area"),
                          F.concat("exception_type", F.lit(" (count)")).alias("metric"), "value"))
    return headline.unionByName(exceptions)
