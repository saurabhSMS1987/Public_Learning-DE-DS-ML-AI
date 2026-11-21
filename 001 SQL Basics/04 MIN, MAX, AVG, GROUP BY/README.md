# 📊 MySQL Summary Analytics: MIN, MAX, AVG, GROUP BY

Four short lessons on summarising data with aggregate functions, using **SAP revenue (billing) data** for a revenue audit as the example.

> Part of my learning journey in **Data Engineering, Data Science & AI**.

## 📚 Lessons

| # | Lesson | What it does |
| --- | --- | --- |
| 1 | [MIN](min-in-mysql.md) | Smallest value, earliest date |
| 2 | [MAX](max-in-mysql.md) | Largest value, latest date |
| 3 | [AVG](avg-in-mysql.md) | Average; simple vs weighted |
| 4 | [GROUP BY](group-by-in-mysql.md) | Aggregates per customer, month, region; `HAVING` |

📝 Quick revision: [SUMMARY.md](SUMMARY.md)

## 🗂️ Sample data

[`data/sap_revenue_billing_fy2026.csv`](data/sap_revenue_billing_fy2026.csv): **30 billing lines** in **25 documents** (23 invoices, 2 credit memos), 6 customers, 4 products, January 2026 to January 2027 (made up for practice). FY2026 net revenue: **756,175.00**.

| Column | SAP field | Meaning | Example |
| --- | --- | --- | --- |
| `VBELN` | VBRK-VBELN | Billing document | `90000022` |
| `POSNR` | VBRP-POSNR | Item | `000010` |
| `FKART` | VBRK-FKART | Billing type | `F2` invoice, `G2` credit memo |
| `FKDAT` | VBRK-FKDAT | Billing date | `2026-12-30` |
| `KUNAG` | VBRK-KUNAG | Customer (sold-to) | `0000100006` |
| `NAME1` | KNA1-NAME1 | Customer name | `Delta Distributors` |
| `REGION` | KNA1-REGIO (simplified) | Sales region | `South` |
| `MATNR` | VBRP-MATNR | Material | `P-100` |
| `MAKTX` | MAKT-MAKTX | Material description | `Steel beam` |
| `FKIMG` | VBRP-FKIMG | Billed quantity (negative for credits) | `80` |
| `NETPR` | VBRP-NETPR (derived) | Net unit price | `1950.00` |
| `NETWR` | VBRP-NETWR | Net value (negative for credits) | `156000.00` |
| `WAERK` | VBRK-WAERK | Currency | `USD` |
| `ERNAM` | VBRK-ERNAM | Created by | `SALES_MGR` |

Built-in revenue red flags to find: a **December spike** (40% of the year), a **new customer** billed only on 30–31 December at an **above-list price**, manual year-end billing by `SALES_MGR`, a **January credit memo** reversing the largest December sale (cut-off), and a **zero-value** line.

## Setup

Requirements: see [requirements.txt](requirements.txt).

**1 · Create the table** in MySQL Workbench:

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

**2 · Load the CSV:** right-click `revenue_lines` → **Table Data Import Wizard** → select the CSV → **Use existing table** → **Next** until done.

**3 · Check:** `SELECT COUNT(*) FROM revenue_lines;` → **30**.

## 📁 Repository structure

```text
.
├── README.md
├── SUMMARY.md
├── requirements.txt
├── min-in-mysql.md
├── max-in-mysql.md
├── avg-in-mysql.md
├── group-by-in-mysql.md
└── data/
    └── sap_revenue_billing_fy2026.csv
```
