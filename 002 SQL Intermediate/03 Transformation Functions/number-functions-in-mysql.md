# 🔢 Number Functions in MySQL

Round, split, compare and test amounts. In journal entry testing, number functions find **round amounts**, amounts **just below thresholds**, unusual **first digits** and debit/credit splits.

> Part of my learning journey in **Data Engineering, Data Science & AI** · Data: `journal_entries` ([setup](README.md#setup))

## Functions

| Function | What it does | Example → Result |
| --- | --- | --- |
| `ROUND(x, d)` | Rounds to `d` decimals (negative `d`: tens, thousands…) | `ROUND(5862.14, -3)` → `6000` |
| `TRUNCATE(x, d)` | Cuts decimals, no rounding | `TRUNCATE(5862.149, 2)` → `5862.14` |
| `CEIL(x)` / `FLOOR(x)` | Up / down to a whole number | `CEIL(5862.14)` → `5863` |
| `ABS(x)` | Removes the sign | `ABS(-50000)` → `50000` |
| `SIGN(x)` | -1, 0 or 1 | `SIGN(-50000)` → `-1` |
| `MOD(a, b)` | Remainder | `MOD(9999, 1000)` → `999` |
| `POWER(x, y)` / `SQRT(x)` | Power / square root | `POWER(1.05, 2)` → `1.1025` |
| `LOG10(x)` | Base-10 logarithm | used for Benford's law |
| `GREATEST(a, b)` / `LEAST(a, b)` | Largest / smallest of values | `GREATEST(-50000, 0)` → `0` |
| `FORMAT(x, d)` | Number as text with separators | `FORMAT(1250000, 2)` → `1,250,000.00` |

## Examples

**1 · Signed amounts: net, total and debit/credit columns**

S/4HANA stores debits as positive and credits as negative amounts (`hsl`).

```sql
SELECT SUM(hsl)                    AS net,             -- 0.00: every document balances
       ROUND(SUM(ABS(hsl)) / 2, 2) AS total_posted     -- 201,248.34
FROM journal_entries;

SELECT belnr, hsl,
       GREATEST(hsl, 0) AS debit,
       -LEAST(hsl, 0)   AS credit
FROM journal_entries
WHERE belnr = '0100000005';
```

| belnr | hsl | debit | credit |
| --- | --- | --- | --- |
| 0100000005 | 50000.00 | 50000.00 | 0.00 |
| 0100000005 | -50000.00 | 0.00 | 50000.00 |

**2 · Round amounts** (multiples of 1,000)

```sql
SELECT DISTINCT belnr, usnam, ABS(hsl) AS amount
FROM journal_entries
WHERE hsl > 0
  AND MOD(hsl, 1000) = 0;                -- 6 documents, incl. CFO_ADMIN 50,000 and 25,000
```

**3 · Just below a threshold** (ending in 999)

```sql
SELECT DISTINCT belnr, usnam, ABS(hsl) AS amount
FROM journal_entries
WHERE hsl > 0
  AND MOD(FLOOR(hsl), 1000) = 999;       -- 0100000003 Test_User 9,999.00 (limit 10,000?)
```

**4 · Benford's law: first-digit test**

In natural financial data, about 30% of amounts start with 1 and fewer than 5% with 9. Large deviations can indicate made-up numbers.

```sql
SELECT d                                AS first_digit,
       COUNT(*)                         AS line_count,
       ROUND(LOG10(1 + 1 / d) * 100, 1) AS benford_expected_pct
FROM (SELECT CAST(LEFT(ABS(hsl), 1) AS UNSIGNED) AS d
      FROM journal_entries
      WHERE hsl > 0) x
GROUP BY d
ORDER BY d;
```

| first_digit | line_count | benford_expected_pct |
| --- | --- | --- |
| 1 | 7 | 30.1 |
| 2 | 1 | 17.6 |
| 4 | 1 | 9.7 |
| … | … | … |

Benford needs **hundreds of lines** to be meaningful; the method is what matters here.

**5 · Amount bands, rounding and growth**

```sql
-- Bands of 10,000 for a stratified sample
SELECT FLOOR(hsl / 10000) * 10000 AS band_from, COUNT(*) AS line_count
FROM journal_entries
WHERE hsl > 0
GROUP BY band_from
ORDER BY band_from;

-- Rent compared with June, in %
SELECT belnr, budat, hsl,
       ROUND((hsl / 15000 - 1) * 100, 1) AS pct_vs_june     -- November +20.0%
FROM journal_entries
WHERE racct = '0000610000' AND hsl > 0;

-- Rounding options side by side
SELECT ROUND(5862.14, 0), ROUND(5862.14, -3), TRUNCATE(5862.149, 2),
       CEIL(5862.14), FLOOR(5862.14), FORMAT(5862.14, 2);
-- 5862 · 6000 · 5862.14 · 5863 · 5862 · '5,862.14'

-- 3% yearly increase over 3 years
SELECT ROUND(15000 * POWER(1.03, 3), 2) AS rent_in_3_years;  -- 16,390.90
```

## 🌍 More real-world examples

Tables from my earlier sections (see [README](README.md#real-world-examples)):

```sql
-- AP: invoices ending in 999 or in round thousands
SELECT belnr, name1, dmbtr
FROM ap_invoices
WHERE MOD(dmbtr, 1000) IN (0, 999);

-- Revenue: convert USD to EUR at a fixed rate, rounded to cents
SELECT vbeln, netwr, ROUND(netwr * 0.92, 2) AS netwr_eur
FROM revenue_lines;

-- CWIP: budget variance in %, one decimal
SELECT anln1, ROUND((cost_to_date / budget - 1) * 100, 1) AS variance_pct
FROM cwip_assets;
```

## ⚠️ Common mistakes

| Mistake | Fix |
| --- | --- |
| Summing signed amounts to get "total posted" | Net is 0: use `SUM(ABS(x)) / 2` or debit/credit columns |
| `FORMAT()` before calculating or sorting | Returns **text**: format only for display |
| `ROUND` on `FLOAT` columns | Store money as `DECIMAL` |
| Dividing by a value that can be 0 | MySQL returns `NULL` (no error): handle with `NULLIF` |

## 🎯 Key takeaways

1. `ROUND`, `TRUNCATE`, `CEIL`, `FLOOR` control decimals; negative digits round to tens or thousands.
2. `ABS`, `SIGN`, `GREATEST`, `LEAST` handle **signed** debit/credit amounts.
3. `MOD` finds **round** amounts (`= 0`) and **threshold** amounts (`= 999`).
4. `LEFT(ABS(x), 1)` + `LOG10` gives a **Benford** first-digit test.
5. `FORMAT` is for **display only**: it turns numbers into text.
