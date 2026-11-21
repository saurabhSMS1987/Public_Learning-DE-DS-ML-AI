# 📅 YEAR in MySQL

`YEAR()` extracts the year from a date. Use it to group, filter and compare data **by year**, and to calculate ages.

> Part of my learning journey in **Data Engineering, Data Science & AI** · Data: `cwip_assets` ([setup](README.md#setup))

## Syntax

```sql
YEAR(date)              -- 2026-12-31 → 2026

-- Related date-part functions
MONTH(date)             -- 12
QUARTER(date)           -- 4
MONTHNAME(date)         -- 'December'
TIMESTAMPDIFF(YEAR, start, end)   -- full years between two dates
```

## CWIP examples

**1 · Open CWIP by start year** (`GROUP BY YEAR`)

```sql
SELECT YEAR(start_date)            AS start_year,
       COUNT(*)                    AS assets,
       SUM(cost_to_date - settled) AS balance
FROM cwip_assets
WHERE status <> 'CLSD'
GROUP BY YEAR(start_date)
ORDER BY start_year;
```

| start_year | assets | balance |
| --- | --- | --- |
| 2022 | 1 | 185000.00 |
| 2023 | 1 | 341000.00 |
| 2024 | 2 | 1346000.00 |
| 2025 | 2 | 4020500.00 |
| 2026 | 13 | 3765750.00 |

**2 · Projects with no cost posted this year** (stale)

```sql
SELECT anln1, txt50, YEAR(last_post) AS last_post_year
FROM cwip_assets
WHERE status = 'REL'
  AND (YEAR(last_post) < 2026 OR last_post IS NULL);
-- Solar roof 2023 · Data center cooling 2024 · Parking lot 2025 · Website relaunch NULL
```

**3 · Calendar years vs full years**

```sql
SELECT YEAR('2026-01-02') - YEAR('2025-12-31')                  AS calendar_years,   -- 1
       TIMESTAMPDIFF(YEAR, '2025-12-31', '2026-01-02')          AS full_years;       -- 0
```

Subtracting years counts **calendar boundaries**; `TIMESTAMPDIFF` counts **completed years**. Use `TIMESTAMPDIFF` for aging.

**4 · Fiscal year that starts in April** (shift the date, then take the year)

```sql
SELECT anln1, start_date,
       YEAR(DATE_SUB(start_date, INTERVAL 3 MONTH)) + 1 AS fiscal_year
FROM cwip_assets;
-- 2025-03-01 → FY2025 · 2026-02-15 → FY2026 · 2026-11-01 → FY2027
```

**5 · Filter by year: two ways**

```sql
-- Readable, but the function on the column prevents index use
SELECT COUNT(*) FROM cwip_assets WHERE YEAR(last_post) = 2026;                          -- 20

-- Same result, and can use an index on last_post
SELECT COUNT(*) FROM cwip_assets WHERE last_post BETWEEN '2026-01-01' AND '2026-12-31'; -- 20
```

## 🌍 More real-world examples

Tables from my earlier sections (see [README](README.md#real-world-examples)):

```sql
-- Revenue by year: spot postings outside the audit period
SELECT YEAR(fkdat) AS billing_year, SUM(netwr) AS revenue
FROM revenue_lines
GROUP BY YEAR(fkdat);                       -- 2026: 756,175.00 · 2027: -156,000.00

-- Revenue by quarter
SELECT QUARTER(fkdat) AS qtr, SUM(netwr) AS revenue
FROM revenue_lines
WHERE fkdat BETWEEN '2026-01-01' AND '2026-12-31'
GROUP BY QUARTER(fkdat);                    -- Q4 = 54% of the year

-- Journal entries whose posting date doesn't match the fiscal year field
SELECT belnr, budat, gjahr
FROM je_lines
WHERE YEAR(budat) <> gjahr;                 -- expected: none
```

## ⚠️ Common mistakes

| Mistake | Fix |
| --- | --- |
| `WHERE YEAR(date_col) = 2026` on big tables | Use a range so indexes work |
| `YEAR(end) - YEAR(start)` as an age | Use `TIMESTAMPDIFF(YEAR, start, end)` |
| `YEAR('31.12.2026')` | Returns `NULL`: convert with `STR_TO_DATE` first |
| Assuming fiscal year = calendar year | Shift the date for non-calendar fiscal years |

## 🎯 Key takeaways

1. `YEAR(date)` returns the year as a number; `MONTH`, `QUARTER`, `MONTHNAME` work the same way.
2. `GROUP BY YEAR(date)` gives yearly totals and exposes items outside the period.
3. For ages, use `TIMESTAMPDIFF(YEAR, start, end)` (completed years).
4. Prefer **date ranges** over `YEAR(col) = …` in `WHERE` for performance.
5. Non-calendar fiscal years: `YEAR(DATE_SUB(date, INTERVAL n MONTH))`, plus 1 if the fiscal year is named after its end year.
