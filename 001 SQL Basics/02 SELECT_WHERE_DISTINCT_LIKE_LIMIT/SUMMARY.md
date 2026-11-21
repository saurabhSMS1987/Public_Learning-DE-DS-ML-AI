# 📝 Summary: SELECT, WHERE, DISTINCT, LIKE, LIMIT

One-page revision sheet. Lessons are listed in the [README](README.md).

## 🧱 Clause order

Written in this order:

```sql
SELECT DISTINCT belnr, usnam, dmbtr      -- 1 · columns (DISTINCT optional)
FROM je_lines                            -- 2 · table
WHERE shkzg = 'S'                        -- 3 · filter rows
  AND sgtxt LIKE '%adj%'                 --     pattern filter
ORDER BY dmbtr DESC, belnr               -- 4 · sort
LIMIT 5;                                 -- 5 · cut
```

MySQL runs it as: `FROM` → `WHERE` → `SELECT` → `DISTINCT` → `ORDER BY` → `LIMIT`.

## Cheat sheet

| Topic | Key syntax | Remember |
| --- | --- | --- |
| **SELECT** | `SELECT col AS alias, expr FROM t` | Name columns instead of `*`; `AS` for readable output |
| **WHERE** | `=`, `<>`, `>=`, `AND`, `OR`, `IN`, `BETWEEN`, `IS NULL` | Quote text and dates; brackets around `OR`; `IS NULL`, never `= NULL` |
| **DISTINCT** | `SELECT DISTINCT a, b` / `COUNT(DISTINCT a)` | Works on the whole column combination; `COUNT(*)` vs `COUNT(DISTINCT)` reveals duplicates |
| **LIKE** | `'abc%'` starts, `'%abc'` ends, `'%abc%'` contains, `_` one character | Case-insensitive; escape `\_`; `NULL` never matches |
| **LIMIT** | `ORDER BY … DESC LIMIT n OFFSET m` | Always sort first; add a tie-breaker |

## 🔎 Audit queries on the sample

| Question | Query core | Result |
| --- | --- | --- |
| Year-end manual entries | `WHERE budat = '2026-12-31' AND blart = 'SA' AND shkzg = 'S'` | 4 docs |
| Weekend postings | `WHERE DAYOFWEEK(budat) IN (1, 7) AND shkzg = 'S'` | 5 docs |
| Blank line text | `WHERE sgtxt IS NULL OR sgtxt = ''` | 1 line |
| Who posted? | `SELECT DISTINCT usnam` | 9 users |
| Duplicate invoices | `COUNT(*)` vs `COUNT(DISTINCT sgtxt, dmbtr)` for `blart = 'RE'` | 3 vs 2 |
| Reversals | `WHERE sgtxt LIKE '%reversal%'` | 1 doc |
| Top 5 debits | `WHERE shkzg = 'S' ORDER BY dmbtr DESC, belnr LIMIT 5` | 250k, 250k, 180k, 100k, 80k |

## 🎯 Key takeaways

1. **SELECT** picks and shapes columns; it never changes data.
2. **WHERE** defines the population: get the filter right before testing anything.
3. **DISTINCT** shows unique values and, with counts, exposes duplicates.
4. **LIKE** finds text patterns: keywords, prefixes, number ranges.
5. **LIMIT** with **ORDER BY** gives top-N lists and previews, not full populations.
