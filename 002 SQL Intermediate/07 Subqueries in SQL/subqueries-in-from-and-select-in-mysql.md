# 🧱 Subqueries in FROM and SELECT in MySQL

A subquery can also act as a **temporary table** (in `FROM`) or as a **calculated column** (in `SELECT`). This is how you filter or compare on totals that only exist after a `GROUP BY`.

> Part of my learning journey in **Data Engineering, Data Science & AI** · Data: `rv_customers`, `rv_materials`, `rv_billing_docs`, `rv_billing_items` ([setup](README.md#setup))

## Where it goes

| Position | Name | Returns | Rule |
| --- | --- | --- | --- |
| `FROM (…) AS t` | Derived table | A table | **Must have an alias** |
| `SELECT (…) AS col` | Scalar subquery | One value per row | Must return one row, one column |

## Examples

**1 · Derived table: customers billed above their credit limit**

```sql
SELECT t.customer_id, c.name, t.revenue, c.credit_limit
FROM (SELECT customer_id, SUM(net_value) AS revenue
      FROM rv_billing_docs
      GROUP BY customer_id) AS t                  -- step 1: one row per customer
JOIN rv_customers c ON c.customer_id = t.customer_id
WHERE t.revenue > c.credit_limit                  -- step 2: compare the total
  AND c.customer_group <> 'Intercompany';
```

| customer_id | name | revenue | credit_limit |
| --- | --- | --- | --- |
| C400 | Delta Distributors | **27300.00** | 20000.00 |

Delta was created on 2026-11-20 and is already 137% of its limit.

**2 · Average of a total: months above the average month**

```sql
SELECT m.mth, m.revenue
FROM (SELECT MONTH(posting_date) AS mth, SUM(net_value) AS revenue
      FROM rv_billing_docs
      WHERE YEAR(posting_date) = 2026
      GROUP BY MONTH(posting_date)) AS m
WHERE m.revenue > (SELECT AVG(a.revenue)                       -- 12,275.00
                   FROM (SELECT SUM(net_value) AS revenue
                         FROM rv_billing_docs
                         WHERE YEAR(posting_date) = 2026
                         GROUP BY MONTH(posting_date)) AS a)
ORDER BY m.mth;
```

| mth | revenue |
| --- | --- |
| 2 | 12700.00 |
| 5 | 22500.00 |
| 7 | 16400.00 |
| 9 | 15500.00 |
| 11 | **26700.00** |
| 12 | 23400.00 |

`AVG(SUM(…))` is not allowed: aggregate in a derived table, then aggregate again.

**3 · Scalar subquery in SELECT: % of total revenue**

```sql
SELECT customer_id,
       SUM(net_value) AS revenue,
       ROUND(SUM(net_value) / (SELECT SUM(net_value) FROM rv_billing_docs) * 100, 1) AS pct_of_total
FROM rv_billing_docs
GROUP BY customer_id
ORDER BY revenue DESC;
```

| customer_id | revenue | pct_of_total |
| --- | --- | --- |
| C300 | 33500.00 | 22.7 |
| C500 | 31600.00 | 21.5 |
| C400 | 27300.00 | 18.5 |
| C100 | 21300.00 | 14.5 |
| C200 | 16200.00 | 11.0 |
| C600 | 15000.00 | 10.2 |
| C800 | 2400.00 | 1.6 |

**4 · Scalar subquery in SELECT: distance from the average invoice**

```sql
SELECT billing_doc, net_value,
       net_value - (SELECT AVG(net_value) FROM rv_billing_docs
                    WHERE billing_type = 'F2') AS diff_from_avg
FROM rv_billing_docs
WHERE billing_type = 'F2'
ORDER BY diff_from_avg DESC
LIMIT 3;          -- 90000016 +11,615 · 90000006 +7,415 · 90000010 +6,415
```

**5 · Derived table + LEFT JOIN: header total vs item total** (aggregate first, then join)

```sql
SELECT d.billing_doc,
       d.net_value                         AS header_value,
       IFNULL(i.items_value, 0)            AS items_value,
       d.net_value - IFNULL(i.items_value, 0) AS difference
FROM rv_billing_docs d
LEFT JOIN (SELECT billing_doc, SUM(net_amount) AS items_value
           FROM rv_billing_items
           GROUP BY billing_doc) AS i ON i.billing_doc = d.billing_doc
WHERE d.net_value <> IFNULL(i.items_value, 0);
```

| billing_doc | header_value | items_value | difference |
| --- | --- | --- | --- |
| 90000011 | 3200.00 | 2700.00 | 500.00 |
| 90000019 | 5500.00 | 0.00 | 5500.00 |

Together these explain the setup difference: headers 147,300.00 − items 141,300.00 = **6,000.00**.

## More real-world examples

```sql
-- Unbalanced journal entries: debits − credits per document ≠ 0 (expected: no rows)
SELECT d.belnr, d.net
FROM (SELECT belnr, SUM(IF(shkzg = 'S', dmbtr, -dmbtr)) AS net
      FROM je_lines
      GROUP BY belnr) AS d
WHERE d.net <> 0;

-- Each vendor's share of total AP spend
SELECT name1,
       SUM(dmbtr) AS spend,
       ROUND(SUM(dmbtr) / (SELECT SUM(dmbtr) FROM ap_invoices) * 100, 1) AS pct
FROM ap_invoices
GROUP BY name1
ORDER BY spend DESC;

-- Cost centres whose total opex is above the average cost centre
SELECT t.cost_center, t.total
FROM (SELECT cost_center, SUM(amount) AS total
      FROM opex_postings GROUP BY cost_center) AS t
WHERE t.total > (SELECT AVG(x.total)
                 FROM (SELECT SUM(amount) AS total
                       FROM opex_postings GROUP BY cost_center) AS x);
```

## ⚠️ Common mistakes

| Mistake | Problem | Fix |
| --- | --- | --- |
| No alias on a derived table | `Error 1248: Every derived table must have its own alias` | `FROM (…) AS t` |
| `AVG(SUM(x))` | `Error 1111: Invalid use of group function` | `SUM` in a derived table, then `AVG` outside |
| Scalar subquery returns several rows | `Error 1242` | Aggregate it or add a filter |
| Using the derived table's raw column names outside | `Unknown column` | Use the aliases defined inside (`revenue`, `mth`) |

## 🎯 Key takeaways

1. A subquery in `FROM` is a **derived table**: build a summary, then filter or join it. It needs an alias.
2. Use it to **filter on totals** and to take an **average of totals**.
3. A subquery in `SELECT` adds one value per row: % of total, difference from average.
4. Aggregate one-to-many tables in a derived table **before** joining.
