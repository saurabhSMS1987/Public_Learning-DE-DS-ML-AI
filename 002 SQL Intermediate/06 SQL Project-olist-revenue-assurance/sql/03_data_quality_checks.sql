-- =====================================================================
-- STEP 3 · Data quality checks on the staged data
-- Topics: SELECT, COUNT, DISTINCT, WHERE, AND/OR, LIKE, IN, IS NULL,
--         CHAR_LENGTH, HEX, LEFT JOIN anti-join, GROUP BY + HAVING
-- Goal: know every problem BEFORE loading the typed tables in step 4.
-- =====================================================================
USE olist_audit;

-- 3.1 Which order statuses exist? (DISTINCT)
SELECT DISTINCT order_status FROM stg_orders ORDER BY order_status;     -- 8 statuses

-- 3.2 Missing timestamps by status (blank text = missing)
SELECT order_status,
       COUNT(*)                               AS order_count,
       SUM(IF(order_approved_at = '', 1, 0))            AS no_approval_date,
       SUM(IF(order_delivered_customer_date = '', 1, 0)) AS no_delivery_date
FROM stg_orders
GROUP BY order_status
ORDER BY order_count DESC;            -- 8 'delivered' orders have no delivery date

-- 3.3 Zip codes that lost their leading zero (should be 5 characters)
SELECT CHAR_LENGTH(customer_zip_code_prefix) AS zip_length, COUNT(*) AS customers
FROM stg_customers
GROUP BY zip_length;                  -- 23,995 customers have a 4-digit zip

-- 3.4 Hidden carriage returns (Windows line endings) in the translation file
SELECT COUNT(*) AS rows_with_cr
FROM stg_category_translation
WHERE product_category_name_english LIKE CONCAT('%', CHAR(13));   -- 70 of 71

SELECT product_category_name_english,
       HEX(RIGHT(product_category_name_english, 1)) AS last_char_hex  -- '0D' = \r
FROM stg_category_translation
LIMIT 3;

-- 3.5 Products with no category, and categories with no English translation
SELECT COUNT(*) AS products_without_category
FROM stg_products
WHERE product_category_name = '';                                   -- 610

SELECT DISTINCT p.product_category_name
FROM stg_products p
LEFT JOIN stg_category_translation t ON t.product_category_name = p.product_category_name
WHERE t.product_category_name IS NULL
  AND p.product_category_name <> '';                                -- 2 untranslated categories

-- 3.6 Orphans: rows pointing to a parent that does not exist (expected: 0 each)
SELECT
    (SELECT COUNT(*) FROM stg_orders o LEFT JOIN stg_customers c ON c.customer_id = o.customer_id
     WHERE c.customer_id IS NULL)                                    AS orders_without_customer,
    (SELECT COUNT(*) FROM stg_order_items i LEFT JOIN stg_orders o ON o.order_id = i.order_id
     WHERE o.order_id IS NULL)                                       AS items_without_order,
    (SELECT COUNT(*) FROM stg_order_items i LEFT JOIN stg_products p ON p.product_id = i.product_id
     WHERE p.product_id IS NULL)                                     AS items_without_product,
    (SELECT COUNT(*) FROM stg_order_items i LEFT JOIN stg_sellers s ON s.seller_id = i.seller_id
     WHERE s.seller_id IS NULL)                                      AS items_without_seller,
    (SELECT COUNT(*) FROM stg_order_payments p LEFT JOIN stg_orders o ON o.order_id = p.order_id
     WHERE o.order_id IS NULL)                                       AS payments_without_order;

-- 3.7 Duplicate keys (expected: none)
SELECT order_id, order_item_id, COUNT(*) AS copies
FROM stg_order_items
GROUP BY order_id, order_item_id
HAVING COUNT(*) > 1;

SELECT order_id, payment_sequential, COUNT(*) AS copies
FROM stg_order_payments
GROUP BY order_id, payment_sequential
HAVING COUNT(*) > 1;

-- 3.8 Timestamp logic: carrier pickup before approval, delivery before purchase
SELECT
    SUM(IF(order_delivered_carrier_date <> '' AND order_approved_at <> ''
           AND order_delivered_carrier_date < order_approved_at, 1, 0))        AS carrier_before_approval,   -- 1,359
    SUM(IF(order_delivered_customer_date <> ''
           AND order_delivered_customer_date < order_purchase_timestamp, 1, 0)) AS delivered_before_purchase -- 0
FROM stg_orders;

-- 3.9 Suspicious payment values
SELECT payment_type, COUNT(*) AS zero_value_payments
FROM stg_order_payments
WHERE CAST(payment_value AS DECIMAL(10,2)) = 0
GROUP BY payment_type;                                              -- 9 zero-value payments

SELECT 'Step 3 complete: data quality profiled' AS status;
