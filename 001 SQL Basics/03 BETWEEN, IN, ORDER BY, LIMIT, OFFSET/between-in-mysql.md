# ↔️ BETWEEN in MySQL

`BETWEEN` filters values inside a range. Both ends are **included**.

> Part of my learning journey in **Data Engineering, Data Science & AI** · Data: `ap_invoices` ([setup](README.md#setup))

## Syntax

```sql
SELECT columns
FROM table_name
WHERE column BETWEEN low AND high;       -- same as column >= low AND column <= high
```

## Examples

**1 · Invoices just below an approval limit** (limit 50,000)

```sql
SELECT belnr, name1, dmbtr
FROM ap_invoices
WHERE dmbtr BETWEEN 45000 AND 49999.99;
```

| belnr | name1 | dmbtr |
| --- | --- | --- |
| 5100000003 | Steel Supply Co | 49950.00 |
| 5100000004 | Steel Supply Co | 49990.00 |
| 5100000011 | Müller GmbH | 48750.50 |

Two Steel Supply invoices posted on the same day, each just under 50,000: a possible **split invoice**.

**2 · Amount band for sampling**

```sql
SELECT COUNT(*) FROM ap_invoices
WHERE dmbtr BETWEEN 10000 AND 50000;          -- 10 invoices
```

**3 · Outside a range**

```sql
SELECT belnr, name1, dmbtr FROM ap_invoices
WHERE dmbtr NOT BETWEEN 1000 AND 50000;       -- 4: very small or very large
```

**4 · Payment terms in days**

```sql
SELECT belnr, name1, zbd1t FROM ap_invoices
WHERE zbd1t BETWEEN 1 AND 30;                 -- 14 invoices (10 or 30 days)
```

**5 · Dates work too**

```sql
SELECT COUNT(*) FROM ap_invoices
WHERE budat BETWEEN '2026-12-01' AND '2026-12-31';   -- 7 December postings
```

## 🧪 Try it

1. Invoices between 5,000 and 10,000 → 7.
2. Invoices with payment terms between 31 and 60 days → 6.
3. Invoices **not** between 2,000 and 100,000 → 1 (the 320.45 credit memo).

## ⚠️ Common mistakes

| Mistake | Problem | Fix |
| --- | --- | --- |
| `BETWEEN 50000 AND 10000` | Low value must come first: returns nothing | `BETWEEN 10000 AND 50000` |
| `BETWEEN 45000 AND 50000` for "below 50,000" | Includes 50,000.00 itself | `BETWEEN 45000 AND 49999.99` or `>= 45000 AND < 50000` |
| `BETWEEN '2026-12-01' AND '2026-12-31'` on a `DATETIME` | Misses times after 00:00 on the 31st | `>= '2026-12-01' AND < '2027-01-01'` |

## 🎯 Key takeaways

1. `BETWEEN low AND high` includes **both ends**.
2. Put the **low value first**, or nothing is returned.
3. `NOT BETWEEN` returns everything outside the range.
4. Works for numbers, dates and text.
5. Typical audit uses: threshold bands, sampling strata, period cut-offs.
