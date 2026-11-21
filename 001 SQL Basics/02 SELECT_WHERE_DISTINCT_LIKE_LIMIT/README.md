# 🔍 MySQL Querying Basics: SELECT, WHERE, DISTINCT, LIKE, LIMIT

Five short lessons on reading and filtering data in MySQL, using **SAP ECC journal entries** as the example: the core of journal entry testing in audit.

> Part of my learning journey in **Data Engineering, Data Science & AI**.

## 📚 Lessons

| # | Lesson | What it does |
| --- | --- | --- |
| 1 | [SELECT](select-in-mysql.md) | Choose columns, rename with `AS`, calculate |
| 2 | [WHERE](where-in-mysql.md) | Filter rows: comparisons, `AND`/`OR`, `IN`, `BETWEEN`, `IS NULL` |
| 3 | [DISTINCT](distinct-in-mysql.md) | Remove duplicates, count unique values |
| 4 | [LIKE](like-in-mysql.md) | Filter text by pattern with `%` and `_` |
| 5 | [LIMIT](limit-in-mysql.md) | Top-N lists, previews and paging with `ORDER BY` |

📝 Quick revision: [SUMMARY.md](SUMMARY.md)

## 🗂️ Sample data

[`data/sap_ecc_journal_entries.csv`](data/sap_ecc_journal_entries.csv): **41 lines, 20 documents**, company code 1000, fiscal year 2026 (made up for practice). Every document balances; total debits = total credits = **1,106,222.85**.

| Column | SAP field | Meaning | Example |
| --- | --- | --- | --- |
| `BUKRS` | BKPF-BUKRS | Company code | `1000` |
| `BELNR` | BKPF-BELNR | Document number | `0100000009` |
| `GJAHR` | BKPF-GJAHR | Fiscal year | `2026` |
| `BUZEI` | BSEG-BUZEI | Line item | `1` |
| `BLART` | BKPF-BLART | Document type | `SA` G/L, `RE` vendor invoice, `DR` customer invoice |
| `BUDAT` | BKPF-BUDAT | Posting date | `2026-12-31` |
| `HKONT` | BSEG-HKONT | G/L account | `0000400000` |
| `SHKZG` | BSEG-SHKZG | Debit/credit | `S` debit, `H` credit |
| `DMBTR` | BSEG-DMBTR | Amount in local currency | `250000.00` |
| `WAERS` | BKPF-WAERS | Currency | `USD` |
| `SGTXT` | BSEG-SGTXT | Line text | `Manual adj - revenue top-up` |
| `USNAM` | BKPF-USNAM | User | `CFO_ADMIN` |
| `TCODE` | BKPF-TCODE | Transaction code | `FB50` |

Built-in audit red flags to find with the lessons: year-end manual entries, weekend postings, a test user, a blank line text, a reversal, and a duplicate vendor invoice.

## Setup

Requirements: see [requirements.txt](requirements.txt).

**1 · Create the table** in MySQL Workbench:

```sql
CREATE DATABASE IF NOT EXISTS audit_fy2026;
USE audit_fy2026;

CREATE TABLE je_lines (
    bukrs  CHAR(4)        NOT NULL,
    belnr  VARCHAR(10)    NOT NULL,
    gjahr  SMALLINT       NOT NULL,
    buzei  SMALLINT       NOT NULL,
    blart  CHAR(2)        NOT NULL,
    budat  DATE           NOT NULL,
    hkont  VARCHAR(10)    NOT NULL,
    shkzg  CHAR(1)        NOT NULL,
    dmbtr  DECIMAL(15,2)  NOT NULL,
    waers  CHAR(3)        NOT NULL,
    sgtxt  VARCHAR(50),
    usnam  VARCHAR(12)    NOT NULL,
    tcode  VARCHAR(20)    NOT NULL,
    PRIMARY KEY (bukrs, belnr, gjahr, buzei)
);
```

**2 · Load the CSV:** right-click `je_lines` → **Table Data Import Wizard** → select the CSV → **Use existing table** → **Next** until done.

**3 · Check:** `SELECT COUNT(*) FROM je_lines;` → **41**.

## 📁 Repository structure

```text
.
├── README.md
├── SUMMARY.md
├── requirements.txt
├── select-in-mysql.md
├── where-in-mysql.md
├── distinct-in-mysql.md
├── like-in-mysql.md
├── limit-in-mysql.md
└── data/
    └── sap_ecc_journal_entries.csv
```
