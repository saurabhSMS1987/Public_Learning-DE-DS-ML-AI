# 📝 Summary: SQL Joins (INNER, LEFT, RIGHT, FULL)

One-page revision sheet. Lessons are listed in the [README](README.md).

## 🧱 The four joins at a glance

| Join | Keeps | Unmatched rows | `deliveries` ⨝ `billing` |
| --- | --- | --- | --- |
| `INNER JOIN` | Matches only | Dropped from both sides | 15 rows |
| `LEFT JOIN` | All left + matches | Right columns `NULL` | 16 rows |
| `RIGHT JOIN` | All right + matches | Left columns `NULL` | 18 rows |
| `FULL JOIN` | Everything | `NULL` on the missing side | 19 rows |

```sql
-- INNER: matched
SELECT … FROM deliveries d INNER JOIN billing b ON b.delivery_no = d.delivery_no;

-- LEFT anti-join: shipped, not billed
SELECT … FROM deliveries d LEFT JOIN billing b ON b.delivery_no = d.delivery_no
WHERE b.billing_no IS NULL;

-- RIGHT anti-join: billed, no delivery
SELECT … FROM deliveries d RIGHT JOIN billing b ON b.delivery_no = d.delivery_no
WHERE d.delivery_no IS NULL;

-- FULL in MySQL: LEFT + UNION ALL + unmatched RIGHT rows
SELECT … FROM deliveries d LEFT JOIN billing b ON b.delivery_no = d.delivery_no
UNION ALL
SELECT … FROM deliveries d RIGHT JOIN billing b ON b.delivery_no = d.delivery_no
WHERE d.delivery_no IS NULL;
```

## Cheat sheet

| Rule | Why |
| --- | --- |
| Alias every table and prefix every column (`b.net_value`) | Avoids `Error 1052: ambiguous column` |
| Join on the full key | A missing or partial key multiplies rows |
| Conditions on the optional table go in `ON` | In `WHERE` they turn an outer join into an inner join |
| Test the joined table's **key** for `IS NULL` | Finds rows with no match |
| `COUNT(right.key)`, `IFNULL(SUM(…), 0)` | Correct counts and totals after outer joins |
| Reconcile joined totals to the source | Inner joins drop unmatched rows silently |
| Never write `FULL JOIN` in MySQL | `Error 1064`, or a silent inner join when `FULL` is read as an alias |

## 🔎 Revenue vs volume reconciliation (FY2026)

| Status | Items | Billed value | Found with |
| --- | --- | --- | --- |
| Matched | 14 | 331,575.00 | `INNER JOIN` |
| Quantity mismatch | 1 | 40,000.00 (3 units, 3,750.00 under-billed) | `INNER JOIN … WHERE qty differs` |
| Shipped, not billed | 1 | — (~10,650.00 at list price) | `LEFT JOIN … IS NULL` |
| Billed, no delivery | 3 | 63,150.00 | `RIGHT JOIN … IS NULL` |
| **Total billing** | **18** | **434,725.00** | `FULL JOIN` covers every document |

Also found: a December delivery billed in January 2027 (38,400.00 cut-off), billing to an unknown customer (3,550.00), a customer with no sales and a material never shipped.

## 🎯 Key takeaways

1. **INNER** = matches only; **LEFT/RIGHT** = all rows of one side; **FULL** = all rows of both.
2. `LEFT JOIN … WHERE right.key IS NULL` is the most useful audit pattern: **what is missing?**
3. Put conditions on the optional table in **`ON`**, not `WHERE`.
4. MySQL builds FULL JOINs with **`UNION`**; never trust `FULL JOIN` syntax there.
5. Joins turn two data sources into a **reconciliation**: completeness, occurrence, cut-off and accuracy in one place.
