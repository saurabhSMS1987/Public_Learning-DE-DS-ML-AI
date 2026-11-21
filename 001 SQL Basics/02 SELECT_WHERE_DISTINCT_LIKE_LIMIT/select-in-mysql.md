# 🔎 SELECT in MySQL

`SELECT` reads data from a table. It is the starting point of every query.

> Part of my learning journey in **Data Engineering, Data Science & AI** · Data: `je_lines` ([setup](README.md#setup))

## Syntax

```sql
SELECT column1, column2, expression AS alias
FROM table_name;
```

## Examples

**1 · All columns**

```sql
SELECT * FROM je_lines;          -- 41 rows, 13 columns
```

**2 · Only the columns you need**

```sql
SELECT belnr, buzei, budat, hkont, shkzg, dmbtr
FROM je_lines;
```

| belnr | buzei | budat | hkont | shkzg | dmbtr |
| --- | --- | --- | --- | --- | --- |
| 0100000001 | 1 | 2026-01-31 | 0000600000 | S | 80000.00 |
| 0100000001 | 2 | 2026-01-31 | 0000100000 | H | 80000.00 |

**3 · Rename columns with `AS`**

SAP field names are cryptic; aliases make results readable for the audit team.

```sql
SELECT belnr AS document_no,
       budat AS posting_date,
       usnam AS posted_by,
       dmbtr AS amount
FROM je_lines;
```

**4 · Calculated columns**

```sql
SELECT belnr,
       dmbtr / 1000                AS amount_k,      -- amount in thousands
       CONCAT(belnr, '-', buzei)   AS line_id,       -- unique line reference
       YEAR(budat)                 AS posting_year
FROM je_lines;
```

| belnr | amount_k | line_id | posting_year |
| --- | --- | --- | --- |
| 0100000001 | 80.000000 | 0100000001-1 | 2026 |

## 🧪 Try it

1. List document number, user and transaction code for every line.
2. Show `dmbtr` as `amount` and `shkzg` as `debit_credit`.
3. Add a column `line_id` combining `bukrs`, `belnr` and `gjahr` (e.g. `1000-0100000001-2026`).

## ⚠️ Common mistakes

| Mistake | Fix |
| --- | --- |
| `SELECT *` on a 5-million-row table | Name the columns you need |
| Comma after the last column (`dmbtr, FROM`) | Remove it |
| Alias with spaces: `AS posted by` | Use `posted_by` or backticks: `` AS `posted by` `` |
| `Error 1054: Unknown column` | Check spelling with `DESCRIBE je_lines;` |

## 🎯 Key takeaways

1. `SELECT … FROM …` is the minimum query.
2. Prefer named columns to `SELECT *`: faster and clearer.
3. `AS` renames columns for readable output.
4. `SELECT` can calculate (`dmbtr / 1000`), join text (`CONCAT`) and apply functions (`YEAR`).
5. `SELECT` only reads; it never changes the table.
