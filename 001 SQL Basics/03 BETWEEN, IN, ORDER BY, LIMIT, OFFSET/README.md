# 🔢 MySQL Numeric Queries: BETWEEN, IN, ORDER BY, LIMIT, OFFSET

Five short lessons on retrieving data with numeric filters, sorting and paging, using an **SAP ECC Accounts Payable** extract as the example.

> Part of my learning journey in **Data Engineering, Data Science & AI**.

## 📚 Lessons

| # | Lesson | What it does |
| --- | --- | --- |
| 1 | [BETWEEN](between-in-mysql.md) | Filter a range, both ends included |
| 2 | [IN](in-operator-in-mysql.md) | Filter against a list of values |
| 3 | [ORDER BY](order-by-in-mysql.md) | Sort ascending / descending, by several columns |
| 4 | [LIMIT](limit-in-mysql.md) | Top-N and bottom-N lists |
| 5 | [OFFSET](offset-in-mysql.md) | Paging and the Nth row |

📝 Quick revision: [SUMMARY.md](SUMMARY.md)

## 🗂️ Sample data

[`data/sap_ecc_ap_invoices.csv`](data/sap_ecc_ap_invoices.csv): **26 vendor invoices** from **9 vendors**, company code 1000, fiscal year 2026 (made up for practice). Total **620,123.29**; 8 invoices still open (**270,934.97**).

| Column | SAP field | Meaning | Example |
| --- | --- | --- | --- |
| `BUKRS` | BSIK/BSAK-BUKRS | Company code | `1000` |
| `LIFNR` | BSIK/BSAK-LIFNR | Vendor number | `0000100001` |
| `NAME1` | LFA1-NAME1 | Vendor name | `Steel Supply Co` |
| `BELNR` | BSIK/BSAK-BELNR | Document number | `5100000003` |
| `GJAHR` | BSIK/BSAK-GJAHR | Fiscal year | `2026` |
| `BLART` | BSIK/BSAK-BLART | Document type | `RE` invoice (MM), `KR` invoice (FI), `KG` credit memo |
| `XBLNR` | BSIK/BSAK-XBLNR | Vendor's invoice reference | `INV-5102` |
| `BLDAT` | BSIK/BSAK-BLDAT | Invoice date | `2026-11-25` |
| `BUDAT` | BSIK/BSAK-BUDAT | Posting date | `2026-11-30` |
| `ZTERM` | BSIK/BSAK-ZTERM | Payment terms key | `NT30`, `0001` immediate |
| `ZBD1T` | BSIK/BSAK-ZBD1T | Payment days | `30` |
| `DMBTR` | BSIK/BSAK-DMBTR | Amount (local currency) | `49950.00` |
| `WSKTO` | BSIK/BSAK-WSKTO | Cash discount amount | `146.30` |
| `WAERS` | BSIK/BSAK-WAERS | Currency | `USD` |
| `STATUS` | BSIK = open, BSAK = cleared | Open or paid | `OPEN` |

Built-in red flags to find: invoices just below a 50,000 approval limit, a duplicate invoice (`8812`), repeated `9,999.00` amounts, round amounts, a one-time vendor, and a Sunday posting.

## Setup

Requirements: see [requirements.txt](requirements.txt).

**1 · Create the table** in MySQL Workbench:

```sql
CREATE DATABASE IF NOT EXISTS audit_fy2026;
USE audit_fy2026;

CREATE TABLE ap_invoices (
    bukrs   CHAR(4)        NOT NULL,
    lifnr   VARCHAR(10)    NOT NULL,
    name1   VARCHAR(40)    NOT NULL,
    belnr   VARCHAR(10)    NOT NULL,
    gjahr   SMALLINT       NOT NULL,
    blart   CHAR(2)        NOT NULL,
    xblnr   VARCHAR(16)    NOT NULL,
    bldat   DATE           NOT NULL,
    budat   DATE           NOT NULL,
    zterm   CHAR(4)        NOT NULL,
    zbd1t   SMALLINT       NOT NULL,
    dmbtr   DECIMAL(15,2)  NOT NULL,
    wskto   DECIMAL(15,2)  NOT NULL,
    waers   CHAR(3)        NOT NULL,
    status  VARCHAR(7)     NOT NULL,
    PRIMARY KEY (bukrs, belnr, gjahr)
);
```

**2 · Load the CSV:** right-click `ap_invoices` → **Table Data Import Wizard** → select the CSV → **Use existing table** → **Next** until done.

**3 · Check:** `SELECT COUNT(*) FROM ap_invoices;` → **26**.

## 📁 Repository structure

```text
.
├── README.md
├── SUMMARY.md
├── requirements.txt
├── between-in-mysql.md
├── in-operator-in-mysql.md
├── order-by-in-mysql.md
├── limit-in-mysql.md
├── offset-in-mysql.md
└── data/
    └── sap_ecc_ap_invoices.csv
```
