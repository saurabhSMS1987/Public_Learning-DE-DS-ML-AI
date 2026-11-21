# 🧠 Topic coverage

Where each topic from my **SQL Basics** and **SQL Intermediate** key takeaways is used in the project.

## SQL Basics

| Topic | Script · section |
| --- | --- |
| Install MySQL Server + Workbench, root password | README · Run the project |
| `USE` | every script, first line |
| `CREATE DATABASE`, `DROP DATABASE` | 00 |
| `CREATE TABLE`, data types (`CHAR`, `VARCHAR`, `DECIMAL`, `DATE`, `DATETIME`, `INT`) | 01 |
| `NOT NULL`, `DEFAULT`, `CHECK`, `PRIMARY KEY`, `FOREIGN KEY` | 01 |
| `CREATE INDEX`, `EXPLAIN` | 01 · 1.4, 05 · 5.11 |
| `ALTER TABLE`, `TRUNCATE`, `DROP TABLE` | 11 · 11.7, 11.9 |
| `CREATE TABLE … LIKE`, `CREATE TABLE … AS SELECT` | 04 · 4.10, 09 (helper), 11 · 11.8–11.9 |
| CSV UTF-8, Import Wizard (alternative) | README · 3b |
| `LOAD DATA LOCAL INFILE` | 02 |
| Staging table + `INSERT … SELECT` | 01 · 1.1, 04 |
| Validate loads: row counts and control totals | 02, 04 · 4.7–4.8 |
| Export: result grid, `INTO OUTFILE`, `mysqldump` | README · 5, 11 · 11.11 |
| `INSERT`, `UPDATE`, `DELETE`, preview with `SELECT` | 11 · 11.2–11.7 |
| `START TRANSACTION`, `COMMIT`, `ROLLBACK` | 04, 11 · 11.4–11.5 |
| `SELECT *`, named columns, `AS` | 05 · 5.1–5.2 |
| `COUNT(*)`, `COUNT(DISTINCT)`, `DISTINCT` | 03 · 3.1, 05 · 5.3–5.4 |
| `LIKE` with `%` and `_` | 03 · 3.4, 05 · 5.7 |
| `IS NULL` | 05 · 5.8, 07 |
| Comparison operators, `AND`/`OR` with brackets | 05 · 5.5 |
| `BETWEEN`, `IN` | 05 · 5.6 |
| `ORDER BY` `ASC`/`DESC`, `LIMIT`, `OFFSET` | 05 · 5.9–5.10 |
| `SUM`, `COUNT`, `MIN`, `MAX`, `AVG` | 06 · 6.1 |
| `GROUP BY`, `HAVING` (vs `WHERE`) | 06 · 6.2 |
| Derived columns, revenue and profit (commission) | 06 · 6.3 |
| `IF`, `CASE` | 06 · 6.4–6.5 |
| Currency and unit conversion | 06 · 6.3 |
| `YEAR`, `YEAR(CURDATE())`, fixed as-at date | 06 · 6.6–6.7 |

## SQL Intermediate

| Topic | Script · section |
| --- | --- |
| Why multiple tables, ERD | README · ERD |
| `JOIN … ON`, aliases, INNER as default | 07 · 7.1 |
| Join on several columns with `AND` | 07 · 7.6, 10 · T6 |
| `LEFT JOIN` (+ `IS NULL` anti-join) | 03 · 3.6, 07 · 7.2–7.3 |
| `RIGHT JOIN` | 07 · 7.4 |
| `FULL JOIN` via `UNION` | 07 · 7.5 |
| `CROSS JOIN` + `CONCAT` | 07 · 7.7 |
| SELF JOIN | 07 · 7.8 |
| Export to CSV | README · 5 |
| Text: `CONCAT`, `UPPER`, `LOWER`, `TRIM`, `LEFT`, `RIGHT`, `SUBSTRING`, `REPLACE`, `LPAD` | 04, 08 · 8.4 |
| Numbers: `ROUND`, `ABS`, `MOD` | 08 · 8.5 |
| Dates: `STR_TO_DATE`, `DATE_FORMAT`, `DATE_ADD`, `DATEDIFF`, `DAYNAME`, `MONTH` | 04 · 4.5, 08 · 8.6 |
| Conversion & NULL: `CAST`, `IFNULL`, `COALESCE`, `NULLIF` | 04, 08 · 8.7 |
| Joining more than two tables | 08 · 8.1 |
| `GROUP_CONCAT` | 08 · 8.2 |
| Aggregate first, then join (fan-out) | 08 · 8.3, 10 · T1 |
| % of total, Top N / Bottom N, comparisons | 09 |
| Break the requirement into pieces | 10 (one question per test) |
