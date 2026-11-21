# ➗ AVG in MySQL

`AVG()` returns the **average** (mean) of a numeric column: the sum divided by the number of non-`NULL` values.

> Part of my learning journey in **Data Engineering, Data Science & AI** · Data: `revenue_lines` ([setup](README.md#setup))

## Syntax

```sql
SELECT ROUND(AVG(column), 2) AS alias
FROM table_name
WHERE condition;
```

## Examples

**1 · Average invoice line**

```sql
SELECT AVG(netwr)           AS avg_line,
       ROUND(AVG(netwr), 2) AS avg_rounded
FROM revenue_lines
WHERE fkart = 'F2';
```

| avg_line | avg_rounded |
| --- | --- |
| 27091.964286 | 27091.96 |

Credit memos are excluded: including them drops the average to 20,005.83.

**2 · Lines far above average**

```sql
SELECT vbeln, name1, netwr
FROM revenue_lines
WHERE fkart = 'F2'
  AND netwr > 2 * (SELECT AVG(netwr) FROM revenue_lines WHERE fkart = 'F2');
```

| vbeln | name1 | netwr |
| --- | --- | --- |
| 90000022 | Delta Distributors | 156000.00 |
| 90000023 | Delta Distributors | 72000.00 |

**3 · Simple vs weighted average price**

```sql
SELECT ROUND(AVG(netpr), 2)              AS simple_avg,     -- 1320.00: each line counts once
       ROUND(SUM(netwr) / SUM(fkimg), 2) AS weighted_avg    -- 1428.91: weighted by quantity
FROM revenue_lines
WHERE matnr = 'P-100' AND fkart = 'F2';
```

The weighted average is higher because the large Delta order carried a 1,950 price.

**4 · Zeros count, `NULL`s don't**

```sql
SELECT ROUND(AVG(netpr), 2)              AS all_lines,      -- 28.40: includes the 0.00 line
       ROUND(AVG(NULLIF(netpr, 0)), 2)   AS excl_zero       -- 35.50: zero treated as NULL
FROM revenue_lines
WHERE matnr = 'P-300';
```

## 🧪 Try it

1. Average line value for `Acme Retail` → 31,000.00.
2. Average quantity per `P-200` invoice line → 56.67.
3. Average invoice line in December 2026 → 60,310.00 (more than double the year's average).

## ⚠️ Common mistakes

| Mistake | Problem | Fix |
| --- | --- | --- |
| Averaging invoices and credits together | Credits pull the average down | Filter `fkart = 'F2'` |
| `AVG(netpr)` as "the" average price | Ignores quantity | `SUM(netwr) / SUM(fkimg)` |
| Zeros left in by accident | Lower average than expected | `AVG(NULLIF(col, 0))` |
| Long decimals in reports | `27091.964286` | `ROUND(AVG(col), 2)` |

## 🎯 Key takeaways

1. `AVG()` = sum ÷ count of **non-`NULL`** values; `0` is included.
2. Wrap in `ROUND(…, 2)` for money.
3. Filter the population first: credit memos and zero lines distort the mean.
4. **Weighted average** (`SUM ÷ SUM`) is more accurate for prices.
5. Comparing lines with `n × AVG` is a quick outlier test.
