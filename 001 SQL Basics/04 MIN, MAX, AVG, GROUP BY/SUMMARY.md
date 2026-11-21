# 📝 Summary: MIN, MAX, AVG, GROUP BY

One-page revision sheet. Lessons are listed in the [README](README.md).

## 🧱 All four in one query

```sql
SELECT region,
       MIN(netwr)            AS min_line,
       MAX(netwr)            AS max_line,
       ROUND(AVG(netwr), 2)  AS avg_line,
       SUM(netwr)            AS revenue
FROM revenue_lines
WHERE fkart = 'F2'                                    -- rows: invoices only
  AND fkdat BETWEEN '2026-01-01' AND '2026-12-31'     -- rows: FY2026
GROUP BY region                                       -- one row per region
HAVING SUM(netwr) > 100000                            -- groups: large regions
ORDER BY revenue DESC;
```

Run order: `FROM` → `WHERE` → `GROUP BY` → aggregates → `HAVING` → `SELECT` → `ORDER BY`.

## Cheat sheet

| Topic | Syntax | Remember |
| --- | --- | --- |
| **MIN** | `MIN(col)` | Smallest number, earliest date; credits (negatives) come first |
| **MAX** | `MAX(col)` | Largest number, latest date; check dates against period-end |
| **AVG** | `ROUND(AVG(col), 2)` | Ignores `NULL`, counts `0`; weighted = `SUM(a) / SUM(b)` |
| **GROUP BY** | `GROUP BY col` + `HAVING` | Every selected column grouped or aggregated; `WHERE` before, `HAVING` after |

All aggregates **ignore `NULL`**. Find the row behind an extreme with `WHERE col = (SELECT MAX(col) …)`.

## 🔎 Revenue audit findings on the sample

| Question | Query core | Result |
| --- | --- | --- |
| Largest sale | `MAX(netwr)` + subquery | 156,000.00, Delta Distributors, 30 Dec, `SALES_MGR` |
| Billing after year-end | `MAX(fkdat)` | 2027-01-08 credit memo reversing that sale |
| Price outlier | `MIN` / `MAX(netpr)` for `P-100` | 1,250 vs 1,950 |
| Zero-value line | `MIN(netwr)` for invoices | 0.00, Northwind Stores |
| Outlier lines | `netwr > 2 × AVG(netwr)` | 2 lines, both Delta Distributors |
| Year-end spike | `GROUP BY MONTH(fkdat)` | December 301,550 = 40% of the year |
| Top customer | `GROUP BY name1 ORDER BY SUM DESC` | Delta Distributors, 228,000 from 2 lines |

## 🚨 Errors to recognise

| Code | Meaning |
| --- | --- |
| 1055 | Selected column not in `GROUP BY` |
| 1064 | Syntax error, e.g. reserved word `lines` as an alias |
| 1111 | Aggregate used in `WHERE`: move it to `HAVING` |
| 1140 | Non-aggregated column with an aggregate and no `GROUP BY` |

## 🎯 Key takeaways

1. **MIN / MAX** find extremes: zero prices, largest sales, first and last dates.
2. **AVG** gives the typical value: filter credits and zeros, round money, prefer weighted prices.
3. **GROUP BY** turns detail into summaries: by customer, month, region, user.
4. **HAVING** filters summaries; **WHERE** filters detail.
5. Summaries point to the risk; then drill down to the **rows** behind them.
