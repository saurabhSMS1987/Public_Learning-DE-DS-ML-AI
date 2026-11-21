# 🎤 Interview Questions: Revenue Audit Analytics with SQL

Questions an interviewer might ask about this project, with short answers based on it.

## 1 · About the project

**Q1. Describe the project in two minutes.**
I audited a year of SAP sales billing data in MySQL. I staged a raw extract, checked data quality, loaded 955 clean lines with foreign keys to customer and material master data, and reconciled them to SAP's report total. I then analysed revenue and ran nine audit tests. They showed 245,400 of FY2026 revenue was reversed in January 2027: year-end sales to a new customer at inflated prices, entered manually. I logged the findings and quantified the adjustment.

**Q2. Why use SQL instead of Excel?**
SQL handles millions of rows, every step is a script that can be rerun and reviewed, foreign keys and checks enforce data rules, and the same tests run unchanged next year.

**Q3. What was the most important finding, and how did you prove it?**
The cut-off issue (T1). Credit memos dated January 2027 reference invoices dated December 2026 through `vgbel`. T2–T4 support it: new customer, prices above list, invoices above the credit limit.

## 2 · Loading and data quality

**Q4. Why load into a staging table first?**
With all-text columns, no row fails conversion, so nothing is dropped silently. I can query the bad rows, report them, and convert only clean rows with `INSERT … SELECT`.

**Q5. Which data-quality problems did you find?**
Three rows: an unknown customer (`0000199999`), a missing billing date, and SAP's report total line. They were found with `NOT IN (SELECT kunnr FROM customers)`, `REGEXP` and a blank document number.

**Q6. How did you prove the load was complete and accurate?**
Completeness: staged 958 = loaded 955 + rejected 3. Accuracy: the loaded `SUM(netwr)` equals SAP's report total, 11,492,928.49.

**Q7. How did you convert SAP formats?**
`STR_TO_DATE(fkdat, '%d.%m.%Y')` for dates, `REPLACE(x, ',', '')` for thousands separators, and moving the trailing minus to the front for credits (`156,000.00-` → `-156000.00`).

**Q8. Why `VARCHAR` for customer numbers and `DECIMAL` for amounts?**
`VARCHAR` keeps leading zeros (`0000100020`). `DECIMAL` is exact; `FLOAT` causes rounding differences in totals.

## 3 · SQL concepts

**Q9. What is the difference between `WHERE` and `HAVING`?**
`WHERE` filters rows before grouping; `HAVING` filters groups after `GROUP BY` and can use aggregates. In Q7.4, `WHERE` keeps the last week's manual rows and `HAVING SUM(netwr) >= 100000` keeps users with large totals.

**Q10. In what order does MySQL run a query?**
`FROM` → `WHERE` → `GROUP BY` → `HAVING` → `SELECT` → `DISTINCT` → `ORDER BY` → `LIMIT`/`OFFSET`.

**Q11. `COUNT(*)` vs `COUNT(column)` vs `COUNT(DISTINCT column)`?**
All rows / non-`NULL` values / unique values. Here: 955 lines, 25 credit memo lines with a reference (`COUNT(vgbel)`), 585 documents (`COUNT(DISTINCT vbeln)`).

**Q12. Why did you need `JOIN` in some tests?**
List prices and credit limits live in master data. T3 joins `materials` to compare `netpr` with `list_price`; T4 joins `customers` to compare invoice value with `klimk`.

**Q13. How do foreign keys help an audit dataset?**
They stop billing lines that point to customers or materials that don't exist (`Error 1452`). Checking orphans before adding them turns data errors into findings.

**Q14. Why the indexes on `fkdat` and `ernam`?**
Most tests filter on billing date and user. `EXPLAIN` in Q5.12 shows the date range uses `idx_bl_fkdat` (`type = range`), not a full table scan.

**Q15. Why `ORDER BY … , vbeln` before `LIMIT`/`OFFSET`?**
`LIMIT` without `ORDER BY` returns any rows. A tie-breaker makes top-N and paging stable between runs.

**Q16. What does the transaction in step 9 show?**
An `UPDATE` without a proper filter changed all 8 findings. `ROLLBACK` undid it: 0 rows closed afterwards. `COMMIT` saves changes only once they are checked.

**Q17. The finding IDs have gaps (1, 2, 4, 5, 10). Why?**
`AUTO_INCREMENT` reserves IDs in blocks for `INSERT … SELECT`, and deleted rows' IDs are not reused. IDs are unique, not continuous; never use them as a count.

**Q18. Why is `AVG(netpr)` different from `SUM(netwr) / SUM(fkimg)`?**
The first is a simple average per line; the second is weighted by quantity. Large orders at unusual prices move the weighted average more: 1,244.38 vs 1,260.92 for `P-100`.

## 4 · Audit logic

**Q19. Which revenue risks do the tests address?**
Occurrence and cut-off (T1, T2, T9), accuracy of pricing (T3, T7), authorisation and credit control (T4), duplicates (T5), and unusual entries (T6, T8), in line with journal entry and revenue fraud-risk procedures.

**Q20. Why exclude credit memos when averaging invoice values?**
Negative values pull the average down and make `MIN` return a credit, not the smallest sale. Each query filters `fkart` to the population it describes.

**Q21. How would you scale this to 5 million lines?**
Use `LOAD DATA` rather than the wizard, keep the staging pattern, index the filter columns, and add indexes after the bulk load. The SQL tests stay the same.

**Q22. What would you do next?**
Confirm the Delta Distributors transactions with the customer, inspect delivery documents for the December sales, extend the cut-off window, and add tests on the sales order and delivery tables (VBAK, LIKP) with joins.
