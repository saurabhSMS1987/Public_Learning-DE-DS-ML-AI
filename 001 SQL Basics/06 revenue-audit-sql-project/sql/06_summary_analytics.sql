-- =====================================================================
-- STEP 6 · Summary analytics
-- Topics: COUNT, SUM, MIN, MAX, AVG, ROUND, GROUP BY (one / several columns,
--         expressions), ORDER BY on aggregates, JOIN to master data
-- All figures are for FY2026 (billing date in 2026).
-- =====================================================================
USE revenue_audit;

-- Q6.1 Headline figures: invoices vs credit memos, then the net total
SELECT fkart,
       COUNT(DISTINCT vbeln) AS documents,
       SUM(netwr)            AS net_value
FROM billing_lines
WHERE fkdat BETWEEN '2026-01-01' AND '2026-12-31'
GROUP BY fkart;                                      -- F2 556 / 11,801,764.99 · G2 23 / -82,287.00

SELECT SUM(netwr) AS net_revenue_fy2026
FROM billing_lines
WHERE fkdat BETWEEN '2026-01-01' AND '2026-12-31';   -- 11,719,477.99

-- Q6.2 MIN / MAX · range of line values and dates
SELECT MIN(netwr) AS smallest_line, MAX(netwr) AS largest_line,
       MIN(fkdat) AS first_billing, MAX(fkdat) AS last_billing
FROM billing_lines
WHERE fkart = 'F2';

-- Q6.3 AVG · average invoice line, simple vs weighted price for P-100
SELECT ROUND(AVG(netwr), 2) AS avg_invoice_line
FROM billing_lines
WHERE fkart = 'F2' AND fkdat BETWEEN '2026-01-01' AND '2026-12-31';

SELECT ROUND(AVG(netpr), 2)              AS simple_avg_price,
       ROUND(SUM(netwr) / SUM(fkimg), 2) AS weighted_avg_price
FROM billing_lines
WHERE matnr = 'P-100' AND fkart = 'F2';

-- Q6.4 GROUP BY month · revenue trend
SELECT MONTH(fkdat)          AS month,
       COUNT(*)              AS line_count,
       SUM(netwr)            AS net_revenue
FROM billing_lines
WHERE fkdat BETWEEN '2026-01-01' AND '2026-12-31'
GROUP BY MONTH(fkdat)
ORDER BY month;

-- Q6.5 GROUP BY material · revenue and price range per product
SELECT matnr,
       SUM(netwr)            AS net_revenue,
       MIN(netpr)            AS min_price,
       MAX(netpr)            AS max_price,
       ROUND(AVG(netpr), 2)  AS avg_price
FROM billing_lines
WHERE fkart = 'F2' AND fkdat BETWEEN '2026-01-01' AND '2026-12-31'
GROUP BY matnr
ORDER BY net_revenue DESC;

-- Q6.6 GROUP BY user · who creates the revenue?
SELECT ernam,
       COUNT(DISTINCT vbeln) AS documents,
       SUM(netwr)            AS net_revenue
FROM billing_lines
WHERE fkdat BETWEEN '2026-01-01' AND '2026-12-31'
GROUP BY ernam
ORDER BY net_revenue DESC;

-- Q6.7 GROUP BY with JOIN (pattern from the Foreign Keys lesson) · revenue by region
SELECT c.region,
       COUNT(DISTINCT b.kunag) AS customers,
       SUM(b.netwr)            AS net_revenue
FROM billing_lines b
JOIN customers c ON c.kunnr = b.kunag
WHERE b.fkdat BETWEEN '2026-01-01' AND '2026-12-31'
GROUP BY c.region
ORDER BY net_revenue DESC;

-- Q6.8 Top 5 customers
SELECT c.name1, SUM(b.netwr) AS net_revenue
FROM billing_lines b
JOIN customers c ON c.kunnr = b.kunag
WHERE b.fkdat BETWEEN '2026-01-01' AND '2026-12-31'
GROUP BY c.kunnr, c.name1
ORDER BY net_revenue DESC
LIMIT 5;

SELECT 'Step 6 complete: summary analytics' AS status;
