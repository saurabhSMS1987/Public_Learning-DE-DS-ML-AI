# 🧰 MySQL Transformation Functions: Text, Number, Date, Conversion & NULL

Four lessons covering the functions that **clean and reshape data** in a query, grouped by type, using **SAP S/4HANA journal entry (ACDOCA)** data for journal entry testing.

> Part of my learning journey in **Data Engineering, Data Science & AI**.

## 📚 Lessons

| # | Lesson | Functions | Audit use |
| --- | --- | --- | --- |
| 1 | [Text functions](text-functions-in-mysql.md) | `CONCAT`, `CONCAT_WS`, `UPPER`, `LOWER`, `TRIM`, `LTRIM`, `RTRIM`, `LENGTH`, `CHAR_LENGTH`, `LEFT`, `RIGHT`, `SUBSTRING`, `SUBSTRING_INDEX`, `REPLACE`, `REGEXP_REPLACE`, `LPAD`, `RPAD`, `INSTR`, `LOCATE`, `REVERSE` | Duplicate vendors, duplicate invoices, keyword search |
| 2 | [Number functions](number-functions-in-mysql.md) | `ROUND`, `TRUNCATE`, `CEIL`, `FLOOR`, `ABS`, `SIGN`, `MOD`, `POWER`, `SQRT`, `LOG10`, `GREATEST`, `LEAST`, `FORMAT` | Round and threshold amounts, Benford's law |
| 3 | [Date functions](date-functions-in-mysql.md) | `CURDATE`, `NOW`, `YEAR`, `QUARTER`, `MONTH`, `DAY`, `WEEK`, `HOUR`, `DATE`, `TIME`, `DAYNAME`, `MONTHNAME`, `DAYOFWEEK`, `DATE_ADD`, `DATE_SUB`, `DATEDIFF`, `TIMESTAMPDIFF`, `LAST_DAY`, `MAKEDATE`, `STR_TO_DATE`, `DATE_FORMAT` | Post-closing, out-of-hours and backdated entries |
| 4 | [Conversion & NULL functions](conversion-and-null-functions-in-mysql.md) | `CAST`, `CONVERT`, `IFNULL`, `COALESCE`, `NULLIF`, `IF`, `CASE` | Missing cost centers, type mismatches, safe ratios |

📝 Quick revision: [SUMMARY.md](SUMMARY.md) · 🎤 [Top 10 interview questions](INTERVIEW_QUESTIONS.md)

## 🗂️ Sample data

[`data/s4hana_journal_entries_fy2026.csv`](data/s4hana_journal_entries_fy2026.csv): **28 journal entry lines** in **14 documents**, company code 1000, FY2026 (made up for practice). Debits equal credits (net 0.00).

Some fields are kept **raw**, exactly as an extract delivers them, so there is something to transform: vendor names in mixed case with stray spaces, vendor numbers without leading zeros, SAP dates as `YYYYMMDD` text, references typed in different formats.

| Column | ACDOCA field | Meaning | Example |
| --- | --- | --- | --- |
| `RBUKRS` | RBUKRS | Company code | `1000` |
| `GJAHR` | GJAHR | Fiscal year | `2026` |
| `BELNR` / `DOCLN` | BELNR / DOCLN | Document / line item | `1900000001` / `000002` |
| `BLART` | BLART | Document type: `KR` vendor invoice, `KZ` payment, `SA` G/L entry | `KR` |
| `BUDAT` | BUDAT | Posting date | `2026-12-31` |
| `BLDAT` | BLDAT | Document date, **raw `YYYYMMDD`** | `20251215` |
| `CPUDT` | CPUDT + CPUTM | Entry date and time | `2027-01-08 23:47:10` |
| `RACCT` | RACCT | G/L account | `0000640000` |
| `RCNTR` | RCNTR | Cost center (blank on some expense lines) | `CC1000` |
| `LIFNR` | LIFNR | Vendor, **raw** (some without leading zeros) | `100023` |
| `VENDOR_NAME` | (LFA1-NAME1) | Vendor name, **raw** | ` acme supplies ltd ` |
| `DRCRK` | DRCRK | `S` debit, `H` credit | `H` |
| `HSL` | HSL | Amount in local currency, signed (credit negative) | `-12450.00` |
| `RHCUR` | RHCUR | Local currency | `USD` |
| `XBLNR` | XBLNR | Reference, **raw** | `inv 2026 45` |
| `SGTXT` | SGTXT | Line text, **raw** | `  consulting FEES feb  ` |
| `USNAM` / `TCODE` | USNAM / TCODE | User (mixed case) / transaction | `ap_clerk1` / `FB60` |

Built-in red flags to find:

| Red flag | Lesson |
| --- | --- |
| Same vendor under two vendor numbers (name spelled 3 ways) | Text |
| Same invoice posted and paid twice (`INV-2026-0045` vs `inv 2026 45`) | Text |
| "TEST posting" and "Adjust revenue per CFO" texts | Text |
| Round amounts and a 9,999.00 entry just below 10,000 | Number |
| Two 31 December entries keyed in on 8 and 9 January 2027 | Date |
| Entries at 02:13 on a Saturday and 23:47 on a Friday | Date |
| A December 2025 invoice posted in 2026 | Date |
| Expense lines with no cost center | Conversion & NULL |

## Setup

Requirements: see [requirements.txt](requirements.txt).

**Option A (recommended):** from this folder, run

```bash
mysql --local-infile=1 -u root -p < setup.sql
```

`setup.sql` creates `audit_fy2026.journal_entries`, loads the CSV and shows **28 lines, 14 documents, balance 0.00**. If loading is refused, run `SET GLOBAL local_infile = 1;` as root first.

**Option B (MySQL Workbench):** open `setup.sql`, replace `'data/…'` with the full path (forward slashes), add `OPT_LOCAL_INFILE=1` under **Edit Connection → Advanced → Others**, and run it.

## Real-world examples

Each lesson ends with extra snippets on audit data from my earlier sections, in the same `audit_fy2026` database:

| Table | Section |
| --- | --- |
| `ap_invoices` | Numeric Queries: BETWEEN, IN, ORDER BY, LIMIT, OFFSET |
| `revenue_lines` | Summary Analytics: MIN, MAX, AVG, GROUP BY |
| `cwip_assets` | Calculated Columns: IF, CASE, YEAR, current year |
| `billing` | SQL Joins: INNER, LEFT, RIGHT, FULL |
| `opex_postings` | CROSS JOIN & SELF JOIN |

## 📁 Repository structure

```text
.
├── README.md
├── SUMMARY.md
├── INTERVIEW_QUESTIONS.md
├── requirements.txt
├── setup.sql                              ← creates and loads journal_entries
├── .gitattributes                         ← keeps the CSV's Windows line endings intact
├── text-functions-in-mysql.md
├── number-functions-in-mysql.md
├── date-functions-in-mysql.md
├── conversion-and-null-functions-in-mysql.md
└── data/
    └── s4hana_journal_entries_fy2026.csv
```
