# 🔁 Correlated Subqueries and EXISTS in MySQL

A **correlated subquery** refers to a column of the outer query, so it is re-evaluated **for each outer row**. This lets each row be compared with its *own* group: a customer's own average, a document's own items. `EXISTS` / `NOT EXISTS` uses the same idea to test whether a matching row exists.

> Part of my learning journey in **Data Engineering, Data Science & AI** · Data: `rv_customers`, `rv_materials`, `rv_billing_docs`, `rv_billing_items` ([setup](README.md#setup))

## Regular vs correlated

| | Regular subquery | Correlated subquery |
| --- | --- | --- |
| Uses outer columns? | No | Yes (`x.customer_id = d.customer_id`) |
| Runs | Once | Once per outer row (logically) |
| Can run on its own? | Yes | No |
| Typical use | Compare with an overall figure | Compare with the row's own group |

## Examples

**1 · Item price above the material's list price**

```sql
SELECT i.billing_doc, i.item_no, i.material_id, i.unit_price
FROM rv_billing_items i
WHERE i.unit_price > (SELECT m.list_price
                      FROM rv_materials m
                      WHERE m.material_id = i.material_id);    -- outer column
```

| billing_doc | item_no | material_id | unit_price |
| --- | --- | --- | --- |
| 90000016 | 10 | M01 | 3200.00 (list 2,500) |
| 90000018 | 10 | M02 | 960.00 (list 800) |

Both are to Delta Distributors, the new customer over its credit limit.

**2 · Invoice more than 1.5× the customer's own average**

```sql
SELECT d.billing_doc, d.customer_id, d.net_value
FROM rv_billing_docs d
WHERE d.billing_type = 'F2'
  AND d.net_value > 1.5 * (SELECT AVG(x.net_value)
                           FROM rv_billing_docs x
                           WHERE x.customer_id = d.customer_id
                             AND x.billing_type = 'F2');
```

→ 90000010, C500, 14,000.00 (C500's average is 7,900.00). Same table, two aliases: `d` outer, `x` inner.

**3 · Latest invoice per customer**

```sql
SELECT d.customer_id, d.billing_doc, d.billing_date, d.net_value
FROM rv_billing_docs d
WHERE d.billing_type = 'F2'
  AND d.billing_date = (SELECT MAX(x.billing_date)
                        FROM rv_billing_docs x
                        WHERE x.customer_id = d.customer_id
                          AND x.billing_type = 'F2')
ORDER BY d.customer_id;
```

| customer_id | billing_doc | billing_date | net_value |
| --- | --- | --- | --- |
| C100 | 90000015 | 2026-11-05 | 7500.00 |
| C200 | 90000019 | 2026-12-30 | 5500.00 |
| C300 | 90000017 | 2026-12-08 | 6000.00 |
| C400 | 90000018 | 2026-12-22 | 9600.00 |
| C500 | 90000020 | **2027-01-04** | 5000.00 |
| C600 | 90000006 | 2026-05-12 | 15000.00 |
| C800 | 90000009 | 2026-07-07 | 2400.00 |

90000020 was billed on 4 January 2027 but posted on 31 December 2026: a **cut-off** exception.

**4 · `EXISTS`: customers with sales posted in December 2026**

```sql
SELECT c.customer_id, c.name
FROM rv_customers c
WHERE EXISTS (SELECT 1
              FROM rv_billing_docs d
              WHERE d.customer_id = c.customer_id
                AND d.billing_type = 'F2'
                AND d.posting_date BETWEEN '2026-12-01' AND '2026-12-31')
ORDER BY c.customer_id;           -- C200, C300, C400, C500
```

`EXISTS` stops at the first match and returns TRUE/FALSE, so `SELECT 1` is enough.

**5 · `NOT EXISTS`: invoices without items** → 90000019, C200, 5,500.00

```sql
SELECT d.billing_doc, d.customer_id, d.net_value
FROM rv_billing_docs d
WHERE NOT EXISTS (SELECT 1
                  FROM rv_billing_items i
                  WHERE i.billing_doc = d.billing_doc);
```

**6 · `NOT EXISTS`: credit memos without a valid original invoice**

```sql
SELECT g.billing_doc, g.billing_date, g.customer_id, g.ref_doc, g.net_value
FROM rv_billing_docs g
WHERE g.billing_type = 'G2'
  AND NOT EXISTS (SELECT 1
                  FROM rv_billing_docs f
                  WHERE f.billing_doc = g.ref_doc
                    AND f.billing_type = 'F2');
```

| billing_doc | billing_date | customer_id | ref_doc | net_value |
| --- | --- | --- | --- | --- |
| 90000023 | 2026-12-15 | C300 | 90000099 | -1200.00 |
| 90000024 | 2026-12-29 | C400 | NULL | -1500.00 |

**7 · `NOT EXISTS` is NULL-safe: invoices never credited** → 18

```sql
SELECT COUNT(*)
FROM rv_billing_docs f
WHERE f.billing_type = 'F2'
  AND NOT EXISTS (SELECT 1
                  FROM rv_billing_docs g
                  WHERE g.billing_type = 'G2'
                    AND g.ref_doc = f.billing_doc);
```

The same question with `NOT IN` returned **0** because of the NULL `ref_doc` ([lesson 1](subqueries-in-where-in-mysql.md)).

## Subquery or JOIN?

| Use | When |
| --- | --- |
| `IN` / `EXISTS` subquery | You only **filter** on another table; no columns needed from it, no duplicate rows |
| `JOIN` | You need **columns from both** tables |
| `NOT EXISTS` | "Has no matching row"; safe with NULLs |
| `LEFT JOIN … IS NULL` | Same result as `NOT EXISTS`; often the same plan |

## More real-world examples

```sql
-- Opex approved above the approver's own limit
SELECT o.doc_no, o.amount, o.approved_by
FROM opex_postings o
WHERE o.amount > (SELECT e.approval_limit
                  FROM employees e
                  WHERE e.emp_id = o.approved_by);

-- Journal lines more than 3× the average line on the same account
SELECT j.belnr, j.hkont, j.dmbtr, j.usnam
FROM je_lines j
WHERE j.dmbtr > 3 * (SELECT AVG(x.dmbtr)
                     FROM je_lines x
                     WHERE x.hkont = j.hkont);

-- Trial balance accounts with no journal activity in the year
SELECT t.hkont, t.txt50, t.closing
FROM trial_balance t
WHERE NOT EXISTS (SELECT 1 FROM je_lines j WHERE j.hkont = t.hkont);

-- Customers whose year-end open AR exceeds their credit limit
SELECT c.customer_id, c.name, c.credit_limit
FROM ar_customers c
WHERE c.credit_limit < (SELECT SUM(o.open_amount)
                        FROM ar_open_items_ye o
                        WHERE o.customer_id = c.customer_id);

-- Sales lines priced above the material's list price
SELECT r.vbeln, r.maktx, r.netpr
FROM revenue_lines r
WHERE r.netpr > (SELECT m.list_price
                 FROM materials m
                 WHERE m.material_id = r.matnr);
```

## ⚠️ Common mistakes

| Mistake | Problem | Fix |
| --- | --- | --- |
| Same alias inside and outside | Inner query compares the table with itself | Different aliases (`d` outer, `x` inner) |
| Forgetting the link condition | Becomes a regular subquery: compares with the overall figure | Add `WHERE x.key = d.key` |
| Correlated subquery on a large table, unindexed | Slow: runs per row | Index the link column, or use a derived table + `JOIN` |
| `NOT IN` where NULLs are possible | Zero rows | Use `NOT EXISTS` |

## 🎯 Key takeaways

1. A **correlated** subquery uses an outer column and is evaluated per row: compare each row with its own group.
2. `EXISTS` / `NOT EXISTS` answer "is there a matching row?" and are **NULL-safe**.
3. `NOT EXISTS` is the standard completeness test: invoices without items, credit memos without invoices, accounts without activity.
4. Use a subquery to **filter**, a `JOIN` to **bring back columns**; index the link columns.
