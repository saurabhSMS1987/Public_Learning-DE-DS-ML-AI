# 📝 Summary: Transformation Functions

One-page revision sheet. Lessons are listed in the [README](README.md).

## 🧱 Cleaning a raw extract in one query

```sql
SELECT CONCAT_WS('-', rbukrs, belnr, gjahr)                AS document_key,     -- text: combine
       LPAD(lifnr, 10, '0')                                AS vendor_no,        -- text: leading zeros
       UPPER(TRIM(REPLACE(vendor_name, '.', '')))          AS vendor_key,       -- text: standardise
       STR_TO_DATE(bldat, '%Y%m%d')                        AS document_date,    -- date: text → date
       HOUR(cpudt)                                         AS entry_hour,       -- date: part
       ABS(hsl)                                            AS amount,           -- number: unsigned
       MOD(ABS(hsl), 1000) = 0                             AS is_round,         -- number: test
       COALESCE(rcntr, 'UNASSIGNED')                       AS cost_center,      -- NULL: replace
       TRIM(sgtxt)                                         AS line_text
FROM journal_entries;
```

## Cheat sheet

| Need | Function |
| --- | --- |
| Join text / build keys | `CONCAT`, `CONCAT_WS` (skips `NULL`) |
| Standardise text | `UPPER`, `LOWER`, `TRIM`, `REPLACE`, `REGEXP_REPLACE` |
| Extract part of text | `LEFT`, `RIGHT`, `SUBSTRING`, `SUBSTRING_INDEX` |
| Find text | `INSTR`, `LOCATE`, `LIKE`, `REGEXP` |
| Fix length / zeros | `LPAD`, `RPAD`, `CHAR_LENGTH` |
| Round | `ROUND`, `TRUNCATE`, `CEIL`, `FLOOR` |
| Signs and remainders | `ABS`, `SIGN`, `MOD`, `GREATEST`, `LEAST` |
| Display numbers | `FORMAT` (returns text) |
| Today | `CURDATE`, `NOW` |
| Date parts | `YEAR`, `QUARTER`, `MONTH`, `DAY`, `HOUR`, `DAYNAME`, `DAYOFWEEK` |
| Date arithmetic | `DATE_ADD`, `DATE_SUB`, `DATEDIFF`, `TIMESTAMPDIFF`, `LAST_DAY` |
| Text ↔ date | `STR_TO_DATE`, `DATE_FORMAT` |
| Change type | `CAST`, `CONVERT` |
| Handle `NULL` | `IFNULL`, `COALESCE`, `NULLIF` |

## 🔎 Journal entry testing findings

| Test | Functions | Result |
| --- | --- | --- |
| Duplicate vendor master | `UPPER`, `TRIM`, `REPLACE`, `LPAD` | ACME Supplies under 2 vendor numbers |
| Duplicate invoice and payment | `REGEXP_REPLACE`, `SUBSTRING_INDEX`, `CAST` | Invoice 45: 12,450.00 posted and paid twice |
| Suspicious texts | `LOWER`, `LIKE`, `INSTR` | "TEST posting", "Adjust revenue per CFO" |
| Round amounts | `MOD(x, 1000) = 0` | 6 documents |
| Just below 10,000 | `MOD(FLOOR(x), 1000) = 999` | 9,999.00 by Test_User |
| Post-closing entries | `DATE`, `LAST_DAY`, `DATEDIFF` | 2 CFO_ADMIN entries keyed 8–9 Jan 2027 |
| Out-of-hours / weekend | `HOUR`, `DAYOFWEEK`, `DAYNAME` | 3 documents |
| Backdated invoice | `STR_TO_DATE`, `DATEDIFF` | Dec 2025 invoice posted Jan 2026 |
| Missing cost center | `IFNULL`, `COUNT(col)` | 2 expense documents |

## 🎯 Key takeaways

1. **Transform before you compare:** standardise case, spaces, punctuation, zeros and types, or matches are missed.
2. **Text functions** find duplicates hidden by formatting; **number functions** find patterns in amounts.
3. **Date functions** compare posting, document and entry dates: the gaps reveal backdating and post-closing entries.
4. **`NULL` spreads** through `CONCAT` and arithmetic: handle it with `IFNULL`, `COALESCE`, `NULLIF`.
5. Transform in the **query**, not the source: the raw extract stays as evidence.
6. Watch for silent results: `CAST('abc' AS UNSIGNED)` = 0, `100/0` = `NULL`, `FORMAT()` returns text.
7. Never use reserved words such as `lines` or `year_month` as aliases.
