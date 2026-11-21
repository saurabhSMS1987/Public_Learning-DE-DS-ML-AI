# 🔤 Text Functions in MySQL

Clean, combine, cut and search text: vendor names, references, user IDs and posting texts. In audit data, text functions are what make **"ACME Supplies Ltd"**, **"Acme Supplies Ltd."** and **" acme supplies ltd "** compare as the same vendor.

> Part of my learning journey in **Data Engineering, Data Science & AI** · Data: `journal_entries` ([setup](README.md#setup))

## Functions

| Group | Function | Example → Result |
| --- | --- | --- |
| Combine | `CONCAT(a, b, …)` | `CONCAT('INV', '-', 45)` → `INV-45` |
| | `CONCAT_WS(sep, a, b, …)` | `CONCAT_WS('-', '1000', '0100000001', 2026)` → `1000-0100000001-2026` |
| Case | `UPPER(s)` / `LOWER(s)` | `UPPER('acme')` → `ACME` |
| Spaces | `TRIM(s)` / `LTRIM(s)` / `RTRIM(s)` | `TRIM('  acme ')` → `acme` |
| Length | `CHAR_LENGTH(s)` / `LENGTH(s)` | `'Müller'` → `6` characters / `7` bytes |
| Cut | `LEFT(s, n)` / `RIGHT(s, n)` | `RIGHT('0000640000', 6)` → `640000` |
| | `SUBSTRING(s, start, len)` | `SUBSTRING('INV-2026-0045', 5, 4)` → `2026` |
| | `SUBSTRING_INDEX(s, delim, n)` | `SUBSTRING_INDEX('INV-2026-0045', '-', -1)` → `0045` |
| Replace | `REPLACE(s, from, to)` | `REPLACE('Acme Ltd.', '.', '')` → `Acme Ltd` |
| | `REGEXP_REPLACE(s, pattern, to)` | `REGEXP_REPLACE('inv 2026 45', '[^0-9]', '')` → `202645` |
| Pad | `LPAD(s, n, c)` / `RPAD(s, n, c)` | `LPAD('100023', 10, '0')` → `0000100023` |
| Find | `INSTR(s, sub)` / `LOCATE(sub, s)` | `INSTR('Adjust revenue per CFO', 'CFO')` → `20` |
| Reverse | `REVERSE(s)` | `REVERSE('abc')` → `cba` |

## Examples

**1 · Normalise vendor names and numbers**

```sql
SELECT DISTINCT vendor_name,
       UPPER(TRIM(REPLACE(vendor_name, '.', ''))) AS name_key,     -- one spelling
       lifnr,
       LPAD(lifnr, 10, '0')                       AS lifnr_10      -- restore leading zeros
FROM journal_entries
WHERE vendor_name IS NOT NULL;
```

| vendor_name | name_key | lifnr | lifnr_10 |
| --- | --- | --- | --- |
| ACME Supplies Ltd | ACME SUPPLIES LTD | 0000100023 | 0000100023 |
| Acme Supplies Ltd. | ACME SUPPLIES LTD | 100023 | 0000100023 |
| ␣acme supplies ltd␣ | ACME SUPPLIES LTD | 0000100087 | 0000100087 |
| … | … | … | … |

**2 · Duplicate vendor master records** (same cleaned name, different numbers)

```sql
SELECT UPPER(TRIM(REPLACE(vendor_name, '.', ''))) AS name_key,
       COUNT(DISTINCT LPAD(lifnr, 10, '0'))       AS vendor_numbers
FROM journal_entries
WHERE vendor_name IS NOT NULL
GROUP BY name_key
HAVING COUNT(DISTINCT LPAD(lifnr, 10, '0')) > 1;     -- ACME SUPPLIES LTD: 2 vendor numbers
```

**3 · Duplicate invoices with differently typed references**

`INV-2026-0045` and `inv 2026 45` are the same invoice. Keep the last group of digits and compare as a number:

```sql
SELECT LPAD(lifnr, 10, '0')                          AS vendor,
       CAST(SUBSTRING_INDEX(REGEXP_REPLACE(xblnr, '[^0-9]+', ' '), ' ', -1) AS UNSIGNED) AS invoice_no,
       ABS(hsl)                                      AS amount,
       COUNT(DISTINCT belnr)                         AS documents
FROM journal_entries
WHERE blart = 'KR' AND racct = '0000200000'          -- vendor invoice lines
GROUP BY vendor, invoice_no, amount
HAVING COUNT(DISTINCT belnr) > 1;                    -- 0000100023 · 45 · 12,450.00 · 2 documents
```

**4 · Red-flag words in posting texts**

```sql
SELECT DISTINCT belnr, usnam, sgtxt
FROM journal_entries
WHERE LOWER(sgtxt) LIKE '%adjust%'
   OR LOWER(sgtxt) LIKE '%test%'
   OR INSTR(LOWER(sgtxt), 'per cfo') > 0;
-- 0100000003 Test_User "TEST posting - pls ignore" · 0100000005 CFO_ADMIN "Adjust revenue per CFO"
```

**5 · Tidy text and build keys**

```sql
SELECT DISTINCT
       CONCAT('[', sgtxt, ']')                                          AS raw_text,     -- shows the spaces
       CONCAT(UPPER(LEFT(TRIM(sgtxt), 1)), LOWER(SUBSTRING(TRIM(sgtxt), 2))) AS clean_text,
       CONCAT_WS('-', rbukrs, belnr, gjahr)                             AS document_key
FROM journal_entries
WHERE belnr = '1900000002';
-- [  consulting FEES feb  ] → Consulting fees feb · 1000-1900000002-2026
```

### ⚠️ Case and spaces in comparisons

```sql
SELECT 'ACME' = 'acme'          AS different_case,     -- 1: equal (default collation ignores case)
       'Acme Ltd' = 'Acme Ltd.' AS with_dot,           -- 0
       'acme ' = 'acme'         AS trailing_space,     -- 0
       ' acme' = 'acme'         AS leading_space;      -- 0

SELECT COUNT(DISTINCT usnam)        AS users_ignoring_case,   -- 6
       COUNT(DISTINCT BINARY usnam) AS users_exact            -- 7: 'ap_clerk1' ≠ 'AP_CLERK1'
FROM journal_entries;
```

Case usually doesn't matter in MySQL, but **spaces and punctuation do**: `TRIM` and `REPLACE` before comparing.

## 🌍 More real-world examples

Tables from my earlier sections (see [README](README.md#real-world-examples)):

```sql
-- AP: a matching key for vendor names (remove punctuation, one case)
SELECT DISTINCT name1, UPPER(REPLACE(REPLACE(name1, '.', ''), ',', '')) AS name_key
FROM ap_invoices;

-- CWIP: costs that look like repairs (several keywords in one pattern)
SELECT anln1, txt50
FROM cwip_assets
WHERE LOWER(txt50) REGEXP 'repair|maintenance|painting';

-- OpEx: short vendor codes for a report
SELECT DISTINCT vendor, UPPER(LEFT(vendor, 3)) AS vendor_code
FROM opex_postings;
```

## ⚠️ Common mistakes

| Mistake | Fix |
| --- | --- |
| Comparing names without `TRIM` | Leading/trailing spaces make equal names differ |
| `LENGTH()` to count characters | Counts bytes (`ü` = 2): use `CHAR_LENGTH()` |
| `CONCAT` with a `NULL` | Whole result is `NULL`: use `CONCAT_WS` or `IFNULL` |
| Storing IDs as numbers, then `LPAD` everywhere | Store as `VARCHAR` with leading zeros from the start |

## 🎯 Key takeaways

1. `UPPER`/`LOWER`, `TRIM` and `REPLACE` **standardise** text before comparing or grouping.
2. `LPAD` restores **leading zeros**; `LEFT`, `RIGHT`, `SUBSTRING`, `SUBSTRING_INDEX` **extract** parts.
3. `REGEXP_REPLACE` cleans by pattern, e.g. keep digits only.
4. `CONCAT` / `CONCAT_WS` **build keys** and labels; `CONCAT_WS` skips `NULL`s.
5. Audit uses: **duplicate vendors**, **duplicate invoices** with different formats, **keyword** searches in posting texts.
