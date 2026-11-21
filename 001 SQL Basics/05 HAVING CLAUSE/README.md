# 🧮 HAVING Clause in SQL

A short lesson on filtering aggregated results with `HAVING`, using **SAP revenue (billing) data** for a revenue audit.

> Part of my learning journey in **Data Engineering, Data Science & AI**.

## 📚 Lesson

| Lesson | What it covers |
| --- | --- |
| [HAVING Clause in SQL](having-clause-in-sql.md) | `WHERE` vs `HAVING`, aggregates and subqueries in `HAVING`, audit examples |

📝 Quick revision: [SUMMARY.md](SUMMARY.md)

## 🗂️ Sample data

[`data/sap_revenue_billing_fy2026.csv`](data/sap_revenue_billing_fy2026.csv): **30 billing lines**, 25 documents, 6 customers, January 2026 to January 2027 (made up for practice).

| Column | Meaning |
| --- | --- |
| `VBELN` / `POSNR` | Billing document / item |
| `FKART` | Billing type: `F2` invoice, `G2` credit memo |
| `FKDAT` | Billing date |
| `KUNAG` / `NAME1` / `REGION` | Customer number / name / region |
| `MATNR` / `MAKTX` | Material / description |
| `FKIMG` / `NETPR` / `NETWR` | Quantity / unit price / net value (negative for credits) |
| `WAERK` / `ERNAM` | Currency / created by |

## Setup

Requirements: see [requirements.txt](requirements.txt).

```sql
CREATE DATABASE IF NOT EXISTS audit_fy2026;
USE audit_fy2026;

CREATE TABLE revenue_lines (
    vbeln   VARCHAR(10)    NOT NULL,
    posnr   CHAR(6)        NOT NULL,
    fkart   CHAR(2)        NOT NULL,
    fkdat   DATE           NOT NULL,
    kunag   VARCHAR(10)    NOT NULL,
    name1   VARCHAR(40)    NOT NULL,
    region  VARCHAR(20)    NOT NULL,
    matnr   VARCHAR(18)    NOT NULL,
    maktx   VARCHAR(40)    NOT NULL,
    fkimg   DECIMAL(13,3)  NOT NULL,
    netpr   DECIMAL(11,2)  NOT NULL,
    netwr   DECIMAL(15,2)  NOT NULL,
    waerk   CHAR(3)        NOT NULL,
    ernam   VARCHAR(12)    NOT NULL,
    PRIMARY KEY (vbeln, posnr)
);
```

Load the CSV with **Table Data Import Wizard** → **Use existing table**, then check `SELECT COUNT(*) FROM revenue_lines;` → **30**.

## 📁 Repository structure

```text
.
├── README.md
├── SUMMARY.md
├── requirements.txt
├── having-clause-in-sql.md
└── data/
    └── sap_revenue_billing_fy2026.csv
```
