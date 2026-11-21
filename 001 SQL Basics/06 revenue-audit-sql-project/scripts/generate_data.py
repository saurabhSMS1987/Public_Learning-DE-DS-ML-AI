"""
Generate the sample SAP SD revenue data used in this project.

Creates three CSV files in ../data:
  customers.csv          customer master (like SAP table KNA1)
  materials.csv          material master with list prices (like MARA/MAKT)
  billing_lines_raw.csv  billing lines in SAP export format (like VBRK/VBRP)

Uses only the Python standard library. The random seed is fixed,
so every run produces exactly the same files.

Run from the project root:  python scripts/generate_data.py
"""
import csv
import datetime as dt
import random
from pathlib import Path

random.seed(2026)
DATA = Path(__file__).resolve().parent.parent / "data"
DATA.mkdir(exist_ok=True)

# ---------------------------------------------------------------- customers
CUSTOMERS = [
    # kunnr, name, region, country, group, created on, credit limit
    ("0000100001", "Acme Retail",            "Midwest",   "US", "01", "2019-03-14", 400000),
    ("0000100002", "Northwind Stores",       "Northeast", "US", "01", "2018-07-02", 350000),
    ("0000100003", "Müller GmbH",            "Export",    "DE", "03", "2020-01-20", 300000),
    ("0000100004", "Sunrise Hospitals",      "South",     "US", "02", "2017-11-05", 250000),
    ("0000100005", "Pacific Traders",        "West",      "US", "01", "2021-04-18", 200000),
    ("0000100006", "Great Lakes Supply",     "Midwest",   "US", "01", "2016-09-09", 300000),
    ("0000100007", "Bayview Construction",   "West",      "US", "04", "2022-02-11", 250000),
    ("0000100008", "Lone Star Builders",     "South",     "US", "04", "2019-06-30", 300000),
    ("0000100009", "Hudson Facilities",      "Northeast", "US", "02", "2020-10-01", 150000),
    ("0000100010", "Rocky Mountain Metals",  "West",      "US", "01", "2018-05-22", 250000),
    ("0000100011", "Gulf Coast Marine",      "South",     "US", "04", "2021-08-16", 200000),
    ("0000100012", "Prairie Agro Co",        "Midwest",   "US", "01", "2023-01-09", 150000),
    ("0000100013", "Toronto Steelworks",     "Export",    "CA", "03", "2019-12-03", 250000),
    ("0000100014", "Atlantic Hospitals",     "Northeast", "US", "02", "2018-02-27", 200000),
    ("0000100015", "Desert Solar LLC",       "West",      "US", "04", "2024-03-12", 150000),
    ("0000100016", "Monterrey Industrial",   "Export",    "MX", "03", "2022-06-07", 200000),
    ("0000100017", "Bluegrass Equipment",    "South",     "US", "01", "2020-04-25", 150000),
    ("0000100018", "Cascade Timber",         "West",      "US", "04", "2017-08-19", 200000),
    ("0000100019", "Empire State Retail",    "Northeast", "US", "01", "2023-09-30", 200000),
    ("0000100020", "Delta Distributors",     "South",     "US", "01", "2026-12-15", 50000),   # red flag: new at year-end
]
GROUPS = {"01": "Wholesale", "02": "Healthcare", "03": "Export", "04": "Construction"}

# ---------------------------------------------------------------- materials
MATERIALS = [
    # matnr, description, product group, list price, typical qty range
    ("P-100", "Steel beam",            "Steel",     1250.00, (5, 40)),
    ("P-200", "Steel sheet",           "Steel",      480.00, (10, 80)),
    ("P-300", "Fastener box",          "Hardware",    35.50, (50, 500)),
    ("P-400", "Installation service",  "Services",   150.00, (8, 60)),
    ("P-500", "Aluminium panel",       "Aluminium",  320.00, (10, 60)),
    ("P-600", "Welding rod pack",      "Hardware",    85.00, (20, 150)),
    ("P-700", "Maintenance contract",  "Services",  2400.00, (1, 3)),
    ("P-800", "Copper cable drum",     "Electrical", 960.00, (2, 20)),
]
MAT = {m[0]: m for m in MATERIALS}


def sap_date(d):
    """2026-12-31 -> 31.12.2026 (SAP export format)."""
    return d.strftime("%d.%m.%Y")


def sap_num(x, decimals=2):
    """-1234.5 -> '1,234.50-' (thousands separator, trailing minus)."""
    s = f"{abs(x):,.{decimals}f}"
    return s + "-" if x < 0 else s


def business_day(d):
    while d.weekday() >= 5:
        d += dt.timedelta(days=1)
    return d


lines = []          # dicts in final, clean form
doc_no = 90000000


def add_doc(fkart, fkdat, kunag, items, ernam, vgbel=""):
    """items: list of (matnr, qty, price)"""
    global doc_no
    doc_no += 1
    for i, (m, q, p) in enumerate(items, 1):
        lines.append(dict(vbeln=f"{doc_no:010d}", posnr=f"{i*10:06d}", fkart=fkart, fkdat=fkdat,
                          kunag=kunag, matnr=m, fkimg=q, netpr=p, netwr=round(q * p, 2),
                          waerk="USD", ernam=ernam, vgbel=vgbel))
    return f"{doc_no:010d}"


regular = [c[0] for c in CUSTOMERS if c[0] != "0000100020"]
start = dt.date(2026, 1, 2)
invoices = []

# ---- normal billing through the year (batch job, list price, small discounts)
day = start
while day <= dt.date(2026, 12, 22):
    day = business_day(day)
    for _ in range(random.choice([2, 2, 3, 3])):
        cust = random.choice(regular)
        items = []
        for m in random.sample(list(MAT), random.choice([1, 1, 2, 3])):
            lo, hi = MAT[m][4]
            price = MAT[m][3]
            if random.random() < 0.15:                       # occasional negotiated discount
                price = round(price * random.choice([0.95, 0.9]), 2)
            items.append((m, random.randint(lo, hi), price))
        user = "BATCH_SD" if random.random() < 0.85 else random.choice(["SD_CLERK1", "SD_CLERK2"])
        invoices.append(add_doc("F2", day, cust, items, user))
    day += dt.timedelta(days=random.choice([1, 1, 2]))

# ---- normal year-end billing 23-31 Dec (busier than usual)
for d in [dt.date(2026, 12, x) for x in (23, 24, 28, 29, 30, 31)]:
    for _ in range(4):
        cust = random.choice(regular)
        m = random.choice(list(MAT))
        lo, hi = MAT[m][4]
        invoices.append(add_doc("F2", d, cust, [(m, random.randint(lo, hi), MAT[m][3])], "BATCH_SD"))

# ---- red flag 1: new customer, large manual year-end sales above list price
delta_docs = [
    add_doc("F2", dt.date(2026, 12, 29), "0000100020", [("P-100", 80, 1950.00)], "SALES_MGR"),
    add_doc("F2", dt.date(2026, 12, 30), "0000100020", [("P-800", 60, 1490.00)], "SALES_MGR"),
    add_doc("F2", dt.date(2026, 12, 31), "0000100020", [("P-200", 150, 480.00), ("P-500", 120, 320.00)], "SALES_MGR"),
]
# ---- red flag 2: round-amount manual invoice on the last day by SALES_MGR
add_doc("F2", dt.date(2026, 12, 31), "0000100001", [("P-700", 25, 2400.00)], "SALES_MGR")   # 60,000.00
# ---- red flag 3: weekend billing (manual)
add_doc("F2", dt.date(2026, 6, 13), "0000100008", [("P-100", 30, 1250.00)], "SD_CLERK2")    # Saturday
add_doc("F2", dt.date(2026, 12, 27), "0000100019", [("P-800", 15, 960.00)], "SALES_MGR")    # Sunday
# ---- red flag 4: zero-price lines (free goods / pricing errors)
for d, c in [(dt.date(2026, 3, 18), "0000100002"), (dt.date(2026, 8, 7), "0000100009"),
             (dt.date(2026, 11, 4), "0000100014")]:
    add_doc("F2", d, c, [("P-300", random.randint(50, 200), 0.00)], "SD_CLERK1")
# ---- red flag 5: duplicate billing (same customer, material, qty, price, date)
for src in random.sample(invoices[50:600], 3):
    first = [l for l in lines if l["vbeln"] == src][0]
    add_doc("F2", first["fkdat"], first["kunag"], [(first["matnr"], first["fkimg"], first["netpr"])], first["ernam"])

# ---- normal credit memos (returns) during the year, referencing the invoice
for src in random.sample(invoices[20:700], 25):
    first = [l for l in lines if l["vbeln"] == src][0]
    back = max(1, int(first["fkimg"] * random.choice([0.1, 0.2, 0.5])))
    d = business_day(first["fkdat"] + dt.timedelta(days=random.randint(7, 30)))
    if d.year == 2026:
        add_doc("G2", d, first["kunag"], [(first["matnr"], -back, first["netpr"])], "SD_CLERK1", vgbel=src)

# ---- red flag 6: January 2027 credit memos reversing the Delta year-end sales (cut-off)
add_doc("G2", dt.date(2027, 1, 6), "0000100020", [("P-100", -80, 1950.00)], "SALES_MGR", vgbel=delta_docs[0])
add_doc("G2", dt.date(2027, 1, 8), "0000100020", [("P-800", -60, 1490.00)], "SALES_MGR", vgbel=delta_docs[1])
# ---- normal January 2027 invoices (next period, present in the extract)
for d in [dt.date(2027, 1, x) for x in (4, 5, 6, 7)]:
    cust = random.choice(regular)
    m = random.choice(list(MAT))
    lo, hi = MAT[m][4]
    add_doc("F2", d, cust, [(m, random.randint(lo, hi), MAT[m][3])], "BATCH_SD")

lines.sort(key=lambda l: (l["vbeln"], l["posnr"]))

# ---------------------------------------------------------------- write files
with open(DATA / "customers.csv", "w", newline="", encoding="utf-8") as f:
    w = csv.writer(f, lineterminator="\r\n")
    w.writerow(["KUNNR", "NAME1", "REGION", "LAND1", "KDGRP", "KDGRP_TEXT", "ERDAT", "KLIMK"])
    for k, n, r, c, g, e, lim in CUSTOMERS:
        w.writerow([k, n, r, c, g, GROUPS[g], e, f"{lim:.2f}"])

with open(DATA / "materials.csv", "w", newline="", encoding="utf-8") as f:
    w = csv.writer(f, lineterminator="\r\n")
    w.writerow(["MATNR", "MAKTX", "MATKL_TEXT", "LIST_PRICE"])
    for m, d, g, p, _ in MATERIALS:
        w.writerow([m, d, g, f"{p:.2f}"])

with open(DATA / "billing_lines_raw.csv", "w", newline="", encoding="utf-8") as f:
    w = csv.writer(f, lineterminator="\r\n")
    w.writerow(["VBELN", "POSNR", "FKART", "FKDAT", "KUNAG", "MATNR", "FKIMG", "NETPR", "NETWR", "WAERK", "ERNAM", "VGBEL"])
    for l in lines:
        w.writerow([l["vbeln"], l["posnr"], l["fkart"], sap_date(l["fkdat"]), l["kunag"], l["matnr"],
                    sap_num(l["fkimg"], 0), sap_num(l["netpr"]), sap_num(l["netwr"]), l["waerk"], l["ernam"], l["vgbel"]])
    # ---- data-quality problems typical of a raw SAP extract (caught in step 3)
    w.writerow(["0091000001", "000010", "F2", sap_date(dt.date(2026, 7, 9)), "0000199999", "P-200",
                "20", "480.00", "9,600.00", "USD", "SD_CLERK2", ""])        # customer not in master data
    w.writerow(["0091000002", "000010", "F2", "", "0000100003", "P-100",
                "10", "1,250.00", "12,500.00", "USD", "SD_CLERK2", ""])     # missing billing date
    total = sum(l["netwr"] for l in lines)
    w.writerow(["", "", "", "", "", "", "", "", sap_num(total), "USD", "", ""])   # report total line

print(f"customers: {len(CUSTOMERS)}  materials: {len(MATERIALS)}  "
      f"billing lines: {len(lines)} (+3 problem rows)  documents: {len({l['vbeln'] for l in lines})}")
