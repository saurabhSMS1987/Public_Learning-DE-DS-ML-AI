-- =====================================================================
-- STEP 2 · Load the CSV files into the staging tables
-- Topics: LOAD DATA LOCAL INFILE, staging pattern, SHOW WARNINGS, COUNT(*)
--
-- Requirements (see README, "Run the project"):
--   * SET GLOBAL local_infile = 1;  (once, as root)
--   * client started with --local-infile=1 (Workbench: OPT_LOCAL_INFILE=1)
--   * paths are relative to the folder you start mysql from: the project root.
--     In Workbench, replace 'data/...' with the full path (forward slashes).
--   * LINES TERMINATED BY '\n' works for both \n and \r\n files: any trailing
--     \r is removed in step 4.
-- =====================================================================
USE olist_audit;

LOAD DATA LOCAL INFILE 'data/olist_customers_dataset.csv'
INTO TABLE stg_customers
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'data/olist_sellers_dataset.csv'
INTO TABLE stg_sellers
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'data/olist_products_dataset.csv'
INTO TABLE stg_products
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'data/product_category_name_translation.csv'
INTO TABLE stg_category_translation
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;                                   -- the header line also carries a byte-order mark

LOAD DATA LOCAL INFILE 'data/olist_orders_dataset.csv'
INTO TABLE stg_orders
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'data/olist_order_items_dataset.csv'
INTO TABLE stg_order_items
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'data/olist_order_payments_dataset.csv'
INTO TABLE stg_order_payments
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SHOW WARNINGS;

-- Row counts must equal the CSV line counts minus the header
SELECT 'stg_customers'            AS staging_table, COUNT(*) AS row_count FROM stg_customers            -- 99,441
UNION ALL SELECT 'stg_sellers',              COUNT(*) FROM stg_sellers                                   -- 3,095
UNION ALL SELECT 'stg_products',             COUNT(*) FROM stg_products                                  -- 32,951
UNION ALL SELECT 'stg_category_translation', COUNT(*) FROM stg_category_translation                      -- 71
UNION ALL SELECT 'stg_orders',               COUNT(*) FROM stg_orders                                    -- 99,441
UNION ALL SELECT 'stg_order_items',          COUNT(*) FROM stg_order_items                               -- 112,650
UNION ALL SELECT 'stg_order_payments',       COUNT(*) FROM stg_order_payments;                           -- 103,886

SELECT 'Step 2 complete: CSV files staged' AS status;
