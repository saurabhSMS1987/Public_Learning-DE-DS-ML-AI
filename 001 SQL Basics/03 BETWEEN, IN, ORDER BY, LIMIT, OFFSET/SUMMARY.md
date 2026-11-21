# 📝 Summary: BETWEEN, IN, ORDER BY, LIMIT, OFFSET

One-page revision sheet. Lessons are listed in the [README](README.md).

## 🧱 All five in one query

```sql
SELECT belnr, name1, zbd1t, dmbtr
FROM ap_invoices
WHERE dmbtr BETWEEN 5000 AND 100000      -- range, both ends included
  AND zbd1t IN (30, 45, 60)              -- list
ORDER BY dmbtr DESC, belnr               -- sort + tie-breaker
LIMIT 5 OFFSET 5;                        -- page 2 of 5 rows
```

Clause order is fixed: `WHERE` → `ORDER BY` → `LIMIT` → `OFFSET`.

## Cheat sheet

| Topic | Syntax | Remember |
| --- | --- | --- |
| **BETWEEN** | `col BETWEEN low AND high` | Both ends included; low value first; `NOT BETWEEN` for outside |
| **IN** | `col IN (a, b, c)` | Short for several `OR`s; quote text values; no `NULL` in `NOT IN` |
| **ORDER BY** | `ORDER BY col1 DESC, col2` | `ASC` default; direction per column; only way to guarantee order |
| **LIMIT** | `ORDER BY … LIMIT n` | Last clause; top-N with `DESC`, bottom-N with `ASC` |
| **OFFSET** | `LIMIT n OFFSET m` / `LIMIT m, n` | Skip `m` rows; page offset = `(page - 1) × size`; Nth row = `OFFSET N-1` |

## 🔎 Audit queries on the sample

| Question | Query core | Result |
| --- | --- | --- |
| Just below 50,000 approval limit | `WHERE dmbtr BETWEEN 45000 AND 49999.99` | 3 invoices (2 from Steel Supply, same day) |
| Suspicious amounts | `WHERE dmbtr IN (2400, 9999, 25000, 100000)` | 7 invoices |
| Immediate / short terms | `WHERE zbd1t IN (0, 10)` | 9 invoices |
| Top 5 invoices | `ORDER BY dmbtr DESC LIMIT 5` | 100,000 → 49,950 |
| Largest open invoices | `WHERE status = 'OPEN' ORDER BY dmbtr DESC LIMIT 3` | 75,000 / 54,300 / 49,990 |
| 2nd largest invoice | `ORDER BY dmbtr DESC, belnr LIMIT 1 OFFSET 1` | 75,000.00 |

## 🎯 Key takeaways

1. **BETWEEN** filters inclusive ranges: watch the upper boundary at thresholds.
2. **IN** filters lists: match the column type and keep `NULL` out of `NOT IN`.
3. **ORDER BY** guarantees order: give each column its own direction.
4. **LIMIT** cuts the sorted result: always sort first.
5. **OFFSET** pages through results: needs a stable sort with a tie-breaker.
