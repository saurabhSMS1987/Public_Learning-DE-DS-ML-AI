# ⬆️ MAX in MySQL

`MAX()` returns the **largest** value in a column: the highest amount, the latest date or the last text alphabetically.

> Part of my learning journey in **Data Engineering, Data Science & AI** · Data: `revenue_lines` ([setup](README.md#setup))

## Syntax

```sql
SELECT MAX(column) AS alias
FROM table_name
WHERE condition;
```

## Examples

**1 · Largest line and last billing date**

```sql
SELECT MAX(netwr) AS largest_line,
       MAX(fkdat) AS last_billing
FROM revenue_lines;
```

| largest_line | last_billing |
| --- | --- |
| 156000.00 | 2027-01-08 |

The last date falls **after year-end**: a 2027 document in a FY2026 extract is a cut-off item to check.

**2 · Who billed the largest line?**

```sql
SELECT vbeln, fkdat, name1, netwr, ernam
FROM revenue_lines
WHERE netwr = (SELECT MAX(netwr) FROM revenue_lines);
```

| vbeln | fkdat | name1 | netwr | ernam |
| --- | --- | --- | --- | --- |
| 90000022 | 2026-12-30 | Delta Distributors | 156000.00 | SALES_MGR |

Largest sale of the year: 30 December, new customer, entered manually by a sales manager.

**3 · Highest selling price of a product**

```sql
SELECT MAX(netpr) FROM revenue_lines
WHERE matnr = 'P-100';                    -- 1950.00 vs list price 1250.00
```

**4 · Range with MIN** (spread between extremes)

```sql
SELECT MAX(netpr) - MIN(netpr) AS price_spread
FROM revenue_lines
WHERE matnr = 'P-100' AND fkart = 'F2';   -- 700.00
```

## 🧪 Try it

1. Largest line billed by `BATCH_SD` → 37,500.00.
2. Last billing date **within** 2026 (`fkdat <= '2026-12-31'`) → 2026-12-31.
3. Largest quantity on one line → 400 (fastener boxes).

## ⚠️ Common mistakes

| Mistake | Problem | Fix |
| --- | --- | --- |
| `SELECT name1, MAX(netwr) FROM …` | `Error 1140`, or a name from a different row | Use the subquery in Example 2 |
| `ORDER BY netwr DESC LIMIT 1` to get "the" max | Hides ties | `WHERE netwr = (SELECT MAX(netwr) …)` returns all tied rows |
| `MAX(fkdat)` assumed to be in the period | Extract may include later documents | Check it against the period end |

## 🎯 Key takeaways

1. `MAX()` returns the largest value: numbers, **dates** (latest) and text (Z last).
2. `NULL`s are ignored.
3. `MAX - MIN` shows the **range** of a column.
4. Find the row behind the maximum with `WHERE col = (SELECT MAX(col) …)`.
5. Audit uses: largest sales, unusual prices, documents dated **after period-end**.
