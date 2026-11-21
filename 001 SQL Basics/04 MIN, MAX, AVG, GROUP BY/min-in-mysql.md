# ⬇️ MIN in MySQL

`MIN()` returns the **smallest** value in a column: the lowest amount, the earliest date or the first text alphabetically.

> Part of my learning journey in **Data Engineering, Data Science & AI** · Data: `revenue_lines` ([setup](README.md#setup))

## Syntax

```sql
SELECT MIN(column) AS alias
FROM table_name
WHERE condition;
```

## Examples

**1 · Smallest line and first billing date**

```sql
SELECT MIN(netwr) AS smallest_line,
       MIN(fkdat) AS first_billing
FROM revenue_lines;
```

| smallest_line | first_billing |
| --- | --- |
| -156000.00 | 2026-01-15 |

The smallest value is a **credit memo** (negative), not a small sale.

**2 · Smallest invoice line only** (exclude credit memos)

```sql
SELECT MIN(netwr) FROM revenue_lines
WHERE fkart = 'F2';                       -- 0.00
```

**3 · Find the row behind the minimum**

```sql
SELECT vbeln, name1, matnr, fkimg, netpr, netwr
FROM revenue_lines
WHERE fkart = 'F2'
  AND netwr = (SELECT MIN(netwr) FROM revenue_lines WHERE fkart = 'F2');
```

| vbeln | name1 | matnr | fkimg | netpr | netwr |
| --- | --- | --- | --- | --- | --- |
| 90000013 | Northwind Stores | P-300 | 0.000 | 0.00 | 0.00 |

A **zero-value line**: free goods, or a pricing error to ask about.

**4 · Lowest selling price of a product**

```sql
SELECT MIN(netpr) FROM revenue_lines
WHERE matnr = 'P-100';                    -- 1250.00 (list price)
```

## 🧪 Try it

1. First billing date for `Delta Distributors` → 2026-12-30 (a new customer at year-end).
2. Lowest unit price for `P-200` → 480.00.
3. Largest credit memo, i.e. `MIN(netwr)` where `fkart = 'G2'` → -156,000.00.

## ⚠️ Common mistakes

| Mistake | Problem | Fix |
| --- | --- | --- |
| `MIN(netwr)` over invoices and credits | Returns the biggest credit, not the smallest sale | Filter `fkart = 'F2'` |
| `SELECT vbeln, MIN(netwr) FROM …` | `Error 1140`: `vbeln` isn't aggregated | Use the subquery in Example 3, or `GROUP BY` |
| `MIN` on amounts stored as text | `'9.00'` sorts above `'10.00'` | Store amounts as `DECIMAL` |

## 🎯 Key takeaways

1. `MIN()` returns the smallest value: numbers, **dates** (earliest) and text (A first).
2. Negative values (credits) come first: **filter** to the population you mean.
3. `NULL`s are ignored.
4. To see the **row** behind the minimum, use `WHERE col = (SELECT MIN(col) …)`.
5. Audit uses: zero or unusually low prices, the earliest transaction, a customer's first sale.
