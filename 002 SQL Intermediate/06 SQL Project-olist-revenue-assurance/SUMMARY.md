# 📝 Project Summary: E-Commerce Revenue Assurance with SQL

## In one paragraph

Seven raw Olist CSV files from Kaggle (≈ 450,000 rows) were loaded into all-text staging tables, profiled for quality issues, then cleaned and converted into typed MySQL tables with primary keys, foreign keys and checks. Every row and both control totals **reconciled exactly** to the source. Exploration, summaries, joins and analytics described the business. Eight revenue assurance tests found that **349,787.86 BRL (5.9%) of FY2017 revenue** relates to orders delivered in 2018, and that **269,735.11 BRL** was paid on orders later canceled or unavailable.

## 📊 Key figures

| Measure | Value |
| --- | --- |
| Orders / items / payments loaded | 99,441 / 112,650 / 103,886 |
| Unique customers | 96,096 |
| FY2017 delivered orders · revenue | 43,428 · 5,962,902.01 BRL |
| FY2017 revenue on delivery basis | 5,612,817.85 BRL |
| Peak month | November 2017 (Black Friday): 987,765.37 BRL |
| Top category | bed_bath_table, 8.2% of FY2017 revenue |
| Top 10 sellers' share | 18.1% |
| Growth, Jan–Aug 2018 vs Jan–Aug 2017 | +141.1% |
| Payment mix | Credit card 78.3% · boleto 17.9% · voucher 2.4% · debit 1.4% |
| Late deliveries | 6,534 of 96,470 delivered orders (6.8%) |

## 🔎 Findings

| # | Finding | Value |
| --- | --- | --- |
| 1 | FY2017 orders delivered in 2018 (cut-off) | 2,496 orders · **349,787.86 BRL** |
| 2 | Paid orders later canceled or unavailable (refunds) | 1,234 orders · **269,735.11 BRL** |
| 3 | Payment ≠ items + freight (> 1 BRL) | 310 orders · net -2,004.17 BRL |
| 4 | Delivered order with no payment | 1 order |
| 5 | Timestamp integrity | 8 delivered with no date · 14 never approved · 1,359 shipped before approval |
| 6 | Price > 2× the seller's own average | 8 items |
| 7 | Zero-value / undefined payments | 9 payments |
| 8 | Delivered more than 30 days late | 345 orders |

**Proposed adjustment:** defer **349,787.86 BRL** of FY2017 revenue to FY2018 (revenue recognised on delivery).

## 🧠 SQL topics used

| Area | Where |
| --- | --- |
| `CREATE DATABASE/TABLE`, types, `NOT NULL`, `DEFAULT`, `CHECK`, `PRIMARY KEY`, `FOREIGN KEY`, indexes | Steps 0, 1 |
| `LOAD DATA`, staging, `INSERT … SELECT`, reconciliation | Steps 2, 4 |
| Data quality: `DISTINCT`, `LIKE`, `IS NULL`, orphans, duplicates | Step 3 |
| `SELECT`, `WHERE`, `AND`/`OR`, `IN`, `BETWEEN`, `LIKE`, `ORDER BY`, `LIMIT`, `OFFSET`, `EXPLAIN` | Step 5 |
| `SUM`, `COUNT`, `MIN`, `MAX`, `AVG`, `GROUP BY`, `HAVING`, `IF`, `CASE`, `YEAR`, conversions | Step 6 |
| INNER, LEFT, RIGHT, FULL (`UNION`), multi-column, CROSS and SELF joins | Step 7 |
| Multi-table joins, `GROUP_CONCAT`, fan-out, text/number/date/NULL functions | Step 8 |
| % of total, Top N / Bottom N, growth, concentration | Step 9 |
| Audit tests combining everything | Step 10 |
| `INSERT`, `UPDATE`, `DELETE`, `COMMIT`/`ROLLBACK`, `ALTER`, `TRUNCATE`, `DROP`, export | Step 11 |

Full map: [docs/topic_coverage.md](docs/topic_coverage.md).

## 🎯 Key takeaways

1. **Stage, check, then load:** all-text staging tables let real-world problems (lost zeros, hidden `\r`, blank dates) be found and fixed in SQL.
2. **Reconcile before analysing:** row counts and control totals prove the load is complete and accurate.
3. **Aggregate before joining** one-to-many tables: joining items and payments together inflated "paid" from 15.8 M to 20.3 M BRL.
4. **The recognition date matters:** purchase date vs delivery date moves 350,084.16 BRL between years.
5. **Analytics give context, tests give evidence:** trends and concentration point to risk; exception lists support findings.
