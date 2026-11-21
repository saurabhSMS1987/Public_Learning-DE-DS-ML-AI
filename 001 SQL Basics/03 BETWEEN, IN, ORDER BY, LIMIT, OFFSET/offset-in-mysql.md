# ⏭️ OFFSET in MySQL

`OFFSET` skips a number of rows before `LIMIT` starts counting. Use it to **page** through results or pick the **Nth** row.

> Part of my learning journey in **Data Engineering, Data Science & AI** · Data: `ap_invoices` ([setup](README.md#setup))

## Syntax

```sql
SELECT columns
FROM table_name
ORDER BY column, tie_breaker
LIMIT row_count OFFSET rows_to_skip;

-- short form: LIMIT rows_to_skip, row_count   (note the reversed order)
```

**Page formula:** `OFFSET = (page_number - 1) × page_size`

| Page (size 10) | Clause | Rows |
| --- | --- | --- |
| 1 | `LIMIT 10 OFFSET 0` | 1–10 |
| 2 | `LIMIT 10 OFFSET 10` | 11–20 |
| 3 | `LIMIT 10 OFFSET 20` | 21–26 |

## Examples

**1 · Page through invoices, largest first**

```sql
SELECT belnr, name1, dmbtr
FROM ap_invoices
ORDER BY dmbtr DESC, belnr
LIMIT 10 OFFSET 10;               -- page 2: 18,400.00 down to 5,862.14
```

Page 3 (`OFFSET 20`) returns only **6 rows**: the table has 26.

**2 · The 2nd largest invoice**

```sql
SELECT belnr, name1, dmbtr
FROM ap_invoices
ORDER BY dmbtr DESC, belnr
LIMIT 1 OFFSET 1;                 -- 1900000006, IT Consulting Partners, 75,000.00
```

`OFFSET n - 1` gives the Nth row.

**3 · Short form**

```sql
SELECT belnr, name1, dmbtr
FROM ap_invoices
ORDER BY dmbtr DESC, belnr
LIMIT 10, 10;                     -- same as LIMIT 10 OFFSET 10
```

## 🧪 Try it

1. The 3rd largest invoice → Müller GmbH, 54,300.00.
2. Page 2 with a page size of 5, largest first → 48,750.50 down to 21,980.75.
3. The 2nd smallest invoice → 2,400.00.

## ⚠️ Common mistakes

| Mistake | Problem | Fix |
| --- | --- | --- |
| `OFFSET` without `ORDER BY` | Pages overlap or skip rows | Always sort, with a tie-breaker |
| `LIMIT 10, 20` read as "rows 10–20" | Means skip 10, return 20 | Prefer `LIMIT 20 OFFSET 10` |
| `OFFSET 1` for the 1st row | Skips the first row | Nth row = `OFFSET N - 1` |
| `OFFSET` without `LIMIT` | Syntax error in MySQL | Always pair with `LIMIT` |
| Huge offsets (`OFFSET 1000000`) | MySQL still reads all skipped rows: slow | Filter with `WHERE` on a key instead |

## 🎯 Key takeaways

1. `OFFSET m` skips `m` rows; `LIMIT n` then returns the next `n`.
2. Paging: `OFFSET = (page - 1) × page_size`.
3. Nth largest: `ORDER BY … DESC LIMIT 1 OFFSET N-1`.
4. Needs a **stable `ORDER BY`** with a tie-breaker, or pages overlap.
5. `LIMIT a, b` = skip `a`, return `b`.
