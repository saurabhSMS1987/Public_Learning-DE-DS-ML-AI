# 🔀 IF in MySQL

`IF()` returns one value when a condition is true and another when it is false. Use it to add **flags** and **conditional totals** as calculated columns.

> Part of my learning journey in **Data Engineering, Data Science & AI** · Data: `cwip_assets` ([setup](README.md#setup))

## Syntax

```sql
IF(condition, value_if_true, value_if_false)

IFNULL(column, value_if_null)            -- shortcut for IF(column IS NULL, …, column)
```

## CWIP examples

**1 · Over-budget flag**

```sql
SELECT anln1, txt50, budget, cost_to_date,
       IF(cost_to_date > budget, 'Over budget', 'Within budget') AS budget_flag
FROM cwip_assets;
```

| anln1 | txt50 | budget | cost_to_date | budget_flag |
| --- | --- | --- | --- | --- |
| 4000000001 | New warehouse building | 2500000.00 | 2780000.00 | Over budget |
| 4000000015 | Boiler replacement | 280000.00 | 310500.00 | Over budget |
| … | … | … | … | … |

4 assets are over budget.

**2 · Negative CWIP balance check**

```sql
SELECT anln1, txt50,
       cost_to_date - settled AS cwip_balance,
       IF(cost_to_date - settled < 0, 'NEGATIVE: check settlement', 'OK') AS check_flag
FROM cwip_assets;                       -- 4000000012 Laboratory equipment: -9,000.00
```

**3 · Conditional totals: CWIP balance by status in one row**

```sql
SELECT SUM(IF(status = 'REL',  cost_to_date - settled, 0)) AS in_progress,
       SUM(IF(status = 'TECO', cost_to_date - settled, 0)) AS complete_not_settled,
       SUM(IF(status = 'CLSD', cost_to_date - settled, 0)) AS closed
FROM cwip_assets;
```

| in_progress | complete_not_settled | closed |
| --- | --- | --- |
| 7159150.00 | 2499100.00 | -9000.00 |

**2.5 million is technically complete but still in CWIP**: it should be capitalised and depreciated.

**4 · Possible repairs held in CWIP** (`IF` with `LIKE`)

```sql
SELECT anln1, txt50, cost_to_date,
       IF(txt50 LIKE '%repair%' OR txt50 LIKE '%maintenance%' OR txt50 LIKE '%painting%',
          'Possible expense', 'Capital') AS nature
FROM cwip_assets;                       -- 3 items, 277,950.00 that may need expensing
```

**5 · Replace `NULL` for reporting**

```sql
SELECT anln1, status, IFNULL(act_end, 'Not finished') AS completion
FROM cwip_assets;
```

## 🌍 More real-world examples

Tables from my earlier sections (see [README](README.md#real-world-examples)):

```sql
-- Journal entries: signed amount (debit +, credit -); every document nets to 0
SELECT belnr, buzei, hkont,
       IF(shkzg = 'S', dmbtr, -dmbtr) AS signed_amount
FROM je_lines;

-- Journal entries: weekend posting flag
SELECT belnr, budat,
       IF(DAYOFWEEK(budat) IN (1, 7), 'Weekend', 'Weekday') AS day_type
FROM je_lines;

-- Accounts payable: open vs paid per vendor in one row
SELECT name1,
       SUM(IF(status = 'OPEN',    dmbtr, 0)) AS open_amount,
       SUM(IF(status = 'CLEARED', dmbtr, 0)) AS paid_amount
FROM ap_invoices
GROUP BY name1;
```

## ⚠️ Common mistakes

| Mistake | Fix |
| --- | --- |
| `IF(act_end = NULL, …)` | Never true: use `IF(act_end IS NULL, …)` or `IFNULL` |
| Nesting 3+ `IF`s | Hard to read: use `CASE` |
| Mixing types (`IF(x, 'Over', 0)`) | Return the same type in both branches |
| `IF` in other databases | `IF()` is MySQL-only; `CASE` is standard SQL |

## 🎯 Key takeaways

1. `IF(condition, true_value, false_value)` adds a **two-way** calculated column.
2. `SUM(IF(…, amount, 0))` gives **conditional totals** side by side.
3. `IFNULL(col, value)` replaces `NULL`s for reporting.
4. Test `NULL` with `IS NULL`, never `= NULL`.
5. Use `CASE` for more than two outcomes or for portable SQL.
