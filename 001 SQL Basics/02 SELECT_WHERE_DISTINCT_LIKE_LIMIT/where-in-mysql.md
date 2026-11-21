# 🎯 WHERE in MySQL

`WHERE` filters rows, so only those meeting a condition are returned. In audit work it defines the **population** you test.

> Part of my learning journey in **Data Engineering, Data Science & AI** · Data: `je_lines` ([setup](README.md#setup))

## Syntax

```sql
SELECT columns
FROM table_name
WHERE condition;
```

| Operator | Meaning | Example |
| --- | --- | --- |
| `=` `<>` `>` `>=` `<` `<=` | Compare | `dmbtr >= 100000` |
| `AND` / `OR` / `NOT` | Combine | `blart = 'SA' AND shkzg = 'S'` |
| `IN (…)` | Any value in a list | `usnam IN ('CFO_ADMIN', 'TEST_USER')` |
| `BETWEEN … AND …` | Range, both ends included | `budat BETWEEN '2026-12-01' AND '2026-12-31'` |
| `IS NULL` / `IS NOT NULL` | Missing value | `sgtxt IS NULL` |

## Examples

**1 · Year-end manual entries** (document type `SA`, debit lines)

```sql
SELECT belnr, budat, usnam, dmbtr
FROM je_lines
WHERE budat = '2026-12-31'
  AND blart = 'SA'
  AND shkzg = 'S';
```

| belnr | budat | usnam | dmbtr |
| --- | --- | --- | --- |
| 0100000007 | 2026-12-31 | MGARCIA | 12000.00 |
| 0100000009 | 2026-12-31 | CFO_ADMIN | 250000.00 |
| 0100000010 | 2026-12-31 | CFO_ADMIN | 250000.00 |
| 0100000011 | 2026-12-31 | CFO_ADMIN | 100000.00 |

**2 · December postings** (date range)

```sql
SELECT * FROM je_lines
WHERE budat BETWEEN '2026-12-01' AND '2026-12-31';      -- 12 lines
```

**3 · Weekend postings**

```sql
SELECT belnr, budat, usnam
FROM je_lines
WHERE DAYOFWEEK(budat) IN (1, 7)      -- 1 = Sunday, 7 = Saturday
  AND shkzg = 'S';                    -- 5 documents
```

**4 · Large manual entries or entries by a test user** (brackets matter)

```sql
SELECT belnr, usnam, dmbtr
FROM je_lines
WHERE shkzg = 'S'
  AND blart = 'SA'
  AND (dmbtr >= 100000 OR usnam = 'TEST_USER');         -- 4 documents
```

Without brackets, `AND` is evaluated before `OR`, and the result changes.

**5 · Lines with no text** (audit trail gap)

```sql
SELECT belnr, buzei, usnam, dmbtr
FROM je_lines
WHERE sgtxt IS NULL OR sgtxt = '';    -- 0100000011, CFO_ADMIN, 100000.00
```

Imports can store a blank as `NULL` or as an empty string `''`, so check both.

## 🧪 Try it

1. Lines posted to revenue account `'0000400000'` → 4 lines.
2. Vendor invoices (`blart = 'RE'`) in September → 4 lines.
3. Lines posted by anyone except batch users (`usnam NOT IN ('BATCH_SD', 'BATCH_MM', 'BATCH_FI')`) → 30 lines.

## ⚠️ Common mistakes

| Mistake | Problem | Fix |
| --- | --- | --- |
| `hkont = 400000` | Number vs text: also matches `'400000'` and can't use an index | `hkont = '0000400000'` |
| `sgtxt = NULL` | Never true | `sgtxt IS NULL` |
| `a AND b OR c` | `AND` runs first | Add brackets: `a AND (b OR c)` |
| `budat = '31.12.2026'` | Not a MySQL date | `'2026-12-31'` |

## 🎯 Key takeaways

1. `WHERE` filters rows before they are returned.
2. Text and dates go in **quotes**; dates as `'YYYY-MM-DD'`.
3. Use **`IN`** for lists and **`BETWEEN`** for ranges (both ends included).
4. **Brackets** control `AND` / `OR` order.
5. `NULL` needs **`IS NULL`**, never `= NULL`.
