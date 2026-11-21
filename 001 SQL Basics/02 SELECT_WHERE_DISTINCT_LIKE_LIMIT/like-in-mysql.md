# 🔤 LIKE in MySQL

`LIKE` filters text by **pattern** instead of an exact value. Ideal for searching posting texts, user names and number ranges.

> Part of my learning journey in **Data Engineering, Data Science & AI** · Data: `je_lines` ([setup](README.md#setup))

## Syntax

```sql
SELECT columns
FROM table_name
WHERE column LIKE 'pattern';
```

| Wildcard | Matches | Example | Finds |
| --- | --- | --- | --- |
| `%` | Any number of characters (incl. none) | `'%reversal%'` | "Reversal of 0100000009" |
| `_` | Exactly one character | `'00006_0000'` | `0000600000`, `0000610000`, … |

## Examples

**1 · Keyword in the posting text**

```sql
SELECT belnr, budat, usnam, sgtxt
FROM je_lines
WHERE sgtxt LIKE '%reversal%';           -- 0100000010, CFO_ADMIN
```

Matching is **case-insensitive** by default: `'%reversal%'` finds `Reversal`.

**2 · Red-flag words**

```sql
SELECT belnr, usnam, sgtxt
FROM je_lines
WHERE sgtxt LIKE '%test%'
   OR sgtxt LIKE '%adj%';                -- test posting, manual and inventory adjustments
```

**3 · Document number range** (starts with)

```sql
SELECT DISTINCT belnr, blart
FROM je_lines
WHERE belnr LIKE '51%';                  -- vendor invoices 5100000001 to 5100000003
```

**4 · Account pattern** (exact length with `_`)

```sql
SELECT hkont, dmbtr
FROM je_lines
WHERE hkont LIKE '00006_0000';           -- expense accounts 0000600000 to 0000690000
```

**5 · Search for a literal `_` or `%`**

`_` is a wildcard, so `'BATCH_%'` would also match `BATCHX`. Escape it with `\`:

```sql
SELECT DISTINCT usnam
FROM je_lines
WHERE usnam LIKE 'BATCH\_%';             -- BATCH_FI, BATCH_MM, BATCH_SD
```

**6 · Exclude a pattern**

```sql
SELECT COUNT(*) FROM je_lines
WHERE sgtxt NOT LIKE '%payroll%';        -- 39 of 41 lines
```

## 🧪 Try it

1. Lines whose text starts with `Vendor inv` → 3.
2. Lines for customer `Acme Retail` anywhere in the text → 4.
3. Lines whose text mentions `Müller` (try `'%MÜLLER%'`) → 2.

## ⚠️ Common mistakes

| Mistake | Problem | Fix |
| --- | --- | --- |
| `LIKE 'reversal'` | No wildcard: exact match only | `'%reversal%'` |
| `LIKE 'BATCH_%'` | `_` matches any character | `'BATCH\_%'` |
| `NOT LIKE` to find blank texts | `NULL` never matches `LIKE` or `NOT LIKE` | Add `OR sgtxt IS NULL` |
| `LIKE '%…'` on huge tables | Leading `%` scans every row | Use `'text%'` when possible |

## 🎯 Key takeaways

1. `%` = any number of characters; `_` = exactly one.
2. `'abc%'` starts with, `'%abc'` ends with, `'%abc%'` contains.
3. `LIKE` is case-insensitive with MySQL's default settings.
4. Escape literal `_` or `%` with `\`.
5. `NULL` is never matched; handle it with `IS NULL`.
