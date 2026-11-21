# ↕️ ORDER BY in MySQL

`ORDER BY` sorts the result. Without it, MySQL returns rows in **no guaranteed order**.

> Part of my learning journey in **Data Engineering, Data Science & AI** · Data: `ap_invoices` ([setup](README.md#setup))

## Syntax

```sql
SELECT columns
FROM table_name
WHERE condition
ORDER BY column1 [ASC | DESC], column2 [ASC | DESC];
```

| Keyword | Order | Numbers | Dates | Text |
| --- | --- | --- | --- | --- |
| `ASC` (default) | Ascending | 1 → 9 | oldest first | A → Z |
| `DESC` | Descending | 9 → 1 | newest first | Z → A |

## Examples

**1 · Largest invoices first**

```sql
SELECT belnr, name1, dmbtr
FROM ap_invoices
ORDER BY dmbtr DESC;               -- 100,000.00 at the top, 320.45 at the bottom
```

**2 · Several columns: vendor A→Z, then amount high→low**

```sql
SELECT name1, budat, dmbtr
FROM ap_invoices
WHERE status = 'OPEN'
ORDER BY name1 ASC, dmbtr DESC;
```

| name1 | budat | dmbtr |
| --- | --- | --- |
| Bright Energy Utilities | 2026-12-11 | 7315.22 |
| Global Logistics Inc | 2026-12-18 | 21980.75 |
| … | … | … |
| Steel Supply Co | 2026-11-30 | 49990.00 |
| Steel Supply Co | 2026-11-30 | 49950.00 |

The second column only sorts rows that tie on the first.

**3 · Sort by a calculation, using its alias**

```sql
SELECT belnr, name1, dmbtr, wskto,
       dmbtr - wskto AS net_payable
FROM ap_invoices
WHERE wskto > 0
ORDER BY net_payable DESC;         -- 7,168.92 / 6,766.78 / 5,744.90
```

**4 · Slowest to post** (days from invoice date to posting date)

```sql
SELECT belnr, name1, DATEDIFF(budat, bldat) AS days_to_post
FROM ap_invoices
ORDER BY days_to_post DESC, belnr;     -- 7 days: IT Consulting Partners, posted on a Sunday
```

## 🧪 Try it

1. Sort all invoices by payment days (`zbd1t`) high to low, then amount high to low. First row → Müller GmbH, 54,300.00.
2. Sort open invoices by posting date, newest first. First row → Office Cleaning Services, 2026-12-31.
3. Sort by vendor number, then document number.

## ⚠️ Common mistakes

| Mistake | Problem | Fix |
| --- | --- | --- |
| Relying on "natural" order | Order can change between runs | Always add `ORDER BY` when order matters |
| `ORDER BY dmbtr, name1 DESC` | `DESC` applies only to `name1` | Write the direction after **each** column |
| Sorting amounts stored as text | `'9999.00'` sorts above `'100000.00'` | Store amounts as `DECIMAL` |
| `ORDER BY 3` | Sorts by column position: breaks when columns change | Use the column name |

## 🎯 Key takeaways

1. `ORDER BY` is the only way to **guarantee** row order.
2. `ASC` is the default; add `DESC` for largest or newest first.
3. Each column gets its **own** direction; later columns break ties.
4. You can sort by a calculated column or its **alias**.
5. It runs near the end of the query, after `WHERE` and before `LIMIT`.
