# 📝 Summary: Calculated Columns (IF, CASE, YEAR, Current Year)

One-page revision sheet. Lessons are listed in the [README](README.md).

## 🧱 All four in one query

```sql
SET @audit_date = '2026-12-31';                        -- fixed as-at date

SELECT anln1, txt50,
       cost_to_date - settled                              AS cwip_balance,      -- calculation
       IF(cost_to_date > budget, 'Over', 'Within')         AS budget_flag,       -- IF
       CASE                                                                      -- CASE
           WHEN status = 'TECO' AND settled = 0 THEN 'Capitalise'
           WHEN status = 'REL' AND plan_end < @audit_date THEN 'Overdue'
           ELSE 'OK'
       END                                                 AS audit_flag,
       YEAR(start_date)                                    AS start_year,        -- YEAR
       YEAR(CURDATE()) - YEAR(start_date)                  AS years_since_start  -- current year
FROM cwip_assets
ORDER BY cwip_balance DESC;
```

## Cheat sheet

| Topic | Syntax | Remember |
| --- | --- | --- |
| **IF** | `IF(cond, a, b)` · `IFNULL(col, x)` | Two outcomes; MySQL-only; `SUM(IF(…, amt, 0))` for conditional totals |
| **CASE** | `CASE WHEN … THEN … ELSE … END` | Many outcomes; first true `WHEN` wins; always add `ELSE`; standard SQL |
| **YEAR** | `YEAR(date)` · `TIMESTAMPDIFF(YEAR, a, b)` | Group by year; use ranges in `WHERE` for indexes; full years for ages |
| **Current year** | `YEAR(CURDATE())` · `MAKEDATE(YEAR(CURDATE()), 1)` | Current year = `YEAR(CURDATE())`; results change daily; use `@audit_date` for audit work |

## 🔎 CWIP audit findings (as at 31 Dec 2026)

| Finding | Query core | Result |
| --- | --- | --- |
| Complete, not capitalised | `SUM(IF(status = 'TECO', cost_to_date - settled, 0))` | 2,499,100.00 (6 assets) |
| Stale or no postings | `CASE WHEN status = 'REL' AND last_post < @audit_date - 12 months …` | 4 assets |
| Overdue projects | `plan_end < @audit_date AND status = 'REL'` | 3 assets |
| Over budget > 10% | `CASE WHEN cost_to_date > budget * 1.10 …` | 2 assets |
| Repairs in CWIP | `IF(txt50 LIKE '%repair%' OR …)` | 277,950.00 (3 items) |
| Over-settled | `IF(cost_to_date - settled < 0, …)` | -9,000.00 (1 asset) |
| Aged 2+ years | `CASE` on `TIMESTAMPDIFF(YEAR, start_date, @audit_date)` | 1,872,000.00 (4 assets) |

## 🎯 Key takeaways

1. **Calculated columns** add business meaning without changing the table.
2. **IF** for yes/no flags; **CASE** for categories; both work inside `SUM` for pivots.
3. **YEAR** and **TIMESTAMPDIFF** turn dates into years and ages.
4. **`YEAR(CURDATE())`** is the current year; a fixed **`@audit_date`** keeps audit results reproducible.
5. In CWIP audits these four expose capitalisation, impairment and classification risks.
