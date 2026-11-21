# 📈 Analytics with SQL in MySQL

Turn joined data into **business metrics**: growth, mix, concentration, aging, days sales outstanding (DSO), credit utilisation, collection speed. Each metric combines techniques from earlier lessons: joins, `GROUP BY`, `CASE`, `IF`, date functions and derived tables.

> Part of my learning journey in **Data Engineering, Data Science & AI** · Data: `ar_customers`, `ar_products`, `ar_invoices`, `ar_invoice_items`, `ar_payments` ([setup](README.md#setup))

## The analytics pattern

```mermaid
flowchart LR
    A["Join the<br/>tables"] --> B["Filter the<br/>period"] --> C["Group &<br/>aggregate"] --> D["Calculate the<br/>metric (ratio, %)"] --> E["Compare with<br/>expectation"]
```

## Step 0 · Build the year-end AR open items once

Several metrics need the open balance per invoice at **31 December 2026**. Build it once with `CREATE TABLE … AS SELECT`, then reuse it:

```sql
SET @ye = '2026-12-31';

DROP TABLE IF EXISTS ar_open_items_ye;
CREATE TABLE ar_open_items_ye AS
SELECT i.invoice_no, i.customer_id, i.invoice_date,
       DATE_ADD(i.invoice_date, INTERVAL c.payment_terms_days DAY)                AS due_date,
       b.billed,
       IFNULL(pd.paid, 0)                                                         AS paid_by_ye,
       b.billed - IFNULL(pd.paid, 0)                                              AS open_amount,
       DATEDIFF(@ye, DATE_ADD(i.invoice_date, INTERVAL c.payment_terms_days DAY)) AS days_overdue
FROM ar_invoices i
JOIN ar_customers c ON c.customer_id = i.customer_id
JOIN (SELECT invoice_no, SUM(net_amount) AS billed
      FROM ar_invoice_items GROUP BY invoice_no) b    ON b.invoice_no  = i.invoice_no
LEFT JOIN (SELECT invoice_no, SUM(amount) AS paid
      FROM ar_payments WHERE payment_date <= @ye
      GROUP BY invoice_no) pd                          ON pd.invoice_no = i.invoice_no
WHERE i.invoice_date <= @ye
  AND b.billed - IFNULL(pd.paid, 0) <> 0;

SELECT COUNT(*) AS open_items, SUM(open_amount) AS total_ar FROM ar_open_items_ye;   -- 9 · 219,875.00
```

## Revenue analytics

**1 · Year-on-year growth by customer**

```sql
SELECT c.name,
       SUM(IF(YEAR(i.invoice_date) = 2025, it.net_amount, 0)) AS revenue_2025,
       SUM(IF(YEAR(i.invoice_date) = 2026, it.net_amount, 0)) AS revenue_2026,
       ROUND((SUM(IF(YEAR(i.invoice_date) = 2026, it.net_amount, 0))
            / NULLIF(SUM(IF(YEAR(i.invoice_date) = 2025, it.net_amount, 0)), 0) - 1) * 100, 1) AS growth_pct
FROM ar_customers c
LEFT JOIN ar_invoices i       ON i.customer_id = c.customer_id
LEFT JOIN ar_invoice_items it ON it.invoice_no = i.invoice_no
GROUP BY c.customer_id, c.name
ORDER BY revenue_2026 DESC;
```

| name | revenue_2025 | revenue_2026 | growth_pct |
| --- | --- | --- | --- |
| Müller GmbH | 37500.00 | 148500.00 | 296.0 |
| Acme Retail | 45000.00 | 110700.00 | 146.0 |
| … | … | … | … |
| Delta Distributors | 0.00 | 68700.00 | NULL (new customer) |

Total revenue grew from 148,450 to **515,425 (+247%)**. Growth on that scale needs a business explanation before the auditor accepts it.

**2 · Product mix: share of revenue**

```sql
SELECT p.description,
       SUM(it.net_amount)                          AS revenue,
       ROUND(SUM(it.net_amount) / t.total * 100, 1) AS pct_of_revenue
FROM ar_invoice_items it
JOIN ar_invoices i ON i.invoice_no = it.invoice_no
JOIN ar_products p ON p.product_id = it.product_id
CROSS JOIN (SELECT SUM(it2.net_amount) AS total
            FROM ar_invoice_items it2
            JOIN ar_invoices i2 ON i2.invoice_no = it2.invoice_no
            WHERE YEAR(i2.invoice_date) = 2026) t
WHERE YEAR(i.invoice_date) = 2026
GROUP BY p.product_id, p.description, t.total
ORDER BY revenue DESC;                              -- Steel beam 53.7% · Steel sheet 27.5% · …
```

**3 · Customer concentration: top 3 customers' share**

```sql
SELECT c.name,
       SUM(it.net_amount)                           AS revenue,
       ROUND(SUM(it.net_amount) / t.total * 100, 1) AS pct_of_revenue
FROM ar_invoice_items it
JOIN ar_invoices  i ON i.invoice_no  = it.invoice_no
JOIN ar_customers c ON c.customer_id = i.customer_id
CROSS JOIN (SELECT SUM(it2.net_amount) AS total
            FROM ar_invoice_items it2
            JOIN ar_invoices i2 ON i2.invoice_no = it2.invoice_no
            WHERE YEAR(i2.invoice_date) = 2026) t
WHERE YEAR(i.invoice_date) = 2026
GROUP BY c.customer_id, c.name, t.total
ORDER BY revenue DESC
LIMIT 3;                                            -- 28.8% + 21.5% + 18.5% = 68.8%
```

## Receivables analytics

**4 · AR aging**

```sql
SELECT CASE
           WHEN open_amount < 0    THEN '5 Credit balance'
           WHEN days_overdue <= 0  THEN '1 Not due'
           WHEN days_overdue <= 30 THEN '2 1-30 days'
           WHEN days_overdue <= 90 THEN '3 31-90 days'
           ELSE '4 90+ days'
       END                                                                     AS bucket,
       COUNT(*)                                                                AS items,
       SUM(open_amount)                                                        AS amount,
       ROUND(SUM(open_amount) / (SELECT SUM(open_amount) FROM ar_open_items_ye) * 100, 1) AS pct
FROM ar_open_items_ye
GROUP BY bucket
ORDER BY bucket;
```

| bucket | items | amount | pct |
| --- | --- | --- | --- |
| 1 Not due | 3 | 113700.00 | 51.7 |
| 2 1-30 days | 2 | 66925.00 | 30.4 |
| 3 31-90 days | 2 | 38200.00 | 17.4 |
| 4 90+ days | 1 | 3550.00 | 1.6 |
| 5 Credit balance | 1 | -2500.00 | -1.1 |

The 90+ item (Sunrise Hospitals, 264 days overdue) is a candidate for a **bad-debt provision**; the credit balance is an **overpayment** to refund or reclassify.

**5 · Days sales outstanding (DSO)**

```sql
SELECT ar.total_ar,
       rev.revenue_2026,
       ROUND(ar.total_ar / rev.revenue_2026 * 365, 0) AS dso_days
FROM (SELECT SUM(open_amount) AS total_ar FROM ar_open_items_ye) ar
CROSS JOIN (SELECT SUM(it.net_amount) AS revenue_2026
            FROM ar_invoice_items it
            JOIN ar_invoices i ON i.invoice_no = it.invoice_no
            WHERE YEAR(i.invoice_date) = 2026) rev;
-- 219,875 / 515,425 × 365 = 156 days, versus 30-60-day payment terms
```

A DSO far above payment terms means receivables are building up: slow payers or **year-end sales that won't be collected**.

**6 · Credit limit utilisation**

```sql
SELECT c.name, c.credit_limit,
       SUM(o.open_amount)                                AS ar_balance,
       ROUND(SUM(o.open_amount) / c.credit_limit * 100, 1) AS utilisation_pct
FROM ar_open_items_ye o
JOIN ar_customers c ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name, c.credit_limit
HAVING SUM(o.open_amount) > c.credit_limit * 0.5
ORDER BY utilisation_pct DESC;
```

| name | credit_limit | ar_balance | utilisation_pct |
| --- | --- | --- | --- |
| Delta Distributors | 40000.00 | 68700.00 | **171.8** |
| Sunrise Hospitals | 80000.00 | 53150.00 | 66.4 |

**7 · Average days to pay vs payment terms**

```sql
SELECT c.name, c.payment_terms_days,
       COUNT(*)                                                    AS payments,
       ROUND(AVG(DATEDIFF(pm.payment_date, i.invoice_date)), 1)   AS avg_days_to_pay
FROM ar_payments pm
JOIN ar_invoices  i ON i.invoice_no  = pm.invoice_no
JOIN ar_customers c ON c.customer_id = i.customer_id
GROUP BY c.customer_id, c.name, c.payment_terms_days
ORDER BY avg_days_to_pay DESC;
```

**8 · Subsequent receipts: was year-end AR collected in January?**

```sql
SELECT o.invoice_no, c.name, o.open_amount,
       IFNULL(SUM(pm.amount), 0)                 AS received_after_ye,
       o.open_amount - IFNULL(SUM(pm.amount), 0) AS still_unpaid
FROM ar_open_items_ye o
JOIN ar_customers c     ON c.customer_id = o.customer_id
LEFT JOIN ar_payments pm ON pm.invoice_no = o.invoice_no
                        AND pm.payment_date > '2026-12-31'
WHERE o.open_amount > 0
GROUP BY o.invoice_no, c.name, o.open_amount
ORDER BY o.invoice_no;
```

Only **61,325 of 222,375 (27.6%)** was received after year-end. The Delta Distributors invoices (68,700, credit limit exceeded, price above list) have no receipts at all.

## 🌍 More real-world examples

Tables from my earlier sections (see [README](README.md#real-world-examples)):

```sql
-- OpEx: spend by department and share of total
SELECT cc.department,
       SUM(o.amount)                          AS spend,
       ROUND(SUM(o.amount) / t.total * 100, 1) AS pct_of_total
FROM opex_postings o
JOIN cost_centers cc ON cc.cost_center = o.cost_center
CROSS JOIN (SELECT SUM(amount) AS total FROM opex_postings) t
GROUP BY cc.department, t.total
ORDER BY spend DESC;

-- Journal entries: activity per user (normalised user ID)
SELECT UPPER(usnam)                   AS user_id,
       COUNT(DISTINCT belnr)          AS documents,
       SUM(GREATEST(hsl, 0))          AS debits
FROM journal_entries
GROUP BY user_id
ORDER BY debits DESC;

-- Revenue: each month's share of the year (spot year-end spikes)
SELECT MONTH(fkdat)                          AS month,
       SUM(netwr)                            AS revenue,
       ROUND(SUM(netwr) / t.total * 100, 1)  AS pct_of_year
FROM revenue_lines
CROSS JOIN (SELECT SUM(netwr) AS total FROM revenue_lines WHERE YEAR(fkdat) = 2026) t
WHERE YEAR(fkdat) = 2026
GROUP BY MONTH(fkdat), t.total
ORDER BY pct_of_year DESC;                   -- December ≈ 40%

-- AP: open balance by vendor as % of total open AP
SELECT name1,
       SUM(dmbtr)                                                                 AS open_ap,
       ROUND(SUM(dmbtr) / (SELECT SUM(dmbtr) FROM ap_invoices WHERE status = 'OPEN') * 100, 1) AS pct
FROM ap_invoices
WHERE status = 'OPEN'
GROUP BY name1
ORDER BY open_ap DESC;
```

## ⚠️ Common mistakes

| Mistake | Fix |
| --- | --- |
| Dividing by a value that can be zero (new customer growth) | `x / NULLIF(y, 0)` returns `NULL`, not an error or a fake number |
| Percentages that don't add to 100% | Use the **same filter** in the total as in the detail |
| Fan-out inflating metrics | Aggregate one-to-many tables before joining |
| Mixing periods (2027 receipts in year-end AR) | Filter every table to the as-at date |
| Treating credit balances as receivables | Show them separately in the aging |

## 🎯 Key takeaways

1. Analytics = **join → filter → group → calculate → compare**.
2. Build reusable bases (year-end open items) once with `CREATE TABLE … AS SELECT`.
3. **Ratios and shares**: a `CROSS JOIN` to a one-row total, and `NULLIF` against division by zero.
4. Key revenue/AR metrics: **growth, mix, concentration, aging, DSO, credit utilisation, days to pay, subsequent receipts**.
5. A metric only matters when **compared**: with last year, payment terms, credit limits or expectations.
