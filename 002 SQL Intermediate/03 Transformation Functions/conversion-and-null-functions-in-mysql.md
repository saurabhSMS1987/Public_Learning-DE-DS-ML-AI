# 🔄 Conversion & NULL Functions in MySQL

Change data types, replace missing values and choose between values. These functions keep calculations, joins and reports correct when data is **stored as the wrong type** or **missing**.

> Part of my learning journey in **Data Engineering, Data Science & AI** · Data: `journal_entries` ([setup](README.md#setup))

## Functions

| Group | Function | Example → Result |
| --- | --- | --- |
| Type | `CAST(x AS type)` | `CAST('1250.50' AS DECIMAL(10,2))` → `1250.50` |
| | `CONVERT(x, type)` | `CONVERT('2026', UNSIGNED)` → `2026` |
| NULL | `IFNULL(x, y)` | `IFNULL(NULL, 'UNASSIGNED')` → `UNASSIGNED` |
| | `COALESCE(a, b, c, …)` | first non-`NULL`: `COALESCE(NULL, NULL, 'n/a')` → `n/a` |
| | `NULLIF(a, b)` | `NULL` if equal: `NULLIF('', '')` → `NULL` |
| Choice | `IF(cond, a, b)` | two outcomes |
| | `CASE WHEN … THEN … ELSE … END` | many outcomes |

`CAST` types: `CHAR`, `DATE`, `DATETIME`, `DECIMAL(p,s)`, `SIGNED`, `UNSIGNED`.

## Examples

**1 · CAST: convert types**

```sql
SELECT CAST('1250.50' AS DECIMAL(10,2)) AS text_to_number,   -- 1250.50
       CAST('20261231' AS DATE)         AS text_to_date,     -- 2026-12-31
       CAST(docln AS UNSIGNED)          AS line_number,      -- '000001' → 1
       CAST(gjahr AS CHAR)              AS year_as_text      -- '2026'
FROM journal_entries
LIMIT 1;
```

**2 · Text vs number comparison of IDs**

```sql
SELECT '100023' = '0000100023'                                         AS as_text,     -- 0
       CAST('100023' AS UNSIGNED) = CAST('0000100023' AS UNSIGNED)     AS as_number;   -- 1
```

Compare IDs either as numbers (`CAST`) or as padded text (`LPAD`), never mixed.

**3 · Replace missing values: IFNULL and COALESCE**

```sql
-- Expense lines with no cost center
SELECT DISTINCT belnr, racct,
       IFNULL(rcntr, 'UNASSIGNED') AS cost_center
FROM journal_entries
WHERE racct >= '0000600000' AND rcntr IS NULL;     -- 0100000002 Legal fees · 0100000003 TEST posting

-- Best available description: vendor name, else reference, else line text
SELECT belnr, docln,
       COALESCE(vendor_name, xblnr, sgtxt) AS description
FROM journal_entries
WHERE belnr IN ('1900000001', '0100000001');
```

| belnr | docln | description |
| --- | --- | --- |
| 0100000001 | 000001 | Bank charges Aug |
| 1900000001 | 000001 | INV-2026-0045 |
| 1900000001 | 000002 | ACME Supplies Ltd |

**4 · NULLIF: blanks to NULL, and safe division**

```sql
SELECT NULLIF(TRIM('   '), '') AS blank_to_null,   -- NULL
       100 / NULLIF(0, 0)      AS safe_division;   -- NULL instead of dividing by zero
```

**5 · NULL spreads through CONCAT**

```sql
SELECT CONCAT('Vendor: ', vendor_name)                 AS concat_plain,    -- NULL
       CONCAT('Vendor: ', IFNULL(vendor_name, 'n/a'))  AS concat_ifnull,   -- 'Vendor: n/a'
       CONCAT_WS(' | ', belnr, vendor_name, sgtxt)     AS concat_ws        -- skips the NULL
FROM journal_entries
WHERE belnr = '0100000001'
LIMIT 1;
```

**6 · IF and CASE: classify while transforming**

```sql
SELECT DISTINCT belnr,
       CASE blart
           WHEN 'KR' THEN 'Vendor invoice'
           WHEN 'KZ' THEN 'Vendor payment'
           WHEN 'SA' THEN 'G/L entry'
           ELSE 'Other'
       END                                                     AS document_type,
       IF(UPPER(usnam) LIKE 'AP\_%', 'AP team', 'Other user')  AS user_group
FROM journal_entries;
```

**7 · Count what is missing**

```sql
SELECT COUNT(*)                AS line_count,             -- 28
       COUNT(rcntr)            AS with_cost_center,       -- 9 (COUNT skips NULL)
       COUNT(*) - COUNT(rcntr) AS without_cost_center     -- 19
FROM journal_entries;
```

## 🌍 More real-world examples

Tables from my earlier sections (see [README](README.md#real-world-examples)):

```sql
-- CWIP: completion date or a label; last activity, else the start date
SELECT anln1,
       IFNULL(act_end, 'Not finished')   AS completed,
       COALESCE(last_post, start_date)   AS last_activity
FROM cwip_assets;

-- Joins: billing documents with no delivery reference
SELECT billing_no, COALESCE(delivery_no, 'NO DELIVERY') AS delivery
FROM billing
WHERE delivery_no IS NULL;

-- Revenue: customer numbers without leading zeros, as numbers
SELECT DISTINCT kunag, CAST(kunag AS UNSIGNED) AS customer_no
FROM revenue_lines;
```

## ⚠️ Common mistakes

| Mistake | Problem | Fix |
| --- | --- | --- |
| `CAST('abc' AS UNSIGNED)` | Returns `0` with only a warning | Validate first (`REGEXP '^[0-9]+$'`), check `SHOW WARNINGS` |
| `CAST` an ID to a number and storing it | Leading zeros lost for good | Cast only for comparison |
| `x = NULL` | Never true | `x IS NULL` |
| `IFNULL(x, 0)` on amounts in reports | Hides missing data | Count the `NULL`s first, then decide |
| `100 / 0` | `NULL` in MySQL (error in strict `INSERT`s) | `NULLIF(divisor, 0)` |

## 🎯 Key takeaways

1. `CAST` / `CONVERT` change types: text to number, text to date, number to text.
2. `IFNULL(x, y)` replaces one `NULL`; `COALESCE` picks the **first non-`NULL`** of many.
3. `NULLIF` turns placeholders (`''`, `0`) into `NULL`, which also makes divisions safe.
4. `NULL` spreads through `CONCAT` and arithmetic; `CONCAT_WS` and `COUNT(col)` skip it.
5. Audit uses: missing cost centers, IDs stored as different types, descriptions from several fields, safe ratios.
