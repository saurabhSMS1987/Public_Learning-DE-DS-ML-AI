# 🔍 Subqueries in WHERE in MySQL

A **subquery** is a `SELECT` inside another query, written in brackets. MySQL runs it, then uses its result in the outer query. In `WHERE`, it lets you filter against a value you would otherwise have to calculate first and type in by hand.

> Part of my learning journey in **Data Engineering, Data Science & AI** · Data: `rv_customers`, `rv_materials`, `rv_billing_docs`, `rv_billing_items` ([setup](README.md#setup))

## What the subquery returns decides the operator

| Subquery returns | Operators | Example |
| --- | --- | --- |
| **One value** (scalar) | `=` `<>` `>` `<` `>=` `<=` | `> (SELECT AVG(net_value) …)` |
| **One column, many rows** (list) | `IN`, `NOT IN`, `ANY`, `ALL` | `IN (SELECT customer_id …)` |
| **Several columns, many rows** | `(a, b) IN (…)` | `(lifnr, xblnr) IN (…)` |

## Examples

**1 · Single value: invoices above the average invoice** (7,585.00)

```sql
SELECT billing_doc, billing_date, customer_id, net_value
FROM rv_billing_docs
WHERE billing_type = 'F2'
  AND net_value > (SELECT AVG(net_value)
                   FROM rv_billing_docs
                   WHERE billing_type = 'F2')
ORDER BY net_value DESC;
```

| billing_doc | billing_date | customer_id | net_value |
| --- | --- | --- | --- |
| 90000016 | 2026-11-26 | C400 | **19200.00** |
| 90000006 | 2026-05-12 | C600 | 15000.00 |
| 90000010 | 2026-07-22 | C500 | 14000.00 |
| 90000012 | 2026-09-02 | C300 | 12500.00 |
| 90000018 | 2026-12-22 | C400 | 9600.00 |
| 90000004 | 2026-03-18 | C500 | 9000.00 |
| 90000003 | 2026-02-25 | C300 | 8700.00 |

No hard-coded `7585`: if the data changes, the threshold changes with it.

**2 · Largest and second-largest invoice**

```sql
-- Largest: 90000016, 19,200.00 (C400)
SELECT billing_doc, customer_id, net_value
FROM rv_billing_docs
WHERE net_value = (SELECT MAX(net_value) FROM rv_billing_docs);

-- Second largest: 15,000.00
SELECT MAX(net_value) AS second_highest
FROM rv_billing_docs
WHERE net_value < (SELECT MAX(net_value) FROM rv_billing_docs);
```

**3 · List with `IN`: invoices to blocked customers**

```sql
SELECT billing_doc, billing_date, customer_id, net_value
FROM rv_billing_docs
WHERE customer_id IN (SELECT customer_id
                      FROM rv_customers
                      WHERE blocked = 'Y');
```

| billing_doc | billing_date | customer_id | net_value |
| --- | --- | --- | --- |
| 90000009 | 2026-07-07 | C800 | 2400.00 |

**4 · `NOT IN`: external revenue (exclude intercompany)**

```sql
SELECT SUM(net_value) AS external_revenue          -- 132,300.00 (all: 147,300.00)
FROM rv_billing_docs
WHERE posting_date BETWEEN '2026-01-01' AND '2026-12-31'
  AND customer_id NOT IN (SELECT customer_id
                          FROM rv_customers
                          WHERE customer_group = 'Intercompany');
```

**5 · `NOT IN`: customers never billed** → C700 Granite Builders

```sql
SELECT customer_id, name
FROM rv_customers
WHERE customer_id NOT IN (SELECT customer_id FROM rv_billing_docs);
```

**6 · ⚠️ The `NOT IN` + NULL trap: invoices never credited**

```sql
SELECT COUNT(*) FROM rv_billing_docs
WHERE billing_type = 'F2'
  AND billing_doc NOT IN (SELECT ref_doc FROM rv_billing_docs
                          WHERE billing_type = 'G2');                       -- 0 ❌

SELECT COUNT(*) FROM rv_billing_docs
WHERE billing_type = 'F2'
  AND billing_doc NOT IN (SELECT ref_doc FROM rv_billing_docs
                          WHERE billing_type = 'G2' AND ref_doc IS NOT NULL); -- 18 ✅
```

Credit memo 90000024 has no `ref_doc` (NULL). `x NOT IN (…, NULL)` is never TRUE, so **every** row disappears. Exclude NULLs, or use `NOT EXISTS` ([lesson 3](correlated-subqueries-and-exists-in-mysql.md)).

**7 · `ALL` and `ANY`**

```sql
-- Invoices smaller than ALL of C200's invoices (C200's smallest is 3,000.00) → 90000009, 2,400.00
SELECT billing_doc, customer_id, net_value
FROM rv_billing_docs
WHERE billing_type = 'F2' AND customer_id <> 'C200'
  AND net_value < ALL (SELECT net_value FROM rv_billing_docs
                       WHERE customer_id = 'C200' AND billing_type = 'F2');

-- Invoices larger than ANY of C400's invoices (above its smallest, 9,600.00) → 4
SELECT COUNT(*)
FROM rv_billing_docs
WHERE billing_type = 'F2'
  AND net_value > ANY (SELECT net_value FROM rv_billing_docs
                       WHERE customer_id = 'C400' AND billing_type = 'F2');
```

`> ALL` = above the maximum · `< ALL` = below the minimum · `> ANY` = above the minimum · `= ANY` = `IN`.

## More real-world examples

```sql
-- Duplicate vendor invoices: same vendor + same reference (two-column IN)
SELECT lifnr, name1, xblnr, belnr, bldat, dmbtr
FROM ap_invoices
WHERE (lifnr, xblnr) IN (SELECT lifnr, xblnr
                         FROM ap_invoices
                         GROUP BY lifnr, xblnr
                         HAVING COUNT(*) > 1);

-- Journal entries posted by users who also posted any line of 100,000 or more
SELECT usnam, COUNT(*) AS lines_posted
FROM je_lines
WHERE usnam IN (SELECT usnam FROM je_lines WHERE dmbtr >= 100000)
GROUP BY usnam;

-- Trial balance accounts above the average closing balance
SELECT hkont, txt50, closing
FROM trial_balance
WHERE closing > (SELECT AVG(closing) FROM trial_balance);
```

## ⚠️ Common mistakes

| Mistake | Problem | Fix |
| --- | --- | --- |
| `=` with a subquery that returns several rows | `Error 1242: Subquery returns more than 1 row` | Use `IN`, or make it return one value (`MAX`, `LIMIT 1`) |
| `NOT IN` on a column that can be NULL | Returns no rows at all | Add `WHERE col IS NOT NULL`, or use `NOT EXISTS` |
| Subquery selects several columns with `IN (…)` | `Error 1241: Operand should contain 1 column` | Select one column, or compare `(a, b) IN (…)` |
| Forgetting the brackets | Syntax error | Every subquery sits inside `( )` |

## 🎯 Key takeaways

1. A subquery is a query in brackets whose result feeds the outer query.
2. **One value** → comparison operators; **a list** → `IN` / `NOT IN` / `ANY` / `ALL`.
3. Subqueries replace hard-coded thresholds (averages, maximums, lists of customers).
4. `NOT IN` returns nothing if the list contains a **NULL**.
