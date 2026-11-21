# 📋 IN in MySQL

`IN` matches a value against a **list**. It replaces a chain of `OR` conditions.

> Part of my learning journey in **Data Engineering, Data Science & AI** · Data: `ap_invoices` ([setup](README.md#setup))

## Syntax

```sql
SELECT columns
FROM table_name
WHERE column IN (value1, value2, value3);

-- same as: column = value1 OR column = value2 OR column = value3
```

## Examples

**1 · Specific amounts**

```sql
SELECT belnr, name1, dmbtr
FROM ap_invoices
WHERE dmbtr IN (2400, 9999, 25000, 100000);
```

| belnr | name1 | dmbtr |
| --- | --- | --- |
| 1900000001 | Office Cleaning Services | 2400.00 |
| 1900000004 | IT Consulting Partners | 25000.00 |
| 1900000005 | IT Consulting Partners | 100000.00 |
| 1900000010 | J. Doe Consulting | 9999.00 |
| … | … | … |

7 invoices. `9999.00` twice from the same vendor is a classic just-below-threshold pattern.

**2 · Immediate or short payment terms**

```sql
SELECT belnr, name1, zterm, zbd1t
FROM ap_invoices
WHERE zbd1t IN (0, 10);                       -- 9 invoices
```

**3 · Everything except those terms**

```sql
SELECT COUNT(*) FROM ap_invoices
WHERE zbd1t NOT IN (0, 10);                   -- 17 invoices
```

**4 · Vendors on a watch list**

Vendor numbers are text (leading zeros), so quote them.

```sql
SELECT belnr, name1, dmbtr
FROM ap_invoices
WHERE lifnr IN ('0000100008', '0000900001');  -- J. Doe Consulting, One-time vendor
```

## 🧪 Try it

1. Invoices with payment terms of 45 or 60 days → 6.
2. Invoices of exactly 2,400 or 7,250 → 5.
3. Invoices from vendors **not** in `('0000100001', '0000100006')` → 19.

## ⚠️ Common mistakes

| Mistake | Problem | Fix |
| --- | --- | --- |
| `lifnr IN (100008, 900001)` | Numbers vs text: compares as numbers, ignores the zeros and can't use an index | `IN ('0000100008', '0000900001')` |
| `NOT IN (1, 2, NULL)` | A `NULL` in the list makes `NOT IN` return **no rows** | Keep `NULL` out of the list |
| `IN (45000-50000)` | Calculates `-5000`: one value, not a range | Use `BETWEEN` for ranges |

## 🎯 Key takeaways

1. `IN (…)` is a short, readable form of several `OR`s.
2. `NOT IN (…)` excludes every value in the list.
3. Match the column type: numbers bare, text **in quotes**.
4. Never put `NULL` in a `NOT IN` list.
5. `IN` for **lists**, `BETWEEN` for **ranges**.
