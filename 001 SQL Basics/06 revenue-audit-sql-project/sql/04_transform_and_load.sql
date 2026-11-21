-- =====================================================================
-- STEP 4 · Convert clean rows into the final table, reconcile, back up
-- Topics: INSERT ... SELECT, STR_TO_DATE, REPLACE, IF, NULLIF, transactions
--         (START TRANSACTION / COMMIT), reconciliation, CREATE TABLE ... LIKE
-- =====================================================================
USE revenue_audit;

-- 4.1 Move only valid rows, converting SAP formats on the way
START TRANSACTION;

INSERT INTO billing_lines
    (vbeln, posnr, fkart, fkdat, kunag, matnr, fkimg, netpr, netwr, waerk, ernam, vgbel)
SELECT vbeln,
       posnr,
       fkart,
       STR_TO_DATE(fkdat, '%d.%m.%Y'),                                          -- 31.12.2026 → 2026-12-31
       kunag,
       matnr,
       REPLACE(IF(fkimg LIKE '%-', CONCAT('-', TRIM(TRAILING '-' FROM fkimg)), fkimg), ',', ''),   -- 80- → -80
       REPLACE(netpr, ',', ''),                                                  -- 1,950.00 → 1950.00
       REPLACE(IF(netwr LIKE '%-', CONCAT('-', TRIM(TRAILING '-' FROM netwr)), netwr), ',', ''),
       waerk,
       ernam,
       NULLIF(vgbel, '')                                                         -- blank → NULL
FROM stg_billing_raw
WHERE vbeln <> ''                                                    -- not the total line
  AND fkdat REGEXP '^[0-9]{2}[.][0-9]{2}[.][0-9]{4}$'                -- valid date format
  AND kunag IN (SELECT kunnr FROM customers)                         -- known customer
  AND matnr IN (SELECT matnr FROM materials)                         -- known material
ORDER BY row_id;

COMMIT;

-- 4.2 Completeness: staged = loaded + rejected
SELECT (SELECT COUNT(*) FROM stg_billing_raw)                 AS staged_rows,
       (SELECT COUNT(*) FROM billing_lines)                   AS loaded_rows,
       (SELECT COUNT(*) FROM stg_billing_raw)
     - (SELECT COUNT(*) FROM billing_lines)                   AS rejected_rows;   -- 958 / 955 / 3

-- 4.3 Accuracy: loaded total = SAP report total line
SELECT (SELECT SUM(netwr) FROM billing_lines)                 AS loaded_total,
       (SELECT REPLACE(netwr, ',', '') FROM stg_billing_raw
        WHERE vbeln = '')                                     AS sap_report_total;  -- both 11,492,928.49

-- 4.4 Rejected rows, to send back to the client
SELECT row_id, vbeln, fkdat, kunag, netwr
FROM stg_billing_raw
WHERE vbeln NOT IN (SELECT vbeln FROM billing_lines)
ORDER BY row_id;

-- 4.5 Backup of the clean population before any adjustments (step 9)
CREATE TABLE billing_lines_bkp LIKE billing_lines;
INSERT INTO billing_lines_bkp SELECT * FROM billing_lines;
SELECT COUNT(*) AS backup_rows FROM billing_lines_bkp;             -- 955

SELECT 'Step 4 complete: 955 rows loaded and reconciled' AS status;
