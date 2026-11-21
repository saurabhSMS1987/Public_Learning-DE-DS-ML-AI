-- =====================================================================
-- STEP 2 · Load the CSV files
-- Topics: LOAD DATA LOCAL INFILE, staging load, SHOW WARNINGS, COUNT(*)
--
-- Requirements (see README, "Run the project"):
--   * local_infile enabled on the server:  SET GLOBAL local_infile = 1;
--   * client started with --local-infile=1 (or OPT_LOCAL_INFILE=1 in Workbench)
--   * paths are relative to the folder you start mysql from: the project root.
--     In Workbench, replace 'data/...' with the full path, using forward slashes,
--     e.g. 'C:/Users/me/revenue-audit-sql-project/data/customers.csv'
--   * No local_infile? Load each file with the Table Data Import Wizard
--     ("Use existing table") instead, then continue with step 3.
-- =====================================================================
USE revenue_audit;

-- 2.1 Customers (parent first, because billing_lines references it)
LOAD DATA LOCAL INFILE 'data/customers.csv'
INTO TABLE customers
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(kunnr, name1, region, land1, kdgrp, kdgrp_text, erdat, klimk);
SHOW WARNINGS;

-- 2.2 Materials
LOAD DATA LOCAL INFILE 'data/materials.csv'
INTO TABLE materials
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(matnr, maktx, matkl_text, list_price);
SHOW WARNINGS;

-- 2.3 Raw billing lines into the all-text staging table
LOAD DATA LOCAL INFILE 'data/billing_lines_raw.csv'
INTO TABLE stg_billing_raw
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(vbeln, posnr, fkart, fkdat, kunag, matnr, fkimg, netpr, netwr, waerk, ernam, vgbel);
SHOW WARNINGS;

-- 2.4 Row counts: expected 20 / 8 / 958
SELECT (SELECT COUNT(*) FROM customers)       AS customers,
       (SELECT COUNT(*) FROM materials)       AS materials,
       (SELECT COUNT(*) FROM stg_billing_raw) AS staged_billing_rows;

SELECT 'Step 2 complete: files loaded' AS status;
