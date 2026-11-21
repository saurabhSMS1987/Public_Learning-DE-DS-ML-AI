# 📅 Date Functions in MySQL

Convert, split, shift and compare dates and times. Journal entry testing relies on them: entries **keyed in after year-end**, **out of hours** or **weekend** postings, and **backdated** documents.

> Part of my learning journey in **Data Engineering, Data Science & AI** · Data: `journal_entries` ([setup](README.md#setup))

## Functions

| Group | Function | Example → Result |
| --- | --- | --- |
| Today | `CURDATE()` / `NOW()` | `2026-11-21` / `2026-11-21 15:22:04` |
| Parts | `YEAR()` `QUARTER()` `MONTH()` `DAY()` `WEEK()` | `QUARTER('2026-02-24')` → `1` |
| | `HOUR()` `DATE()` `TIME()` | `HOUR('2027-01-08 23:47:10')` → `23` |
| Names | `DAYNAME()` / `MONTHNAME()` / `DAYOFWEEK()` | `DAYNAME('2026-11-28')` → `Saturday` (`DAYOFWEEK` 1 = Sunday … 7 = Saturday) |
| Shift | `DATE_ADD(d, INTERVAL n unit)` / `DATE_SUB(…)` | `DATE_ADD('2026-02-10', INTERVAL 30 DAY)` → `2026-03-12` |
| Difference | `DATEDIFF(a, b)` | `DATEDIFF('2026-12-31', '2026-12-01')` → `30` (days) |
| | `TIMESTAMPDIFF(unit, a, b)` | `TIMESTAMPDIFF(MONTH, '2026-01-15', '2026-12-31')` → `11` |
| Month end | `LAST_DAY(d)` | `LAST_DAY('2026-02-24')` → `2026-02-28` |
| Build | `MAKEDATE(year, day_of_year)` | `MAKEDATE(2026, 1)` → `2026-01-01` |
| Text → date | `STR_TO_DATE(s, format)` | `STR_TO_DATE('20261231', '%Y%m%d')` → `2026-12-31` |
| Date → text | `DATE_FORMAT(d, format)` | `DATE_FORMAT('2027-01-08 23:47:10', '%d.%m.%Y %H:%i')` → `08.01.2027 23:47` |

Common format codes: `%Y` year · `%m` month · `%d` day · `%H` hour · `%i` minute · `%s` second · `%W` weekday name · `%M` month name.

## Examples

**1 · Convert the raw SAP document date (YYYYMMDD) and find backdated documents**

```sql
SELECT DISTINCT belnr, bldat,
       STR_TO_DATE(bldat, '%Y%m%d')                    AS document_date,
       budat                                           AS posting_date,
       DATEDIFF(budat, STR_TO_DATE(bldat, '%Y%m%d'))   AS days_to_post
FROM journal_entries
WHERE DATEDIFF(budat, STR_TO_DATE(bldat, '%Y%m%d')) > 14;
```

| belnr | bldat | document_date | posting_date | days_to_post |
| --- | --- | --- | --- | --- |
| 1900000002 | 20260205 | 2026-02-05 | 2026-02-24 | 19 |
| 1900000003 | 20251215 | 2025-12-15 | 2026-01-12 | 28 |

`1900000003` is a December 2025 invoice booked in 2026: a **cut-off** item. `1900000002` is the duplicate invoice, posted 19 days after the original.

**2 · Entries keyed in after the period they were posted to**

```sql
SELECT DISTINCT belnr, budat, cpudt,
       DATEDIFF(DATE(cpudt), budat) AS days_after_posting_date,
       usnam
FROM journal_entries
WHERE DATE(cpudt) > LAST_DAY(budat);
```

| belnr | budat | cpudt | days_after_posting_date | usnam |
| --- | --- | --- | --- | --- |
| 0100000005 | 2026-12-31 | 2027-01-08 23:47:10 | 8 | CFO_ADMIN |
| 0100000006 | 2026-12-31 | 2027-01-09 08:05:31 | 9 | CFO_ADMIN |

**Post-closing entries** dated 31 December but keyed in January: classic management-override risk.

**3 · Out-of-hours and weekend entries**

```sql
SELECT DISTINCT belnr, cpudt, DAYNAME(cpudt) AS weekday, HOUR(cpudt) AS hour, usnam
FROM journal_entries
WHERE HOUR(cpudt) NOT BETWEEN 7 AND 19          -- before 07:00 or after 19:59
   OR DAYOFWEEK(cpudt) IN (1, 7);               -- Sunday, Saturday
-- 0100000003 Sat 02:13 Test_User · 0100000005 Fri 23:47 CFO_ADMIN · 0100000006 Sat 08:05 CFO_ADMIN
```

**4 · Monthly totals with a readable label**

```sql
SELECT DATE_FORMAT(budat, '%Y-%m') AS period_ym,
       COUNT(DISTINCT belnr)       AS documents,
       SUM(GREATEST(hsl, 0))       AS debits
FROM journal_entries
GROUP BY period_ym
ORDER BY period_ym;                   -- December: 3 documents, 90,000.00
```

**5 · Due dates and other date arithmetic**

```sql
SELECT DISTINCT belnr,
       STR_TO_DATE(bldat, '%Y%m%d')                              AS document_date,
       DATE_ADD(STR_TO_DATE(bldat, '%Y%m%d'), INTERVAL 30 DAY)   AS due_date_net30
FROM journal_entries
WHERE blart = 'KR';

SELECT DATE_ADD('2026-01-31', INTERVAL 1 MONTH)                          AS one_month_later,  -- 2026-02-28
       DATE_SUB('2026-12-31', INTERVAL 1 MONTH)                          AS one_month_before, -- 2026-11-30
       TIMESTAMPDIFF(HOUR, '2026-12-31 00:00:00', '2027-01-08 23:47:10') AS hours_late;       -- 215
```

## 🌍 More real-world examples

Tables from my earlier sections (see [README](README.md#real-world-examples)):

```sql
-- AP: due date and days overdue at year-end for open invoices
SELECT belnr, bldat, zbd1t,
       DATE_ADD(bldat, INTERVAL zbd1t DAY)                       AS due_date,
       DATEDIFF('2026-12-31', DATE_ADD(bldat, INTERVAL zbd1t DAY)) AS days_overdue
FROM ap_invoices
WHERE status = 'OPEN';

-- Revenue: monthly totals, latest first
SELECT DATE_FORMAT(fkdat, '%Y-%m') AS period_ym, SUM(netwr) AS revenue
FROM revenue_lines
GROUP BY period_ym
ORDER BY period_ym DESC;

-- OpEx: postings dated on a weekend
SELECT doc_no, posting_date, DAYNAME(posting_date) AS weekday
FROM opex_postings
WHERE DAYOFWEEK(posting_date) IN (1, 7);
```

## ⚠️ Common mistakes

| Mistake | Fix |
| --- | --- |
| Comparing text dates (`'05.02.2026' < '31.01.2026'`) | Convert with `STR_TO_DATE` first |
| Wrong format code (`%M` is the month **name**, `%m` the number) | Check codes: `%Y%m%d` for `20261231` |
| `DATEDIFF` on datetimes expecting hours | It returns days: use `TIMESTAMPDIFF(HOUR, …)` |
| Comparing `DATETIME` with a date-only `BETWEEN` end | `'2026-12-31'` means 00:00: use `< '2027-01-01'` or `DATE()` |
| Expecting `DAYOFWEEK` 1 = Monday | 1 = **Sunday**, 7 = Saturday |
| Alias named `year_month` | `Error 1064`: it is a reserved word (like `lines`); use `period_ym` |

## 🎯 Key takeaways

1. `STR_TO_DATE` turns SAP text dates (`20261231`, `31.12.2026`) into real dates; `DATE_FORMAT` does the reverse.
2. `YEAR`, `MONTH`, `HOUR`, `DAYNAME`, `DAYOFWEEK` extract parts for grouping and flags.
3. `DATE_ADD`/`DATE_SUB` shift dates; `DATEDIFF` (days) and `TIMESTAMPDIFF` (any unit) measure gaps.
4. Compare **posting date**, **document date** and **entry timestamp**: the gaps reveal backdating and post-closing entries.
5. Audit uses: cut-off, post-closing entries, out-of-hours and weekend entries, aging.
