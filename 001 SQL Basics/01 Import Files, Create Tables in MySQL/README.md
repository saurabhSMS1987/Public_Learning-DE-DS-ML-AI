# 🐬 MySQL for Audit Data: Importing Files & Creating Tables

Nine short, hands-on lessons on getting data **into**, **around** and **out of** MySQL. Every lesson uses the same **SAP ERP Trial Balance** example, so each one builds on the last.

> Part of my learning journey in **Data Engineering, Data Science & AI**.

## 📚 Lessons

Work through them in order:

| # | Lesson | What you learn |
| --- | --- | --- |
| 1 | [Creating Tables](creating-tables-in-mysql.md) | `CREATE DATABASE`, `CREATE TABLE`, data types, constraints, `ALTER`, `DROP` |
| 2 | [Importing Excel / CSV](importing-excel-csv-into-mysql.md) | Table Data Import Wizard, field types, finding rows that failed |
| 3 | [Inserting, Updating & Deleting Data](inserting-updating-deleting-data-in-mysql.md) | `INSERT`, upserts, `UPDATE`, `DELETE`, transactions |
| 4 | [Copying Tables](copying-tables-in-mysql.md) | `CREATE TABLE … LIKE` / `AS SELECT`, backups, restore |
| 5 | [Foreign Keys & Related Tables](foreign-keys-and-related-tables-in-mysql.md) | Parent/child tables, orphan rows, `ON DELETE` options |
| 6 | [Indexes](indexes-in-mysql.md) | `CREATE INDEX`, `EXPLAIN`, leftmost-prefix rule |
| 7 | [Bulk Loading with LOAD DATA INFILE](bulk-loading-with-load-data-infile-in-mysql.md) | Fast loads, converting SAP formats while loading |
| 8 | [Staging Tables](staging-tables-in-mysql.md) | Raw text tables, profiling bad rows, `INSERT … SELECT` |
| 9 | [Exporting Data](exporting-data-from-mysql.md) | Result export, Export Wizard, `INTO OUTFILE`, backups |

📝 Quick revision: [SUMMARY.md](SUMMARY.md)

## 🗂️ Sample data

| File | Contents | Used in |
| --- | --- | --- |
| [`sap_trial_balance_fy2026.csv`](data/sap_trial_balance_fy2026.csv) | Trial balance, 19 G/L accounts, clean format (`2026-12-31`, `1800000.00`) | Lessons 1–6, 9 |
| [`sap_trial_balance_fy2026_raw.csv`](data/sap_trial_balance_fy2026_raw.csv) | Same TB in SAP export format (`31.12.2026`, `"540,000.00-"`) | Lessons 7–8 |
| [`sap_chart_of_accounts.csv`](data/sap_chart_of_accounts.csv) | Chart of accounts `YCOA`, 22 G/L accounts, type `BS` / `PL` | Lesson 5 |

The data is made up for practice: company code `1000`, fiscal year 2026, currency USD. Total debits and credits are both **20,774,230.17**, and closing balances sum to **0.00**.

## 🛠️ Setup

See [requirements.txt](requirements.txt). In short:

1. Install **MySQL Server 8.0+** and **MySQL Workbench 8.0+**.
2. Clone or download this repository.
3. Open Workbench, connect to your server and start with **Lesson 1**.

All lessons run in schema `audit_fy2026`.

## 📁 Repository structure

```text
.
├── README.md
├── SUMMARY.md
├── requirements.txt
├── creating-tables-in-mysql.md
├── importing-excel-csv-into-mysql.md
├── inserting-updating-deleting-data-in-mysql.md
├── copying-tables-in-mysql.md
├── foreign-keys-and-related-tables-in-mysql.md
├── indexes-in-mysql.md
├── bulk-loading-with-load-data-infile-in-mysql.md
├── staging-tables-in-mysql.md
├── exporting-data-from-mysql.md
└── data/
    ├── sap_trial_balance_fy2026.csv
    ├── sap_trial_balance_fy2026_raw.csv
    └── sap_chart_of_accounts.csv
```

## 🧭 Why this matters for audit data work

Audit data arrives as files: trial balances, journal entry extracts, vendor masters. Loading them into MySQL correctly is the first control over **completeness and accuracy**: a missing row or a dropped leading zero changes every test that follows.
