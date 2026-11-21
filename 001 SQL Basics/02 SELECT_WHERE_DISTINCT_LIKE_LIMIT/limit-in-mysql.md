# ✂️ LIMIT in MySQL

`LIMIT` caps the number of rows returned. Used with `ORDER BY`, it answers **"top N"** questions and lets you page through or preview large tables.

> Part of my learning journey in **Data Engineering, Data Science & AI** · Data: `je_lines` ([setup](README.md#setup))

## Syntax

```sql
SELECT columns
FROM table_name
ORDER BY column DESC          -- sort first (ASC = smallest first, default)
LIMIT row_count OFFSET skip;  -- then cut
```

## Examples

**1 · Preview a large table**

```sql
SELECT * FROM je_lines LIMIT 10;
```

A quick look at the columns and formats before writing a real query.

**2 · Top 5 largest debit lines**

```sql
SELECT belnr, usnam, dmbtr
FROM je_lines
WHERE shkzg = 'S'
ORDER BY dmbtr DESC, belnr
LIMIT 5;
```

| belnr | usnam | dmbtr |
| --- | --- | --- |
| 0100000009 | CFO_ADMIN | 250000.00 |
| 0100000010 | CFO_ADMIN | 250000.00 |
| 0100000008 | BATCH_FI | 180000.00 |
| 0100000011 | CFO_ADMIN | 100000.00 |
| 0100000001 | JSMITH | 80000.00 |

The second sort column (`belnr`) breaks ties, so the result is the same every run.

**3 · The next 5 (paging)**

```sql
SELECT belnr, budat, dmbtr
FROM je_lines
WHERE shkzg = 'S'
ORDER BY dmbtr DESC, belnr
LIMIT 5 OFFSET 5;             -- same as LIMIT 5, 5  (skip, count)
```

**4 · Latest postings**

```sql
SELECT belnr, budat, usnam
FROM je_lines
WHERE shkzg = 'S'
ORDER BY budat DESC, belnr
LIMIT 3;                      -- year-end entries of 2026-12-31
```

## 🧪 Try it

1. The 3 smallest debit lines → 87.20, 125.40, 7,250.00.
2. The earliest debit posting of the year → `1800000001` on 2026-01-15.
3. Rows 11–20 of `je_lines` ordered by `belnr, buzei`.

## ⚠️ Common mistakes

| Mistake | Problem | Fix |
| --- | --- | --- |
| `LIMIT` without `ORDER BY` | Which rows you get isn't guaranteed | Always sort for top-N |
| Ties at the cut-off | Equal values may swap between runs | Add a tie-breaker column (`belnr`) |
| `LIMIT 5, 10` read as "rows 5–10" | It means skip 5, return 10 | Prefer `LIMIT 10 OFFSET 5` |
| Exported only 1,000 rows | Workbench adds `LIMIT 1000` by default | **Query → Limit Rows → Don't Limit** |

## 🎯 Key takeaways

1. `LIMIT n` returns at most `n` rows; it is applied **last**.
2. Pair it with **`ORDER BY`** (`DESC` for largest first) for top-N lists.
3. Add a **tie-breaker** column for a stable result.
4. `OFFSET` skips rows for paging.
5. Use `LIMIT` to preview, not to define an audit population.
