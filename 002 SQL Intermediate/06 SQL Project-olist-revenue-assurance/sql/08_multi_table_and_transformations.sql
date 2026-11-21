-- =====================================================================
-- STEP 8 · Joining more than two tables, and transformation functions
-- Topics: chained joins (5 tables), GROUP_CONCAT, the fan-out trap and the
--         "aggregate first, then join" fix, CONCAT, UPPER, LOWER, TRIM, LEFT,
--         RIGHT, SUBSTRING, REPLACE, LPAD, ROUND, ABS, MOD, DATE_FORMAT,
--         DATE_ADD, DATEDIFF, DAYNAME, MONTH, CAST, IFNULL, COALESCE, NULLIF
-- =====================================================================
USE olist_audit;

-- 8.1 Five tables in one query: order → customer → items → product → category (EN)
SELECT o.order_id,
       c.state                                       AS customer_state,
       i.order_item_id,
       COALESCE(t.category_name_en, p.category_name, 'uncategorised') AS category,
       i.price
FROM orders o
JOIN customers   c ON c.customer_id   = o.customer_id
JOIN order_items i ON i.order_id      = o.order_id
JOIN products    p ON p.product_id    = i.product_id
LEFT JOIN category_translation t ON t.category_name = p.category_name
WHERE o.order_id = '8272b63d03f5f79c56e9e4120aec44ef'     -- an order with 21 lines
ORDER BY i.order_item_id
LIMIT 5;

-- 8.2 GROUP_CONCAT: all categories and payment types of an order on one row
SELECT o.order_id,
       COUNT(*)                                                         AS items,
       GROUP_CONCAT(DISTINCT COALESCE(t.category_name_en, p.category_name)
                    ORDER BY COALESCE(t.category_name_en, p.category_name)
                    SEPARATOR ', ')                                     AS categories
FROM orders o
JOIN order_items i ON i.order_id   = o.order_id
JOIN products    p ON p.product_id = i.product_id
LEFT JOIN category_translation t ON t.category_name = p.category_name
GROUP BY o.order_id
HAVING COUNT(DISTINCT p.category_name) >= 3
ORDER BY items DESC, o.order_id
LIMIT 5;

SELECT order_id,
       GROUP_CONCAT(CONCAT(payment_type, ' ', payment_value) ORDER BY payment_sequential SEPARATOR ' + ') AS payments
FROM order_payments
GROUP BY order_id
HAVING COUNT(*) = 4                       -- orders paid in 4 parts
ORDER BY order_id
LIMIT 3;

-- 8.3 ⚠️ Fan-out: joining items AND payments to orders multiplies rows
SELECT 'wrong: joined together' AS method,
       SUM(i.price + i.freight_value) AS billed,
       SUM(p.payment_value)           AS paid
FROM orders o
JOIN order_items i         ON i.order_id = o.order_id
LEFT JOIN order_payments p ON p.order_id = o.order_id
UNION ALL
-- Fix: aggregate each one-to-many table first, then join one row per order
SELECT 'right: aggregated first',
       SUM(b.billed),
       SUM(IFNULL(pd.paid, 0))
FROM orders o
JOIN (SELECT order_id, SUM(price + freight_value) AS billed
      FROM order_items GROUP BY order_id) b       ON b.order_id  = o.order_id
LEFT JOIN (SELECT order_id, SUM(payment_value) AS paid
      FROM order_payments GROUP BY order_id) pd   ON pd.order_id = o.order_id;

-- 8.4 Text functions
SELECT customer_id,
       UPPER(city)                                    AS city_upper,
       CONCAT(UPPER(LEFT(city, 1)), SUBSTRING(city, 2)) AS city_title,
       CONCAT(city, ' / ', state)                     AS city_state,
       LEFT(zip_code_prefix, 2)                       AS zip_region,
       RIGHT(customer_id, 6)                          AS id_suffix,
       REPLACE(city, ' ', '_')                        AS city_key,
       LPAD(zip_code_prefix, 8, '*')                  AS padded_demo,
       LOWER(TRIM('  São Paulo  '))                   AS trimmed_lower
FROM customers
LIMIT 5;

-- 8.5 Number functions
SELECT order_id, price, freight_value,
       ROUND(freight_value / price * 100, 1)          AS freight_pct_of_price,
       ABS(price - freight_value)                     AS abs_difference,
       MOD(price, 1) = 0                              AS whole_number_price
FROM order_items
WHERE price >= 500
LIMIT 5;

-- 8.6 Date functions
SELECT order_id,
       purchase_ts,
       DAYNAME(purchase_ts)                                  AS weekday,
       MONTH(purchase_ts)                                    AS month_no,
       DATE_FORMAT(purchase_ts, '%d.%m.%Y')                  AS purchase_ddmmyyyy,
       DATE_ADD(DATE(purchase_ts), INTERVAL 30 DAY)          AS purchase_plus_30,
       DATEDIFF(delivered_customer_ts, purchase_ts)          AS days_to_deliver,
       DATEDIFF(delivered_customer_ts, estimated_delivery_date) AS days_late
FROM orders
WHERE order_status = 'delivered' AND delivered_customer_ts IS NOT NULL
ORDER BY days_late DESC, order_id
LIMIT 5;

-- 8.7 Conversion and NULL functions
SELECT p.product_id,
       CAST(p.weight_g AS CHAR)                       AS weight_text,
       IFNULL(p.category_name, 'uncategorised')       AS category,
       COALESCE(t.category_name_en, p.category_name, 'uncategorised') AS category_en,
       NULLIF(p.photos_qty, 0)                        AS photos_or_null
FROM products p
LEFT JOIN category_translation t ON t.category_name = p.category_name
WHERE p.category_name IS NULL OR t.category_name IS NULL
LIMIT 5;

SELECT 'Step 8 complete: multi-table joins and transformation functions' AS status;
