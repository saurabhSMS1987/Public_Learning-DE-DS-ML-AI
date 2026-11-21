# ✂️ LIMIT in MySQL

`LIMIT` returns at most a set number of rows. With `ORDER BY`, it answers **top-N** and **bottom-N** questions.

> Part of my learning journey in **Data Engineering, Data Science & AI** · Data: `ap_invoices` ([setup](README.md#setup))

## Syntax

```sql
SELECT columns
FROM table_name
ORDER BY column DESC
LIMIT n;                          -- always the last clause
```

## Examples

**1 · Top 5 invoices by amount**

```sql
SELECT belnr, name1, dmbtr
FROM ap_invoices
ORDER BY dmbtr DESC
LIMIT 5;
```

| belnr | name1 | dmbtr |
| --- | --- | --- |
| 1900000005 | IT Consulting Partners | 100000.00 |
| 1900000006 | IT Consulting Partners | 75000.00 |
| 5100000013 | Müller GmbH | 54300.00 |
| 5100000004 | Steel Supply Co | 49990.00 |
| 5100000003 | Steel Supply Co | 49950.00 |

**2 · Top 3 open invoices** (filter, then sort, then cut)

```sql
SELECT belnr, name1, dmbtr
FROM ap_invoices
WHERE status = 'OPEN'
ORDER BY dmbtr DESC
LIMIT 3;                          -- 75,000.00 / 54,300.00 / 49,990.00
```

**3 · Bottom 3** (smallest first)

```sql
SELECT belnr, name1, dmbtr
FROM ap_invoices
ORDER BY dmbtr ASC, belnr
LIMIT 3;                          -- 320.45 credit memo, then 2,400.00 × 2
```

**4 · Preview a table**

```sql
SELECT * FROM ap_invoices LIMIT 5;
```

## 🧪 Try it

1. The 3 largest **cleared** invoices → 100,000.00 / 48,750.50 / 42,315.60.
2. The single invoice with the longest payment terms (`zbd1t`), largest amount first → Müller GmbH 54,300.00.
3. The 5 smallest invoices.

## ⚠️ Common mistakes

| Mistake | Problem | Fix |
| --- | --- | --- |
| `LIMIT` without `ORDER BY` | "Top 5" becomes "any 5" | Sort first |
| `LIMIT 5` before `ORDER BY` | Syntax error: `LIMIT` must come last | `… ORDER BY … LIMIT 5` |
| Tie at the cut-off (e.g. 2,400.00 × 3) | Which tied row appears can vary | Add a tie-breaker: `ORDER BY dmbtr, belnr` |
| Using `LIMIT` for an audit population | Silently drops rows | Use `WHERE` to define populations |

## 🎯 Key takeaways

1. `LIMIT n` returns **at most** `n` rows.
2. It is applied **last**: after `WHERE` and `ORDER BY`.
3. `ORDER BY … DESC LIMIT n` = top N; `ASC` = bottom N.
4. Add a **tie-breaker** column for a stable result.
5. Great for previews and top-N lists, never for full populations.
