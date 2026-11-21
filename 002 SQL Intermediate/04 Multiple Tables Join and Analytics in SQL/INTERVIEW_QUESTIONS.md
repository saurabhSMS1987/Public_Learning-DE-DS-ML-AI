# 🎤 Top 10 Interview Questions: Multi-Table Joins & SQL Analytics

**1. How do you join more than two tables?**
Chain joins: each `JOIN … ON` attaches one new table to a table already in the query.

```sql
FROM ar_invoices i
JOIN ar_customers c      ON c.customer_id = i.customer_id
JOIN ar_invoice_items it ON it.invoice_no = i.invoice_no
JOIN ar_products p       ON p.product_id  = it.product_id
```

Use an alias per table and prefix every column.

**2. What is "fan-out" in joins, and how do you prevent it?**
Fan-out happens when a parent is joined to **two one-to-many** tables at once: each line pairs with each payment, so `SUM`s are multiplied. An invoice with 2 lines and 1 payment showed paid = 74,200 instead of 37,100. Prevent it by **aggregating each child table first** (`GROUP BY invoice_no` in a derived table) and joining the one-row-per-invoice results.

**3. How do you join the same table twice?**
Give each copy its own alias and join condition. For example, `ar_customers ic` for the invoiced customer and `ar_customers pc` for the paying customer, to find payments applied to another customer's invoice.

**4. What happens if you mix `LEFT JOIN` and `INNER JOIN` in one chain?**
An `INNER JOIN` that depends on the optional (left-joined) table removes the rows the `LEFT JOIN` kept, because their columns are `NULL` and can't match. Once a chain becomes `LEFT`, keep the joins that follow `LEFT` too.

**5. How would you calculate year-on-year growth in SQL?**
Use conditional aggregation and protect the division:

```sql
SUM(IF(YEAR(d) = 2026, amt, 0)) AS cy,
SUM(IF(YEAR(d) = 2025, amt, 0)) AS py,
ROUND((SUM(IF(YEAR(d) = 2026, amt, 0)) / NULLIF(SUM(IF(YEAR(d) = 2025, amt, 0)), 0) - 1) * 100, 1) AS growth_pct
```

`NULLIF` returns `NULL` for new customers (no prior year) instead of a division error or a meaningless number.

**6. How do you calculate each row's percentage of the total?**
`CROSS JOIN` a one-row derived table with the total, apply the **same filters** as the detail, and divide: `SUM(x) / t.total * 100`. Window functions (`SUM(x) OVER ()`) are an alternative in MySQL 8.

**7. How do you build an AR aging report?**
Compute the open amount per invoice (billed − paid at the as-at date, each aggregated first). Derive the due date (`DATE_ADD(invoice_date, INTERVAL terms DAY)`) and days overdue (`DATEDIFF(@ye, due_date)`). Then bucket with `CASE` (not due, 1–30, 31–90, 90+) and `GROUP BY` the bucket. Show credit balances separately.

**8. What is DSO, and how do you compute it in SQL?**
Days sales outstanding = receivables ÷ revenue × days in the period: `SUM(open AR) / SUM(revenue) * 365`. Compare it with payment terms: 156 days against 30–60-day terms signals slow collection or doubtful year-end revenue.

**9. What is a subsequent-receipts test, and how do you write it?**
It checks whether year-end receivables were **collected after year-end**, which is evidence that they exist and can be collected. `LEFT JOIN` the open items to payments with `payment_date > @ye` in the `ON` clause, and sum per invoice. Unpaid items (e.g. the Delta invoices) need other evidence, such as confirmations or delivery documents.

**10. How do you make analytics queries reliable and reusable?**
- Fix the as-at date in a variable (`SET @ye = '2026-12-31'`).
- Build reusable bases with `CREATE TABLE … AS SELECT` (year-end open items).
- Aggregate before joining to avoid fan-out.
- Use `NULLIF` in every ratio, keep totals and details on the same filters, and reconcile key totals (billed, AR) to the source tables.
