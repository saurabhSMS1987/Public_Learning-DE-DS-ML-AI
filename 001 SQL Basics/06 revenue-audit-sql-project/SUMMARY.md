# 📝 Project Summary: Revenue Audit Analytics with SQL

## In one paragraph

A raw SAP billing extract (958 rows) was staged, checked and loaded into a typed MySQL table with foreign keys to customer and material master data. Three bad rows were rejected and the 955 loaded lines **reconciled exactly** to SAP's report total (11,492,928.49). Analysis and nine audit tests found that **245,400.00 of FY2026 revenue** comes from year-end sales to a brand-new customer, at prices 55–56% above list and over its credit limit, entered manually and **reversed in January 2027**: a cut-off misstatement.

## 📊 Key figures

| Measure | Value |
| --- | --- |
| Billing lines / documents loaded | 955 / 585 |
| FY2026 invoices / credit memos | 11,801,764.99 / -82,287.00 |
| **FY2026 net revenue (as recorded)** | **11,719,477.99** |
| December revenue | 1,572,282.33 (highest month; 1.6 × the monthly average) |
| Largest invoice line | 156,000.00 (Delta Distributors, 29 Dec, `SALES_MGR`) |
| **Proposed adjustment** | **-245,400.00** (reverse cut-off sales) |

## 🔎 Findings

| # | Finding | Evidence (test) |
| --- | --- | --- |
| 1 | Year-end sales reversed in January 2027 | T1: 2 credit memos, -245,400.00 |
| 2 | New customer billed 355,800.00 within 2 weeks of creation | T2 |
| 3 | Prices 55–56% above list | T3 |
| 4 | Invoices over the customer's 50,000 credit limit | T4 |
| 5 | Manual year-end billing by a sales manager | T9: 430,200.00 |
| 6 | Possible duplicate invoices | T5: 3 pairs |
| 7 | Weekend billing, zero-value lines, round amounts | T6, T7, T8 |

## 🧠 SQL topics used

| Area | Topics | Where |
| --- | --- | --- |
| Creating tables | `CREATE DATABASE/TABLE`, data types, `NOT NULL`, `DEFAULT`, `CHECK`, `PRIMARY KEY`, `AUTO_INCREMENT` | Steps 0, 1, 9 |
| Relationships | `FOREIGN KEY`, orphan checks with `NOT IN` | Steps 1, 3 |
| Indexes | `CREATE INDEX`, `EXPLAIN` | Steps 1, 5 |
| Importing | `LOAD DATA LOCAL INFILE`, staging table, Import Wizard (alternative) | Step 2 |
| Data quality | `REGEXP`, `LIKE`, `IS NULL`, duplicates with `HAVING` | Step 3 |
| Transforming | `INSERT … SELECT`, `STR_TO_DATE`, `REPLACE`, `NULLIF` | Step 4 |
| Copying tables | `CREATE TABLE … LIKE`, `CREATE TABLE … AS SELECT` | Steps 4, 9 |
| Querying | `SELECT`, `AS`, `DISTINCT`, `WHERE`, `AND`/`OR`, `IN`, `BETWEEN`, `LIKE` | Steps 3, 5, 8 |
| Sorting & paging | `ORDER BY`, `LIMIT`, `OFFSET` | Step 5 |
| Aggregating | `COUNT`, `SUM`, `MIN`, `MAX`, `AVG`, `GROUP BY` | Steps 6, 7, 8 |
| Filtering groups | `HAVING` (aggregates, subqueries) | Steps 3, 7, 8 |
| Changing data | `INSERT`, `UPDATE`, `DELETE`, `ALTER TABLE` | Step 9 |
| Transactions | `START TRANSACTION`, `COMMIT`, `ROLLBACK` | Steps 4, 9 |
| Exporting | `SELECT … INTO OUTFILE`, Workbench export | Step 9 |

## 🎯 Key takeaways

1. **Stage first, then load:** raw text in, quality checks, typed data out; nothing is lost silently.
2. **Reconcile before testing:** row counts and the control total prove completeness and accuracy.
3. **Summaries point to risk** (`GROUP BY`); **`HAVING` turns them into exception lists**; detail queries give the evidence.
4. **Master data matters:** foreign keys, creation dates, list prices and credit limits drive the strongest tests.
5. **Transactions protect changes:** check, then `COMMIT`, or `ROLLBACK`.
