# 🎤 Top 10 Interview Questions: Calculated Columns (IF, CASE, YEAR, Current Year)

**1. What is a calculated column?**
A column produced by an expression in the `SELECT` (arithmetic, `IF`, `CASE`, date functions) rather than stored in the table. Example: `cost_to_date - settled AS cwip_balance`. It changes the output, not the data.

**2. What is the difference between `IF` and `CASE`?**
`IF(cond, a, b)` returns one of **two** values and is MySQL-specific. `CASE` handles **many** conditions and is standard SQL, so it works in SQL Server, Oracle and PostgreSQL too. Use `CASE` for three or more outcomes or for portable code.

**3. In what order are `CASE` conditions evaluated? Why does it matter?**
Top to bottom; the **first** true `WHEN` wins. Put specific conditions first: `WHEN cost > budget * 1.10` must come before `WHEN cost > budget`, or every overrun is labelled "Overrun".

**4. What happens when no `WHEN` matches and there is no `ELSE`?**
`CASE` returns `NULL`. Always add an `ELSE` (e.g. `'OK'` or `'Unknown'`) so rows aren't silently blank in reports or groups.

**5. How do you build a pivot (amounts by status in separate columns)?**
Put a condition inside an aggregate:

```sql
SELECT proj_type,
       SUM(CASE WHEN status = 'REL'  THEN cost_to_date - settled ELSE 0 END) AS rel,
       SUM(CASE WHEN status = 'TECO' THEN cost_to_date - settled ELSE 0 END) AS teco
FROM cwip_assets
GROUP BY proj_type;
```

`SUM(IF(status = 'REL', …, 0))` does the same in MySQL.

**6. How do you get the current year in MySQL?**
`YEAR(CURDATE())`: `CURDATE()` returns today's date and `YEAR()` extracts the year. The previous year is `YEAR(CURDATE()) - 1`, and 1 January of the current year is `MAKEDATE(YEAR(CURDATE()), 1)`.

**7. Why use a fixed as-at date instead of `CURDATE()` in audit work?**
`CURDATE()` changes every day, so a query rerun next month gives different results. Audit evidence must be reproducible at the reporting date: `SET @audit_date = '2026-12-31';` and use `@audit_date` throughout.

**8. `YEAR(end) - YEAR(start)` vs `TIMESTAMPDIFF(YEAR, start, end)`: what is the difference?**
The first counts **calendar years** crossed (31 Dec 2025 to 2 Jan 2026 = 1). The second counts **completed years** (= 0). Use `TIMESTAMPDIFF` for aging and asset ages.

**9. Why can `WHERE YEAR(budat) = 2026` be slow on large tables?**
A function on the column stops MySQL from using an index on it. `WHERE budat BETWEEN '2026-01-01' AND '2026-12-31'` (or `>= '2026-01-01' AND < '2027-01-01'`) returns the same rows and can use the index.

**10. How would you use these functions in a CWIP audit?**
- `CASE` on `status`, `settled` and `last_post` flags **completed-not-capitalised**, **stale** and **overdue** projects.
- `CASE` on `TIMESTAMPDIFF(YEAR, start_date, @audit_date)` builds an **aging analysis**.
- `IF` with `LIKE '%repair%'` finds **revenue expenditure** wrongly held in CWIP.
- `SUM(IF(status = 'TECO', …))` quantifies the amount that should be **capitalised and depreciated**: 2,499,100.00 in the sample.
