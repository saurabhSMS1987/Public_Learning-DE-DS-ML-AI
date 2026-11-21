# 📝 Summary: HAVING Clause in SQL

## The rule

> **`WHERE` filters rows before grouping. `HAVING` filters groups after grouping.**

```sql
SELECT name1, SUM(netwr) AS revenue
FROM revenue_lines
WHERE fkdat BETWEEN '2026-01-01' AND '2026-12-31'   -- rows
GROUP BY name1
HAVING SUM(netwr) > 150000                          -- groups
ORDER BY revenue DESC;
```

Run order: `FROM` → `WHERE` → `GROUP BY` → `HAVING` → `SELECT` → `ORDER BY` → `LIMIT`.

## Cheat sheet

| Pattern | Example |
| --- | --- |
| Threshold on a total | `HAVING SUM(netwr) > 150000` |
| Count of rows / documents | `HAVING COUNT(DISTINCT vbeln) <= 2` |
| Average | `HAVING AVG(netwr) > 30000` |
| Range within a group | `HAVING MAX(netpr) > MIN(netpr)` |
| Compare with an overall figure | `HAVING SUM(netwr) > 2 * (SELECT SUM(netwr) / 12 FROM …)` |
| Several conditions | `HAVING SUM(netwr) > 100000 AND COUNT(*) < 5` |

## 🔎 Findings on the sample

| Question | Result |
| --- | --- |
| Customers above 150,000 (FY2026) | Acme Retail, Delta Distributors |
| Big revenue from ≤ 2 documents | Delta Distributors: 228,000 |
| Months > 2 × monthly average | December: 301,550 |
| Products sold at more than one price | `P-100`: 1,250 to 1,950 |
| Manual year-end billing ≥ 100,000 | `SALES_MGR`: 278,000 |

## 🚨 Errors to recognise

| Code | Cause |
| --- | --- |
| 1111 | Aggregate in `WHERE`: move it to `HAVING` |
| 1054 | `HAVING` uses a column that is neither grouped nor aggregated |

## 🎯 Key takeaways

1. `HAVING` = `WHERE` for groups.
2. It needs aggregates (or grouped columns), and runs after `GROUP BY`.
3. Keep row filters in `WHERE`: correct and faster.
4. MySQL allows `SELECT` aliases and subqueries in `HAVING`.
5. In audit, `HAVING` turns summaries into **exception lists**.
