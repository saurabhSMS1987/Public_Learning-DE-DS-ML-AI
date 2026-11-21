-- =====================================================================
-- STEP 3 · Data quality checks on the staged rows
-- Topics: SELECT, WHERE, DISTINCT, LIKE, REGEXP, IS NULL, IN / NOT IN,
--         subqueries, GROUP BY, HAVING, COUNT
-- Goal: list every row that would fail or corrupt the final table.
-- =====================================================================
USE revenue_audit;

-- 3.1 What values do the code columns contain? (DISTINCT)
SELECT DISTINCT fkart FROM stg_billing_raw;                -- F2, G2, and '' (total line)
SELECT DISTINCT waerk FROM stg_billing_raw;                -- USD only
SELECT DISTINCT ernam FROM stg_billing_raw ORDER BY ernam; -- users who created billing documents

-- 3.2 Report total / blank lines (no document number)
SELECT row_id, vbeln, netwr
FROM stg_billing_raw
WHERE vbeln IS NULL OR vbeln = '';                         -- 1 row: the report total

-- 3.3 Billing dates that are missing or not in DD.MM.YYYY format
SELECT row_id, vbeln, fkdat
FROM stg_billing_raw
WHERE vbeln <> ''
  AND (fkdat IS NULL OR fkdat NOT REGEXP '^[0-9]{2}[.][0-9]{2}[.][0-9]{4}$');   -- 1 row

-- 3.4 Customers not in the customer master (would break the foreign key)
SELECT row_id, vbeln, kunag
FROM stg_billing_raw
WHERE vbeln <> ''
  AND kunag NOT IN (SELECT kunnr FROM customers);          -- 1 row: 0000199999

-- 3.5 Materials not in the material master
SELECT row_id, vbeln, matnr
FROM stg_billing_raw
WHERE vbeln <> ''
  AND matnr NOT IN (SELECT matnr FROM materials);          -- expected: none

-- 3.6 Amounts and quantities not in SAP number format (1,234.56 / 1,234.56-)
SELECT row_id, vbeln, fkimg, netpr, netwr
FROM stg_billing_raw
WHERE vbeln <> ''
  AND (netwr NOT REGEXP '^[0-9,]+[.][0-9]{2}-?$'
       OR netpr NOT REGEXP '^[0-9,]+[.][0-9]{2}-?$'
       OR fkimg NOT REGEXP '^[0-9,]+-?$');                 -- expected: none

-- 3.7 Duplicate document / item keys (would break the primary key)
SELECT vbeln, posnr, COUNT(*) AS copies
FROM stg_billing_raw
WHERE vbeln <> ''
GROUP BY vbeln, posnr
HAVING COUNT(*) > 1;                                       -- expected: none

-- 3.8 Credit memo lines must carry a trailing minus (LIKE)
SELECT (SELECT COUNT(*) FROM stg_billing_raw WHERE fkart = 'G2')                       AS credit_lines,
       (SELECT COUNT(*) FROM stg_billing_raw WHERE fkart = 'G2' AND netwr LIKE '%-')   AS with_minus;   -- 25 / 25

-- 3.9 Quality summary
SELECT (SELECT COUNT(*) FROM stg_billing_raw)                       AS staged_rows,
       (SELECT COUNT(*) FROM stg_billing_raw WHERE vbeln = '')      AS total_lines,
       (SELECT COUNT(*) FROM stg_billing_raw
        WHERE vbeln <> '' AND fkdat NOT REGEXP '^[0-9]{2}[.][0-9]{2}[.][0-9]{4}$') AS bad_dates,
       (SELECT COUNT(*) FROM stg_billing_raw
        WHERE vbeln <> '' AND kunag NOT IN (SELECT kunnr FROM customers))        AS unknown_customers;   -- 958 / 1 / 1 / 1

SELECT 'Step 3 complete: 3 rows to reject, 955 clean rows' AS status;
