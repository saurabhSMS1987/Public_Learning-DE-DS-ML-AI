# 🧭 CASE in MySQL

`CASE` returns a value based on **several conditions**, checked in order. It is standard SQL and the tool for categories, buckets and risk flags.

> Part of my learning journey in **Data Engineering, Data Science & AI** · Data: `cwip_assets` ([setup](README.md#setup))

## Syntax

```sql
-- Searched CASE: any condition (most common)
CASE
    WHEN condition_1 THEN result_1
    WHEN condition_2 THEN result_2
    ELSE default_result
END

-- Simple CASE: compare one column with values
CASE column
    WHEN 'A' THEN result_a
    WHEN 'B' THEN result_b
    ELSE default_result
END
```

The **first** true `WHEN` wins; with no `ELSE`, unmatched rows return `NULL`.

## CWIP examples

Examples use a fixed audit date: `SET @audit_date = '2026-12-31';`

**1 · Simple CASE: status descriptions**

```sql
SELECT anln1, status,
       CASE status
           WHEN 'REL'  THEN 'Released - in progress'
           WHEN 'TECO' THEN 'Technically complete'
           WHEN 'CLSD' THEN 'Closed'
           ELSE 'Unknown'
       END AS status_text
FROM cwip_assets;
```

**2 · CWIP aging buckets** (CASE + `GROUP BY`)

```sql
SELECT CASE
           WHEN TIMESTAMPDIFF(YEAR, start_date, @audit_date) >= 3 THEN '3+ years'
           WHEN TIMESTAMPDIFF(YEAR, start_date, @audit_date) >= 2 THEN '2-3 years'
           WHEN TIMESTAMPDIFF(YEAR, start_date, @audit_date) >= 1 THEN '1-2 years'
           ELSE '< 1 year'
       END                         AS age_bucket,
       COUNT(*)                    AS assets,
       SUM(cost_to_date - settled) AS balance
FROM cwip_assets
WHERE status <> 'CLSD'
GROUP BY age_bucket
ORDER BY MIN(start_date);
```

| age_bucket | assets | balance |
| --- | --- | --- |
| 3+ years | 2 | 526000.00 |
| 2-3 years | 2 | 1346000.00 |
| 1-2 years | 2 | 4020500.00 |
| < 1 year | 13 | 3765750.00 |

Old CWIP is an **impairment** and **capitalisation** risk.

**3 · Budget variance categories**

```sql
SELECT anln1, txt50,
       ROUND((cost_to_date / budget - 1) * 100, 1) AS variance_pct,
       CASE
           WHEN cost_to_date > budget * 1.10 THEN 'High overrun (>10%)'
           WHEN cost_to_date > budget        THEN 'Overrun'
           WHEN cost_to_date = 0             THEN 'No spend'
           ELSE 'Within budget'
       END AS budget_status
FROM cwip_assets;              -- 2 high overruns, 2 overruns, 1 with no spend
```

**4 · Audit flag per asset** (order of `WHEN`s matters)

```sql
SELECT anln1, txt50, status,
       CASE
           WHEN status = 'REL' AND (last_post IS NULL
                OR last_post < DATE_SUB(@audit_date, INTERVAL 12 MONTH)) THEN 'Stale or no postings: impairment review'
           WHEN status = 'TECO' AND settled = 0                          THEN 'Complete, not capitalised'
           WHEN status = 'REL'  AND plan_end < @audit_date               THEN 'Overdue'
           WHEN cost_to_date < settled                                   THEN 'Over-settled'
           ELSE 'OK'
       END AS audit_flag
FROM cwip_assets
HAVING audit_flag <> 'OK'
ORDER BY audit_flag, anln1;
```

| audit_flag | assets |
| --- | --- |
| Complete, not capitalised | 6 |
| Over-settled | 1 |
| Overdue | 3 |
| Stale or no postings: impairment review | 4 |

**5 · Pivot: CWIP by project type and status** (CASE inside `SUM`)

```sql
SELECT proj_type,
       SUM(CASE WHEN status = 'REL'  THEN cost_to_date - settled ELSE 0 END) AS rel_balance,
       SUM(CASE WHEN status = 'TECO' THEN cost_to_date - settled ELSE 0 END) AS teco_balance,
       SUM(cost_to_date - settled)                                          AS total_balance
FROM cwip_assets
GROUP BY proj_type
ORDER BY total_balance DESC;          -- Machinery: 2,369,350.00 complete but not settled
```

**6 · Custom sort order**

```sql
SELECT anln1, status
FROM cwip_assets
ORDER BY CASE status WHEN 'TECO' THEN 1 WHEN 'REL' THEN 2 ELSE 3 END, anln1;   -- TECO first
```

## 🌍 More real-world examples

Tables from my earlier sections (see [README](README.md#real-world-examples)):

```sql
-- AP aging buckets at year-end (due date = invoice date + payment days)
SELECT belnr, name1, dmbtr,
       CASE
           WHEN DATEDIFF('2026-12-31', DATE_ADD(bldat, INTERVAL zbd1t DAY)) <= 0  THEN 'Not due'
           WHEN DATEDIFF('2026-12-31', DATE_ADD(bldat, INTERVAL zbd1t DAY)) <= 30 THEN '1-30 days'
           WHEN DATEDIFF('2026-12-31', DATE_ADD(bldat, INTERVAL zbd1t DAY)) <= 60 THEN '31-60 days'
           ELSE '60+ days'
       END AS aging_bucket
FROM ap_invoices
WHERE status = 'OPEN';

-- Monetary-unit sampling strata
SELECT CASE
           WHEN dmbtr >= 50000 THEN 'A: >= 50k'
           WHEN dmbtr >= 10000 THEN 'B: 10k-50k'
           ELSE 'C: < 10k'
       END AS stratum,
       COUNT(*) AS items, SUM(dmbtr) AS value
FROM ap_invoices
GROUP BY stratum
ORDER BY stratum;

-- Map G/L accounts to financial statement lines
SELECT CASE
           WHEN hkont < '0000200000' THEN 'Assets'
           WHEN hkont < '0000300000' THEN 'Liabilities'
           WHEN hkont < '0000400000' THEN 'Equity'
           WHEN hkont < '0000500000' THEN 'Revenue'
           ELSE 'Expenses'
       END AS fs_line,
       SUM(closing) AS balance
FROM trial_balance
GROUP BY fs_line;

-- Journal entry risk score: one point per risk indicator
SELECT belnr, usnam, dmbtr,
         CASE WHEN blart = 'SA'                 THEN 1 ELSE 0 END    -- manual entry
       + CASE WHEN DAYOFWEEK(budat) IN (1, 7)   THEN 1 ELSE 0 END    -- weekend
       + CASE WHEN budat >= '2026-12-24'        THEN 1 ELSE 0 END    -- year-end
       + CASE WHEN MOD(dmbtr, 1000) = 0         THEN 1 ELSE 0 END    -- round amount
         AS risk_score
FROM je_lines
WHERE shkzg = 'S'
ORDER BY risk_score DESC, dmbtr DESC;
```

## ⚠️ Common mistakes

| Mistake | Fix |
| --- | --- |
| Broad `WHEN` before narrow (`> budget` before `> budget * 1.10`) | Put the most specific condition first |
| No `ELSE` | Unmatched rows become `NULL`: add `ELSE` |
| Forgetting `END` | `Error 1064`: every `CASE` needs `END` |
| `CASE status WHEN NULL …` | Never matches: use `CASE WHEN status IS NULL …` |

## 🎯 Key takeaways

1. `CASE` handles **many outcomes**; the first true `WHEN` wins.
2. **Searched CASE** for any condition; **simple CASE** to map one column's values.
3. Always add `ELSE`, and order `WHEN`s from **most to least specific**.
4. Works in `SELECT`, `WHERE`, `GROUP BY`, `ORDER BY` and inside `SUM`/`COUNT` (pivots).
5. Audit uses: aging buckets, materiality strata, FS mapping, risk flags and scores.
