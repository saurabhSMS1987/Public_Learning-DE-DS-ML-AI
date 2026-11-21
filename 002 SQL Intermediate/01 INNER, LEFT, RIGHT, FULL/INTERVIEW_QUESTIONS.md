# 🎤 Top 10 Interview Questions: SQL Joins

**1. What is a join, and what are the main types?**
A join combines rows from two tables on a related column. `INNER JOIN` returns matches only; `LEFT JOIN` all left rows plus matches; `RIGHT JOIN` all right rows plus matches; `FULL OUTER JOIN` all rows from both. (`CROSS JOIN` returns every combination, and a self-join joins a table to itself.)

**2. What is the difference between `INNER JOIN` and `LEFT JOIN`?**
`INNER JOIN` drops rows without a match on either side. `LEFT JOIN` keeps every row from the left table and fills the right-hand columns with `NULL` when there is no match. Example: `deliveries INNER JOIN billing` returns 15 rows; `LEFT JOIN` returns all 16 deliveries.

**3. How do you find records in one table that are missing from another?**
Use an anti-join: `LEFT JOIN` and test the right table's key for `NULL`.

```sql
SELECT d.* FROM deliveries d
LEFT JOIN billing b ON b.delivery_no = d.delivery_no
WHERE b.billing_no IS NULL;          -- shipped but not billed
```

`NOT EXISTS` and `NOT IN` do the same; `NOT IN` returns nothing if the list contains a `NULL`.

**4. Does MySQL support `FULL OUTER JOIN`? How do you get one?**
No. Combine a `LEFT JOIN` with the unmatched rows of a `RIGHT JOIN`:

```sql
SELECT … FROM a LEFT JOIN b ON b.k = a.k
UNION ALL
SELECT … FROM a RIGHT JOIN b ON b.k = a.k WHERE a.k IS NULL;
```

Beware: `a FULL JOIN b` with no alias runs without error, because MySQL treats `FULL` as an alias for `a`, and returns an inner join.

**5. What is the difference between a condition in `ON` and in `WHERE` for a `LEFT JOIN`?**
`ON` decides which rows **match**; unmatched left rows are still kept. `WHERE` filters the **result** after the join, so a condition on the right table removes the `NULL` rows and turns the left join into an inner join. With `billing_date <= '2026-12-31'`: in `ON`, 16 rows; in `WHERE`, 14.

**6. Why might a join return more rows than either table?**
The join key isn't unique on one side, so each row matches several rows (one-to-many or many-to-many), and totals are counted more than once. Check uniqueness with `GROUP BY key HAVING COUNT(*) > 1` before joining, or aggregate first.

**7. Is `RIGHT JOIN` ever necessary?**
Rarely: `A RIGHT JOIN B` equals `B LEFT JOIN A`. Most teams write LEFT JOINs only for readability. In MySQL, RIGHT JOIN is mainly used to build the second half of a FULL JOIN.

**8. How do you handle `NULL`s after an outer join when aggregating?**
Count the right table's key (`COUNT(b.billing_no)`), not `COUNT(*)`, which counts 1 for unmatched rows. Wrap sums in `IFNULL(SUM(b.net_value), 0)` so unmatched groups show 0, not `NULL`.

**9. What does `Error 1052: Column … is ambiguous` mean?**
The column exists in more than one joined table and MySQL doesn't know which one you mean. Give each table an alias and prefix every column: `b.customer_id`.

**10. How would you use joins to audit revenue?**
Reconcile **volume to revenue** (deliveries to billing):
- `INNER JOIN` with `qty_shipped <> qty_billed` finds **accuracy** differences.
- `LEFT JOIN … IS NULL` finds shipments never billed (**completeness**). Adding a date in `ON` gives **cut-off** items.
- `RIGHT JOIN … IS NULL` finds invoices with no shipment (**occurrence**: 63,150.00 in the sample).
- A FULL JOIN puts every document in exactly one category, and the categories reconcile to the billing total (434,725.00).
