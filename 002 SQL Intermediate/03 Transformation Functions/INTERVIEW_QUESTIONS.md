# 🎤 Top 10 Interview Questions: SQL Transformation Functions

**1. What is the difference between `CONCAT` and `CONCAT_WS`?**
`CONCAT(a, b, c)` joins values and returns `NULL` if **any** value is `NULL`. `CONCAT_WS(sep, a, b, c)` puts a separator between values and **skips** `NULL`s. Use `CONCAT_WS` for keys and labels built from optional fields.

**2. How would you find duplicate vendors whose names are written differently?**
Standardise the name, then group:

```sql
SELECT UPPER(TRIM(REPLACE(vendor_name, '.', ''))) AS name_key,
       COUNT(DISTINCT LPAD(lifnr, 10, '0'))       AS vendor_numbers
FROM journal_entries
GROUP BY name_key
HAVING COUNT(DISTINCT LPAD(lifnr, 10, '0')) > 1;
```

`UPPER` handles case, `TRIM` spaces, `REPLACE` punctuation, and `LPAD` makes vendor numbers comparable.

**3. Is a comparison in MySQL case-sensitive? Why might you still need `UPPER`?**
With the default collation (`utf8mb4_0900_ai_ci`), no: `'ACME' = 'acme'` is true. Spaces and punctuation still count, so `TRIM`/`REPLACE` are needed. `UPPER` gives one consistent spelling for display and exports. To compare exactly, use `BINARY`: `COUNT(DISTINCT BINARY usnam)`.

**4. `LENGTH` vs `CHAR_LENGTH`?**
`LENGTH` counts **bytes**, `CHAR_LENGTH` counts **characters**. In UTF-8, `'Müller'` has 6 characters but 7 bytes. Use `CHAR_LENGTH` for text rules such as "account numbers must be 10 characters".

**5. How do you convert an SAP date such as `20261231` or `31.12.2026` to a date?**
`STR_TO_DATE('20261231', '%Y%m%d')` and `STR_TO_DATE('31.12.2026', '%d.%m.%Y')`. `DATE_FORMAT(date, '%d.%m.%Y')` converts back to text. Text dates can't be compared or sorted correctly until converted.

**6. `DATEDIFF` vs `TIMESTAMPDIFF`?**
`DATEDIFF(a, b)` returns whole **days** (a − b) and ignores the time. `TIMESTAMPDIFF(unit, start, end)` returns the difference in any unit (`HOUR`, `MONTH`, `YEAR`) and counts only completed units. Entry 8 days late: `DATEDIFF`; 215 hours late: `TIMESTAMPDIFF(HOUR, …)`.

**7. How would you identify journal entries posted after the period was closed?**
Compare the entry timestamp with the posting date's month end:

```sql
SELECT belnr, budat, cpudt
FROM journal_entries
WHERE DATE(cpudt) > LAST_DAY(budat);
```

Entries dated 31 December but keyed in January are high-risk **post-closing** adjustments.

**8. `ROUND` vs `TRUNCATE` vs `CEIL`/`FLOOR`?**
`ROUND(5862.149, 2)` → 5862.15 (nearest), `TRUNCATE(5862.149, 2)` → 5862.14 (cut off), `CEIL(5862.14)` → 5863 (up), `FLOOR(5862.14)` → 5862 (down). A negative precision rounds left of the decimal point: `ROUND(5862.14, -3)` → 6000. `FORMAT` is for display only: it returns text.

**9. `IFNULL` vs `COALESCE` vs `NULLIF`?**
`IFNULL(x, y)` replaces one `NULL` with a value. `COALESCE(a, b, c, …)` returns the first non-`NULL` value from a list and is standard SQL. `NULLIF(a, b)` does the opposite: it returns `NULL` when the two are equal, which turns placeholders like `''` into `NULL` and avoids division by zero: `x / NULLIF(y, 0)`.

**10. What are the risks of `CAST`, and how do you use it safely?**
Invalid values don't raise errors in a `SELECT`: `CAST('abc' AS UNSIGNED)` returns 0 with a warning, and casting IDs to numbers drops leading zeros. Validate first (`REGEXP '^[0-9]+$'`), check `SHOW WARNINGS`, and cast only for comparison or calculation, never to overwrite source data. Example: `CAST('100023' AS UNSIGNED) = CAST('0000100023' AS UNSIGNED)` is true, while the text comparison is false.
