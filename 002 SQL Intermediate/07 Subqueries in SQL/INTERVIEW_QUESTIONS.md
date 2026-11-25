# 🎤 Top 10 Interview Questions: SQL Subqueries

**1. What is a subquery, and where can it go?**
A `SELECT` in brackets inside another query. It can go in `WHERE` / `HAVING` (filter), `FROM` (derived table) or `SELECT` (calculated column).

**2. What types of subquery are there?**
- **Scalar:** one value → `=`, `>`, `<`.
- **List** (one column, many rows) → `IN`, `NOT IN`, `ANY`, `ALL`.
- **Table** (many columns) → `FROM (…) AS t`, or `(a, b) IN (…)`.
- **Correlated:** refers to the outer query; evaluated per row.

**3. What is the difference between a regular and a correlated subquery?**
A regular subquery runs on its own and is evaluated once. A correlated one uses an outer column (`WHERE x.customer_id = d.customer_id`), so it is evaluated for each outer row and cannot run alone.

```sql
SELECT d.billing_doc, d.net_value
FROM rv_billing_docs d
WHERE d.net_value > 1.5 * (SELECT AVG(x.net_value) FROM rv_billing_docs x
                           WHERE x.customer_id = d.customer_id);
```

**4. Find the second-highest invoice value.**

```sql
SELECT MAX(net_value)
FROM rv_billing_docs
WHERE net_value < (SELECT MAX(net_value) FROM rv_billing_docs);
```

**5. Why can `NOT IN` return no rows, and how do you fix it?**
If the subquery's list contains a NULL, `x NOT IN (…, NULL)` is never TRUE, so every row is filtered out. Add `WHERE col IS NOT NULL` inside the subquery, or use `NOT EXISTS`, which is NULL-safe.

**6. `IN` vs `EXISTS`?**
Same result for "has a match". `IN` compares a value with a list; `EXISTS` checks whether the correlated subquery returns any row and stops at the first match. The real difference is with negation: `NOT EXISTS` handles NULLs correctly, `NOT IN` does not.

**7. What is a derived table, and what error do you get without an alias?**
A subquery in `FROM` treated as a temporary table, usually to filter or join on aggregates. Without an alias: `Error 1248: Every derived table must have its own alias`.

**8. How do you take an average of totals, such as the average monthly revenue?**
`AVG(SUM(x))` is not allowed (`Error 1111`). Sum per month in a derived table, then average outside:

```sql
SELECT AVG(m.revenue)
FROM (SELECT MONTH(posting_date) AS mth, SUM(net_value) AS revenue
      FROM rv_billing_docs GROUP BY MONTH(posting_date)) AS m;
```

**9. When would you use a subquery instead of a JOIN?**
Use a subquery when you only need to **filter** on another table (no columns from it); it also avoids duplicate rows a join can create. Use a `JOIN` when you need columns from both tables. Correlated subqueries can be slow on large tables: index the link column or rewrite as a derived table + `JOIN`.

**10. Give audit examples of subqueries.**
- Invoices above the average invoice (scalar).
- Invoices to blocked customers (`IN`); external revenue excluding intercompany (`NOT IN`).
- Customers over their credit limit (derived table).
- Prices above list price, invoices above the customer's own average (correlated).
- Invoices without items, credit memos without an original invoice (`NOT EXISTS`).
