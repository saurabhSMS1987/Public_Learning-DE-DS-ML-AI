-- =====================================================================
-- STEP 7 · Exception lists with HAVING
-- Topics: GROUP BY + HAVING with COUNT, SUM, AVG, MIN, MAX,
--         WHERE vs HAVING, subquery in HAVING
-- =====================================================================
USE revenue_audit;

-- Q7.1 Months with revenue more than 30% above the monthly average
SELECT MONTH(fkdat) AS month, SUM(netwr) AS net_revenue
FROM billing_lines
WHERE fkdat BETWEEN '2026-01-01' AND '2026-12-31'
GROUP BY MONTH(fkdat)
HAVING SUM(netwr) > 1.3 * (SELECT SUM(netwr) / 12
                           FROM billing_lines
                           WHERE fkdat BETWEEN '2026-01-01' AND '2026-12-31');   -- December

-- Q7.2 Materials sold at more than one price
SELECT matnr, MIN(netpr) AS min_price, MAX(netpr) AS max_price,
       MAX(netpr) - MIN(netpr) AS spread
FROM billing_lines
WHERE fkart = 'F2' AND netpr > 0
GROUP BY matnr
HAVING MAX(netpr) > MIN(netpr)
ORDER BY spread DESC;

-- Q7.3 Customers with high revenue from very few documents
SELECT kunag, COUNT(DISTINCT vbeln) AS documents, SUM(netwr) AS invoiced
FROM billing_lines
WHERE fkart = 'F2' AND fkdat BETWEEN '2026-01-01' AND '2026-12-31'
GROUP BY kunag
HAVING COUNT(DISTINCT vbeln) <= 5 AND SUM(netwr) > 100000;   -- 0000100020 Delta Distributors

-- Q7.4 Users with large manual billing in the last week of the year
SELECT ernam, COUNT(*) AS line_count, SUM(netwr) AS net_value
FROM billing_lines
WHERE fkdat BETWEEN '2026-12-24' AND '2026-12-31'   -- WHERE: rows
  AND ernam <> 'BATCH_SD'
GROUP BY ernam
HAVING SUM(netwr) >= 100000;                        -- HAVING: groups → SALES_MGR

-- Q7.5 Customers whose average invoice line is double the overall average
SELECT kunag, ROUND(AVG(netwr), 2) AS avg_line
FROM billing_lines
WHERE fkart = 'F2'
GROUP BY kunag
HAVING AVG(netwr) > 2 * (SELECT AVG(netwr) FROM billing_lines WHERE fkart = 'F2');

-- Q7.6 Customers with 2 or more credit memos in the year
SELECT kunag, COUNT(*) AS credit_memos, SUM(netwr) AS credited
FROM billing_lines
WHERE fkart = 'G2'                                  -- WHERE: credit memo rows only
  AND fkdat BETWEEN '2026-01-01' AND '2026-12-31'
GROUP BY kunag
HAVING COUNT(*) >= 2                                -- HAVING: customers with 2+
ORDER BY credit_memos DESC, kunag;                  -- 7 customers

SELECT 'Step 7 complete: HAVING exception lists' AS status;
