-- =====================================================================
-- STEP 4 · Transform the staged text into typed tables, reconcile, back up
-- Topics: INSERT … SELECT, transactions (START TRANSACTION / COMMIT),
--         TRIM, LOWER, UPPER, LPAD, REPLACE, NULLIF, CAST, STR_TO_DATE,
--         row-count and control-total reconciliation, CREATE TABLE … LIKE
-- Parents are loaded before children because of the foreign keys.
-- =====================================================================
USE olist_audit;

START TRANSACTION;

-- 4.1 Customers: restore leading zeros, standardise text
INSERT INTO customers (customer_id, customer_unique_id, zip_code_prefix, city, state)
SELECT customer_id,
       customer_unique_id,
       LPAD(TRIM(customer_zip_code_prefix), 5, '0'),          -- '9790' → '09790'
       LOWER(TRIM(customer_city)),
       UPPER(TRIM(REPLACE(customer_state, CHAR(13), '')))     -- last column: strip any \r
FROM stg_customers;

-- 4.2 Sellers
INSERT INTO sellers (seller_id, zip_code_prefix, city, state)
SELECT seller_id,
       LPAD(TRIM(seller_zip_code_prefix), 5, '0'),
       LOWER(TRIM(seller_city)),
       UPPER(TRIM(REPLACE(seller_state, CHAR(13), '')))
FROM stg_sellers;

-- 4.3 Category translation: remove the hidden \r at the end of each line
INSERT INTO category_translation (category_name, category_name_en)
SELECT TRIM(product_category_name),
       TRIM(REPLACE(product_category_name_english, CHAR(13), ''))
FROM stg_category_translation;

-- 4.4 Products: blanks → NULL, text → numbers
INSERT INTO products (product_id, category_name, photos_qty, weight_g, length_cm, height_cm, width_cm)
SELECT product_id,
       NULLIF(TRIM(product_category_name), ''),
       CAST(NULLIF(product_photos_qty, '') AS UNSIGNED),
       CAST(NULLIF(product_weight_g, '')   AS UNSIGNED),
       CAST(NULLIF(product_length_cm, '')  AS UNSIGNED),
       CAST(NULLIF(product_height_cm, '')  AS UNSIGNED),
       CAST(NULLIF(REPLACE(product_width_cm, CHAR(13), ''), '') AS UNSIGNED)
FROM stg_products;

-- 4.5 Orders: text timestamps → DATETIME, blanks → NULL
INSERT INTO orders (order_id, customer_id, order_status, purchase_ts, approved_ts,
                    delivered_carrier_ts, delivered_customer_ts, estimated_delivery_date)
SELECT order_id,
       customer_id,
       order_status,
       STR_TO_DATE(order_purchase_timestamp, '%Y-%m-%d %H:%i:%s'),
       STR_TO_DATE(NULLIF(order_approved_at, ''),               '%Y-%m-%d %H:%i:%s'),
       STR_TO_DATE(NULLIF(order_delivered_carrier_date, ''),    '%Y-%m-%d %H:%i:%s'),
       STR_TO_DATE(NULLIF(order_delivered_customer_date, ''),   '%Y-%m-%d %H:%i:%s'),
       DATE(STR_TO_DATE(REPLACE(order_estimated_delivery_date, CHAR(13), ''), '%Y-%m-%d %H:%i:%s'))
FROM stg_orders;

-- 4.6 Order items and payments
INSERT INTO order_items (order_id, order_item_id, product_id, seller_id, shipping_limit_ts, price, freight_value)
SELECT order_id,
       CAST(order_item_id AS UNSIGNED),
       product_id,
       seller_id,
       STR_TO_DATE(shipping_limit_date, '%Y-%m-%d %H:%i:%s'),
       CAST(price AS DECIMAL(10,2)),
       CAST(REPLACE(freight_value, CHAR(13), '') AS DECIMAL(10,2))
FROM stg_order_items;

INSERT INTO order_payments (order_id, payment_sequential, payment_type, payment_installments, payment_value)
SELECT order_id,
       CAST(payment_sequential AS UNSIGNED),
       payment_type,
       CAST(payment_installments AS UNSIGNED),
       CAST(REPLACE(payment_value, CHAR(13), '') AS DECIMAL(10,2))
FROM stg_order_payments;

COMMIT;

-- 4.7 Completeness: staged rows = loaded rows for every table
SELECT 'customers' AS table_name,
       (SELECT COUNT(*) FROM stg_customers) AS staged, (SELECT COUNT(*) FROM customers) AS loaded
UNION ALL SELECT 'sellers',        (SELECT COUNT(*) FROM stg_sellers),              (SELECT COUNT(*) FROM sellers)
UNION ALL SELECT 'products',       (SELECT COUNT(*) FROM stg_products),             (SELECT COUNT(*) FROM products)
UNION ALL SELECT 'categories',     (SELECT COUNT(*) FROM stg_category_translation), (SELECT COUNT(*) FROM category_translation)
UNION ALL SELECT 'orders',         (SELECT COUNT(*) FROM stg_orders),               (SELECT COUNT(*) FROM orders)
UNION ALL SELECT 'order_items',    (SELECT COUNT(*) FROM stg_order_items),          (SELECT COUNT(*) FROM order_items)
UNION ALL SELECT 'order_payments', (SELECT COUNT(*) FROM stg_order_payments),       (SELECT COUNT(*) FROM order_payments);

-- 4.8 Accuracy: control totals in staging = control totals loaded
SELECT (SELECT SUM(CAST(price AS DECIMAL(12,2))) FROM stg_order_items)  AS staged_price_total,
       (SELECT SUM(price) FROM order_items)                             AS loaded_price_total,
       (SELECT SUM(CAST(REPLACE(payment_value, CHAR(13), '') AS DECIMAL(12,2))) FROM stg_order_payments) AS staged_payment_total,
       (SELECT SUM(payment_value) FROM order_payments)                  AS loaded_payment_total;

-- 4.9 Transformations worked: no 4-digit zips, no \r left
SELECT (SELECT COUNT(*) FROM customers WHERE CHAR_LENGTH(zip_code_prefix) <> 5)            AS bad_zips,
       (SELECT COUNT(*) FROM category_translation WHERE category_name_en LIKE CONCAT('%', CHAR(13))) AS cr_left;

-- 4.10 Backup copy of the cleaned orders before any changes in step 10
CREATE TABLE orders_bkp LIKE orders;
INSERT INTO orders_bkp SELECT * FROM orders;

SELECT 'Step 4 complete: typed tables loaded and reconciled' AS status;
