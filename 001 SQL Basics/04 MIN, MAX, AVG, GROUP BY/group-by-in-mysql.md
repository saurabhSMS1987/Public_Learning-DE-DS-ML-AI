# 🗂️ GROUP BY in MySQL

`GROUP BY` splits rows into groups and runs aggregate functions (`COUNT`, `SUM`, `MIN`, `MAX`, `AVG`) **once per group**: revenue by customer, by region, by month.

> Part of my learning journey in **Data Engineering, Data Science & AI** · Data: `revenue_lines` ([setup](README.md#setup))

## Syntax

```sql
SELECT group_column, AGG(column) AS alias
FROM table_name
WHERE row_condition              -- filters rows   (before grouping)
GROUP BY group_column
HAVING group_condition           -- filters groups (after grouping)
ORDER BY alias DESC;
```

## Examples

**1 · Revenue by customer** (FY2026)

```sql
SELECT name1,
       COUNT(*)   AS line_count,
       SUM(netwr) AS revenue
FROM revenue_lines
WHERE fkdat BETWEEN '2026-01-01' AND '2026-12-31'
GROUP BY name1
ORDER BY revenue DESC;
```

| name1 | line_count | revenue |
| --- | --- | --- |
| Delta Distributors | 2 | 228000.00 |
| Acme Retail | 5 | 155000.00 |
| Müller GmbH | 5 | 143350.00 |
| Northwind Stores | 6 | 113950.00 |
| Pacific Traders | 5 | 60225.00 |
| Sunrise Hospitals | 6 | 55650.00 |

The top customer has only 2 lines, both in the last days of the year.

**2 · Revenue by month: spotting a year-end spike**

```sql
SELECT MONTH(fkdat) AS month, SUM(netwr) AS revenue
FROM revenue_lines
WHERE fkdat BETWEEN '2026-01-01' AND '2026-12-31'
GROUP BY MONTH(fkdat)
ORDER BY month;
```

| month | 1 | 2 | 3 | … | 10 | 11 | **12** |
| --- | --- | --- | --- | --- | --- | --- | --- |
| revenue | 52,550 | 55,500 | 36,700 | … | 42,425 | 63,700 | **301,550** |

December is **40%** of the year's revenue.

**3 · Several aggregates per group**

```sql
SELECT region,
       SUM(netwr)           AS revenue,
       ROUND(AVG(netwr), 2) AS avg_line,
       MIN(netwr)           AS min_line,
       MAX(netwr)           AS max_line
FROM revenue_lines
WHERE fkart = 'F2' AND fkdat BETWEEN '2026-01-01' AND '2026-12-31'
GROUP BY region
ORDER BY revenue DESC;
```

| region | revenue | avg_line | min_line | max_line |
| --- | --- | --- | --- | --- |
| South | 283650.00 | 35456.25 | 6000.00 | 156000.00 |
| Midwest | 155000.00 | 31000.00 | 22500.00 | 50000.00 |
| … | … | … | … | … |

**4 · Group by two columns**

```sql
SELECT matnr, maktx, MIN(netpr) AS min_price, MAX(netpr) AS max_price
FROM revenue_lines
WHERE fkart = 'F2' AND netpr > 0
GROUP BY matnr, maktx;           -- P-100 sold between 1,250 and 1,950
```

**5 · Filter groups with `HAVING`**

```sql
SELECT name1, SUM(netwr) AS revenue
FROM revenue_lines
WHERE fkdat BETWEEN '2026-01-01' AND '2026-12-31'
GROUP BY name1
HAVING SUM(netwr) > 150000;      -- Acme Retail, Delta Distributors
```

`WHERE` can't use aggregates; `HAVING` can.

## 🧪 Try it

1. FY2026 revenue by material, highest first → `P-100` 447,250.00.
2. Revenue and document count by user (`ernam`) for FY2026 → `SALES_MGR`: 3 documents, 278,000.00.
3. Months of 2026 with revenue above 50,000 → 5 (1, 2, 8, 11, 12).

## ⚠️ Common mistakes

| Mistake | Problem | Fix |
| --- | --- | --- |
| `SELECT name1, region, SUM(netwr) … GROUP BY name1` | `Error 1055`: `region` not grouped | Add every non-aggregated column to `GROUP BY` |
| `WHERE SUM(netwr) > 150000` | `Error 1111`: aggregates not allowed in `WHERE` | Use `HAVING` |
| `AS lines` | `Error 1064`: `LINES` is a reserved word | Use `line_count` |
| `COUNT(*)` read as documents | Counts **lines** | `COUNT(DISTINCT vbeln)` |

## 🎯 Key takeaways

1. `GROUP BY` returns **one row per group**, with aggregates calculated per group.
2. Every selected column must be **grouped or aggregated**.
3. `WHERE` filters rows **before** grouping; `HAVING` filters groups **after**.
4. Group by expressions such as `MONTH(fkdat)` for trends.
5. Audit uses: revenue by customer, month, region and user; year-end spikes and concentration.
