-- =====================================================================
-- STEP 5 · Explore the data
-- Topics: SELECT *, named columns, AS, COUNT, COUNT(DISTINCT), DISTINCT,
--         WHERE, comparison operators, AND / OR with brackets, IN, BETWEEN,
--         LIKE (% and _), IS NULL, ORDER BY ASC/DESC, LIMIT, OFFSET, EXPLAIN
-- =====================================================================
USE olist_audit;

-- 5.1 Preview a table (always LIMIT on big tables)
SELECT * FROM orders LIMIT 5;

-- 5.2 Named columns with readable headers
SELECT order_id     AS order_no,
       order_status AS status,
       purchase_ts  AS purchased_at
FROM orders
LIMIT 5;

-- 5.3 How big is the population?
SELECT COUNT(*)                           AS orders,
       COUNT(DISTINCT customer_id)        AS customer_ids,
       (SELECT COUNT(DISTINCT customer_unique_id) FROM customers) AS unique_customers
FROM orders;

-- 5.4 Which values exist?
SELECT DISTINCT payment_type FROM order_payments ORDER BY payment_type;
SELECT DISTINCT state FROM customers ORDER BY state;                            -- 27 states

-- 5.5 Comparison operators and AND / OR (brackets matter)
SELECT order_id, order_item_id, price, freight_value
FROM order_items
WHERE price >= 1000 AND (freight_value = 0 OR freight_value > 200)
ORDER BY price DESC
LIMIT 10;

-- 5.6 IN and BETWEEN
SELECT COUNT(*) AS open_pipeline_orders
FROM orders
WHERE order_status IN ('created', 'approved', 'invoiced', 'processing', 'shipped');

SELECT COUNT(*) AS orders_2017
FROM orders
WHERE purchase_ts BETWEEN '2017-01-01 00:00:00' AND '2017-12-31 23:59:59';    -- 45,101

-- 5.7 LIKE: categories about furniture ("moveis") and with exactly 4 letters before "_"
SELECT DISTINCT category_name
FROM products
WHERE category_name LIKE '%moveis%'
ORDER BY category_name;

SELECT DISTINCT category_name
FROM products
WHERE category_name LIKE '____\_%'                     -- 4 characters, then a literal underscore
ORDER BY category_name;

-- 5.8 IS NULL: products without a category; delivered orders without a delivery date
SELECT COUNT(*) AS products_without_category FROM products WHERE category_name IS NULL;   -- 610

SELECT order_id, purchase_ts, order_status
FROM orders
WHERE order_status = 'delivered' AND delivered_customer_ts IS NULL;                      -- 8

-- 5.9 ORDER BY + LIMIT: top 5 / bottom 5 single items by price
SELECT order_id, product_id, price FROM order_items ORDER BY price DESC, order_id LIMIT 5;
SELECT order_id, product_id, price FROM order_items ORDER BY price ASC,  order_id LIMIT 5;

-- 5.10 OFFSET: page 2 of the most expensive items, and the 3rd most expensive item
SELECT order_id, price FROM order_items ORDER BY price DESC, order_id LIMIT 5 OFFSET 5;
SELECT order_id, price FROM order_items ORDER BY price DESC, order_id LIMIT 1 OFFSET 2;

-- 5.11 EXPLAIN: the purchase-date filter uses index idx_orders_purchase
EXPLAIN
SELECT COUNT(*) FROM orders
WHERE purchase_ts BETWEEN '2017-12-01' AND '2017-12-31 23:59:59';

SELECT 'Step 5 complete: exploration' AS status;
