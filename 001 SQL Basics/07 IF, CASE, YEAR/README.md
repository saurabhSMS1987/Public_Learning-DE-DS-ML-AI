# 🧮 MySQL Calculated Columns: IF, CASE, YEAR, Current Year

Four short lessons on adding calculated columns (flags, categories, years and ages), using **SAP Capital Work in Progress (CWIP)** data from a fixed-asset audit.

> Part of my learning journey in **Data Engineering, Data Science & AI**.

## 📚 Lessons

| # | Lesson | What it does |
| --- | --- | --- |
| 1 | [IF](if-in-mysql.md) | Two-way flags, conditional totals, `IFNULL` |
| 2 | [CASE](case-in-mysql.md) | Multi-way categories, aging buckets, risk flags, pivots |
| 3 | [YEAR](year-in-mysql.md) | Group/filter by year, ages, fiscal years |
| 4 | [Current year](current-year-in-mysql.md) | `CURDATE()`, `YEAR(CURDATE())`, YTD, fixed audit dates |

📝 Quick revision: [SUMMARY.md](SUMMARY.md) · 🎤 [Top 10 interview questions](INTERVIEW_QUESTIONS.md)

> The current year in MySQL is `YEAR(CURDATE())`.

## 🏗️ What is CWIP?

**Capital Work in Progress** holds the costs of assets still being built (a warehouse, a machine, an IT system). In SAP they sit on an **asset under construction (AuC)**, usually linked to a WBS element. When the project is complete, the costs are **settled** to a final fixed asset and depreciation starts.

Key audit risks: completed projects **not capitalised** (depreciation missing), **stale** projects that may be impaired, **repairs** wrongly capitalised, **budget overruns**, and **settlement errors**.

## 🗂️ Sample data

[`data/sap_cwip_fy2026.csv`](data/sap_cwip_fy2026.csv): **24 assets under construction**, 2 plants, 4 project types, as at **31 December 2026** (made up for practice). CWIP balance: **9,649,250.00**.

| Column | SAP source | Meaning | Example |
| --- | --- | --- | --- |
| `ANLN1` | ANLA-ANLN1 | AuC asset number | `4000000001` |
| `TXT50` | ANLA-TXT50 | Description | `New warehouse building` |
| `POSID` | PRPS-POSID | WBS element / project | `P-1001` |
| `PROJ_TYPE` | (asset class group) | Building, Machinery, IT, Vehicles | `Building` |
| `WERKS` | ANLZ-WERKS | Plant | `1000` |
| `START_DATE` | PROJ / ANLA | Project start | `2025-03-01` |
| `PLAN_END` | PRPS | Planned completion | `2026-09-30` |
| `ACT_END` | PRPS | Actual completion (blank = not finished) | `2026-11-20` |
| `STATUS` | JEST (system status) | `REL` released, `TECO` technically complete, `CLSD` closed | `TECO` |
| `BUDGET` | BPGE | Approved budget | `2500000.00` |
| `COST_TO_DATE` | ANLC | Costs capitalised on the AuC | `2780000.00` |
| `SETTLED` | ANLC | Amount settled to final assets | `0.00` |
| `LAST_POST` | ANEP | Last cost posting (blank = none) | `2026-12-18` |
| `RESP` | PRPS-VERNR | Person responsible | `J.Park` |

**CWIP balance = `cost_to_date - settled`.**

Built-in red flags: 6 **completed but not capitalised** (2.5 million), 4 **stale** projects (no postings for 12+ months), 3 **overdue**, 4 **over budget**, 3 **repair/maintenance** items in CWIP, and 1 **over-settled** asset (negative balance).

## Setup

Requirements: see [requirements.txt](requirements.txt).

**Option A (recommended):** from this folder, run

```bash
mysql --local-infile=1 -u root -p < setup.sql
```

`setup.sql` creates `audit_fy2026.cwip_assets`, loads the CSV (blank dates become `NULL`) and shows **24 rows**, balance **9,649,250.00**. If loading is refused, run `SET GLOBAL local_infile = 1;` as root first.

**Option B (MySQL Workbench):** open `setup.sql`, replace `'data/sap_cwip_fy2026.csv'` with the full path (forward slashes), add `OPT_LOCAL_INFILE=1` under **Edit Connection → Advanced → Others**, and run it.

> The Import Wizard can skip rows whose blank dates fail to convert, so use `setup.sql` for this dataset.

## Real-world examples

Each lesson ends with extra snippets on other audit data from my earlier sections, in the same `audit_fy2026` database:

| Table | Section |
| --- | --- |
| `je_lines` | SQL Basics: SELECT, WHERE, DISTINCT, LIKE, LIMIT |
| `ap_invoices` | Numeric Queries: BETWEEN, IN, ORDER BY, LIMIT, OFFSET |
| `revenue_lines` | Summary Analytics: MIN, MAX, AVG, GROUP BY |
| `trial_balance` | Importing Files & Creating Tables |

## 📁 Repository structure

```text
.
├── README.md
├── SUMMARY.md
├── INTERVIEW_QUESTIONS.md
├── requirements.txt
├── setup.sql                  ← creates and loads cwip_assets
├── .gitattributes             ← keeps the CSV's Windows line endings intact
├── if-in-mysql.md
├── case-in-mysql.md
├── year-in-mysql.md
├── current-year-in-mysql.md
└── data/
    └── sap_cwip_fy2026.csv
```
