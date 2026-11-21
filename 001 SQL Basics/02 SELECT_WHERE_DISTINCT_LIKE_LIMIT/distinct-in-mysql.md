# 🧹 DISTINCT in MySQL

`DISTINCT` removes duplicate rows from a result, so each value (or combination) appears once.

> Part of my learning journey in **Data Engineering, Data Science & AI** · Data: `je_lines` ([setup](README.md#setup))

## Syntax

```sql
SELECT DISTINCT column1, column2
FROM table_name;

SELECT COUNT(DISTINCT column1) FROM table_name;
```

## Examples

**1 · Who posted entries?**

```sql
SELECT DISTINCT usnam FROM je_lines;     -- 9 users from 41 lines
```

Useful for spotting generic or unexpected users such as `TEST_USER` or `CFO_ADMIN`.

**2 · Unique combinations**

`DISTINCT` applies to **all selected columns together**.

```sql
SELECT DISTINCT blart, tcode FROM je_lines;
```

| blart | tcode |
| --- | --- |
| SA | FB50 |
| SA | FB01 |
| SA | FB08 |
| RE | MIRO |
| … | … |

Document type `SA` appears 3 times because each has a different transaction code.

**3 · Count lines vs documents vs users**

```sql
SELECT COUNT(*)               AS line_count,
       COUNT(DISTINCT belnr)  AS doc_count,
       COUNT(DISTINCT usnam)  AS user_count
FROM je_lines;
```

| line_count | doc_count | user_count |
| --- | --- | --- |
| 41 | 20 | 9 |

Compare `doc_count` with the document count in the SAP extract report.

**4 · Spot possible duplicate invoices**

```sql
SELECT COUNT(*)                     AS invoice_lines,
       COUNT(DISTINCT sgtxt, dmbtr) AS unique_invoices
FROM je_lines
WHERE blart = 'RE' AND shkzg = 'H';
```

| invoice_lines | unique_invoices |
| --- | --- |
| 3 | 2 |

3 invoices but only 2 unique text/amount pairs: one invoice (`Vendor inv 8812`, 7,250.00) was posted twice.

## 🧪 Try it

1. List the distinct document types → 7.
2. List the distinct accounts debited (`shkzg = 'S'`) → 12.
3. Count distinct posting dates in December → 2.

## ⚠️ Common mistakes

| Mistake | Fix |
| --- | --- |
| Expecting `DISTINCT` to apply to one column only | It applies to the whole row of selected columns |
| `SELECT DISTINCT *` to find duplicates | Primary key makes every row unique; select the business columns instead |
| Using `DISTINCT` to hide duplicates from a bad join or import | Find and fix the cause |

## 🎯 Key takeaways

1. `DISTINCT` returns each row of the result **once**.
2. With several columns, it removes duplicate **combinations**.
3. `COUNT(DISTINCT col)` counts unique values: lines vs documents vs users.
4. Comparing `COUNT(*)` with `COUNT(DISTINCT …)` reveals **duplicates**.
5. `NULL` values are grouped together as one value.
