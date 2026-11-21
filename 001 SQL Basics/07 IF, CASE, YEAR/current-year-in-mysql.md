# 🗓️ Current Year in MySQL: `YEAR(CURDATE())`

Calculations "as of today": current year, year-to-date, age in years. In MySQL, the current year is **`YEAR(CURDATE())`**: `CURDATE()` returns today's date and `YEAR()` takes its year.

> Part of my learning journey in **Data Engineering, Data Science & AI** · Data: `cwip_assets` ([setup](README.md#setup))

## Syntax

```sql
CURDATE()                         -- today's date            2026-11-21
NOW()                             -- date and time           2026-11-21 12:51:27
YEAR(CURDATE())                   -- current year            2026
YEAR(CURDATE()) - 1               -- previous year           2025
MAKEDATE(YEAR(CURDATE()), 1)      -- 1 January this year     2026-01-01
```

```sql
SELECT CURDATE()             AS today,          -- 2026-11-21
       YEAR(CURDATE())       AS current_year,   -- 2026
       YEAR(CURDATE()) - 1   AS previous_year;  -- 2025
```

⚠️ Results below were produced on **21 November 2026**: they change as the date changes.

## CWIP examples

**1 · Projects open for 2+ years**

```sql
SELECT anln1, txt50,
       YEAR(CURDATE()) - YEAR(start_date) AS years_open
FROM cwip_assets
WHERE status = 'REL'
  AND YEAR(start_date) <= YEAR(CURDATE()) - 2;
```

| anln1 | txt50 | years_open |
| --- | --- | --- |
| 4000000005 | Solar roof installation | 4 |
| 4000000009 | Data center cooling | 2 |
| 4000000014 | Parking lot expansion | 3 |

**2 · Started this year vs last year**

```sql
SELECT (SELECT COUNT(*) FROM cwip_assets WHERE YEAR(start_date) = YEAR(CURDATE()))     AS started_this_year,   -- 16
       (SELECT COUNT(*) FROM cwip_assets WHERE YEAR(start_date) = YEAR(CURDATE()) - 1) AS started_last_year;   -- 4
```

**3 · Index-friendly "this year" filter**

```sql
SELECT anln1, start_date
FROM cwip_assets
WHERE start_date >= MAKEDATE(YEAR(CURDATE()), 1);      -- from 1 January this year
```

**4 · Reproducible audit work: use a fixed as-at date**

Audit evidence must give the **same result tomorrow**. Store the reporting date in a variable and use it instead of `CURDATE()`:

```sql
SET @audit_date = '2026-12-31';

SELECT anln1, txt50,
       TIMESTAMPDIFF(YEAR, start_date, @audit_date) AS age_years,
       IF(plan_end < @audit_date AND act_end IS NULL, 'Overdue', 'OK') AS schedule
FROM cwip_assets
WHERE status = 'REL';
```

| Use | When |
| --- | --- |
| `CURDATE()` | Live monitoring, dashboards, "as of today" checks |
| `@audit_date` | Audit work papers, period-end testing, anything that must be rerun |

## 🌍 More real-world examples

Tables from my earlier sections (see [README](README.md#real-world-examples)):

```sql
-- Year-to-date revenue
SELECT SUM(netwr) AS ytd_revenue
FROM revenue_lines
WHERE fkdat BETWEEN MAKEDATE(YEAR(CURDATE()), 1) AND CURDATE();

-- Current year vs previous year in one row
SELECT SUM(IF(YEAR(fkdat) = YEAR(CURDATE()),     netwr, 0)) AS current_year,
       SUM(IF(YEAR(fkdat) = YEAR(CURDATE()) - 1, netwr, 0)) AS previous_year
FROM revenue_lines;

-- Open AP invoices overdue as of today
SELECT name1, dmbtr,
       DATEDIFF(CURDATE(), DATE_ADD(bldat, INTERVAL zbd1t DAY)) AS days_overdue
FROM ap_invoices
WHERE status = 'OPEN'
  AND DATE_ADD(bldat, INTERVAL zbd1t DAY) < CURDATE()
ORDER BY days_overdue DESC;
```

## ⚠️ Common mistakes

| Mistake | Fix |
| --- | --- |
| `CURDATE()` in audit evidence | Results change daily: use a fixed `@audit_date` |
| `NOW()` compared with a `DATE` column | Includes the time: use `CURDATE()` for dates |
| `YEAR(CURDATE()) - YEAR(start)` as an exact age | Counts calendar years: use `TIMESTAMPDIFF` |

## 🎯 Key takeaways

1. Current year = **`YEAR(CURDATE())`**; previous year = `YEAR(CURDATE()) - 1`.
2. `CURDATE()` = date only; `NOW()` = date and time.
3. `MAKEDATE(YEAR(CURDATE()), 1)` = 1 January this year: useful for YTD ranges.
4. Results based on today's date **change over time**.
5. For audit work, use a **fixed as-at date** (`SET @audit_date = …`) so results can be reproduced.
