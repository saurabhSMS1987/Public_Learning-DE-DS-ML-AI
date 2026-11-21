-- =====================================================================
-- STEP 5 · Explore the revenue population
-- Topics: SELECT, aliases (AS), calculated columns, DISTINCT, WHERE,
--         AND / OR, IN, BETWEEN, LIKE, IS NULL, ORDER BY, LIMIT, OFFSET, EXPLAIN
-- =====================================================================
USE revenue_audit;

-- Q5.1 SELECT + LIMIT · preview the data
SELECT * FROM billing_lines LIMIT 5;

-- Q5.2 Aliases and calculated columns
SELECT vbeln                     AS billing_doc,
       fkdat                     AS billing_date,
       kunag                     AS customer,
       netwr                     AS net_value,
       ROUND(netwr * 0.08, 2)    AS est_sales_tax_8pct,
       CONCAT(vbeln, '-', posnr) AS line_id
FROM billing_lines
LIMIT 5;

-- Q5.3 DISTINCT · billing types, users and materials in use
SELECT DISTINCT fkart FROM billing_lines;                       -- F2, G2
SELECT DISTINCT ernam FROM billing_lines ORDER BY ernam;        -- 4 users
SELECT COUNT(*)                AS line_count,
       COUNT(DISTINCT vbeln)   AS doc_count,
       COUNT(DISTINCT kunag)   AS customer_count,
       COUNT(DISTINCT matnr)   AS material_count
FROM billing_lines;                                             -- 955 / 585 / 20 / 8

-- Q5.4 WHERE + BETWEEN · FY2026 population only
SELECT COUNT(*) AS fy2026_lines, SUM(netwr) AS fy2026_net_revenue
FROM billing_lines
WHERE fkdat BETWEEN '2026-01-01' AND '2026-12-31';               -- 949 lines, 11,719,477.99

-- Q5.5 WHERE + IN · documents created by manual (non-batch) users
SELECT ernam, COUNT(*) AS line_count
FROM billing_lines
WHERE ernam IN ('SD_CLERK1', 'SD_CLERK2', 'SALES_MGR')
GROUP BY ernam;

-- Q5.6 AND / OR with brackets · large invoices OR any credit memo, in December
SELECT vbeln, fkdat, fkart, kunag, netwr
FROM billing_lines
WHERE fkdat BETWEEN '2026-12-01' AND '2026-12-31'
  AND (netwr >= 100000 OR fkart = 'G2')
ORDER BY netwr DESC;

-- Q5.7 LIKE · customers whose name mentions hospitals or retail
SELECT kunnr, name1, region
FROM customers
WHERE name1 LIKE '%hospital%' OR name1 LIKE '%retail%';         -- 4 customers

-- Q5.8 IS NULL · credit memos must reference an invoice
SELECT COUNT(*) AS credit_memos_without_reference
FROM billing_lines
WHERE fkart = 'G2' AND vgbel IS NULL;                -- 0

SELECT fkart,
       COUNT(*)     AS line_count,
       COUNT(vgbel) AS with_reference                -- COUNT(column) skips NULLs
FROM billing_lines
GROUP BY fkart;                                      -- F2 930 / 0 · G2 25 / 25

-- Q5.9 ORDER BY + LIMIT · top 10 invoice lines
SELECT vbeln, fkdat, kunag, matnr, netwr, ernam
FROM billing_lines
WHERE fkart = 'F2'
ORDER BY netwr DESC, vbeln
LIMIT 10;

-- Q5.10 OFFSET · the next 10 (page 2)
SELECT vbeln, fkdat, kunag, matnr, netwr
FROM billing_lines
WHERE fkart = 'F2'
ORDER BY netwr DESC, vbeln
LIMIT 10 OFFSET 10;

-- Q5.11 OFFSET · the 3rd largest invoice line
SELECT vbeln, kunag, netwr
FROM billing_lines
WHERE fkart = 'F2'
ORDER BY netwr DESC, vbeln
LIMIT 1 OFFSET 2;

-- Q5.12 EXPLAIN · the date filter uses index idx_bl_fkdat
EXPLAIN
SELECT vbeln, netwr FROM billing_lines
WHERE fkdat BETWEEN '2026-12-24' AND '2026-12-31';

SELECT 'Step 5 complete: exploration' AS status;
