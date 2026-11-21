-- =====================================================================
-- STEP 7 · Joins
-- Topics: table aliases, INNER JOIN (= JOIN), LEFT JOIN + IS NULL,
--         RIGHT JOIN, FULL JOIN with UNION, JOIN on two columns with AND,
--         CROSS JOIN + CONCAT, SELF JOIN
-- =====================================================================
USE olist_audit;

-- 7.1 INNER JOIN: orders with customer details (JOIN alone means INNER JOIN)
SELECT o.order_id, o.purchase_ts, c.city, c.state
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
LIMIT 5;

-- 7.2 LEFT JOIN + IS NULL: orders with no items (anti-join)
SELECT o.order_status, COUNT(*) AS orders_without_items
FROM orders o
LEFT JOIN order_items i ON i.order_id = o.order_id
WHERE i.order_id IS NULL
GROUP BY o.order_status
ORDER BY orders_without_items DESC;                       -- 775 in total

-- 7.3 LEFT JOIN: products and the English category (NULL where untranslated)
SELECT p.category_name, t.category_name_en, COUNT(*) AS products
FROM products p
LEFT JOIN category_translation t ON t.category_name = p.category_name
WHERE t.category_name IS NULL
GROUP BY p.category_name, t.category_name_en;              -- NULL (610), pc_gamer, portateis_…

-- 7.4 RIGHT JOIN: every order, matched to its payments (orders without payment show NULL)
SELECT o.order_id, o.order_status, p.payment_value
FROM order_payments p
RIGHT JOIN orders o ON o.order_id = p.order_id
WHERE p.order_id IS NULL;                                  -- 1 order without any payment

-- 7.5 FULL JOIN (MySQL: LEFT JOIN UNION RIGHT JOIN): categories used vs translated
SELECT p.category_name AS used_category, t.category_name AS translated_category
FROM (SELECT DISTINCT category_name FROM products WHERE category_name IS NOT NULL) p
LEFT JOIN category_translation t ON t.category_name = p.category_name
WHERE t.category_name IS NULL
UNION
SELECT p.category_name, t.category_name
FROM (SELECT DISTINCT category_name FROM products WHERE category_name IS NOT NULL) p
RIGHT JOIN category_translation t ON t.category_name = p.category_name
WHERE p.category_name IS NULL;
-- 2 used but not translated · 0 translated but never used

-- 7.6 JOIN on two columns with AND: each item vs the seller's average price for that product
SELECT i.order_id, i.seller_id, i.product_id, i.price,
       sp.avg_price,
       ROUND((i.price / sp.avg_price - 1) * 100, 1) AS pct_vs_seller_avg
FROM order_items i
JOIN (SELECT seller_id, product_id, AVG(price) AS avg_price, COUNT(*) AS times_sold
      FROM order_items
      GROUP BY seller_id, product_id
      HAVING COUNT(*) >= 5) sp
  ON sp.seller_id  = i.seller_id
 AND sp.product_id = i.product_id                          -- two-column join
WHERE i.price > sp.avg_price * 2
ORDER BY pct_vs_seller_avg DESC
LIMIT 10;

-- 7.7 CROSS JOIN: every state × every month of FY2017 (no common column)
--     then LEFT JOIN the orders to find months with no sales
SELECT CONCAT(s.state, ' · ', m.month_label) AS state_month
FROM (SELECT DISTINCT state FROM customers) s
CROSS JOIN (SELECT DISTINCT DATE_FORMAT(purchase_ts, '%Y-%m') AS month_label
            FROM orders WHERE YEAR(purchase_ts) = 2017) m
LEFT JOIN (SELECT c.state, DATE_FORMAT(o.purchase_ts, '%Y-%m') AS month_label
           FROM orders o JOIN customers c ON c.customer_id = o.customer_id
           WHERE YEAR(o.purchase_ts) = 2017
           GROUP BY c.state, month_label) sales
       ON sales.state = s.state AND sales.month_label = m.month_label
WHERE sales.state IS NULL
ORDER BY state_month;                -- grid of 27 states × 12 months = 324 cells; 6 cells had no orders

-- 7.8 SELF JOIN: the same real customer (customer_unique_id) ordering again within 30 days
SELECT COUNT(*) AS repeat_pairs_within_30_days
FROM customers c1
JOIN orders o1    ON o1.customer_id = c1.customer_id
JOIN customers c2 ON c2.customer_unique_id = c1.customer_unique_id
                 AND c2.customer_id <> c1.customer_id     -- another order id, same person
JOIN orders o2    ON o2.customer_id = c2.customer_id
WHERE o2.purchase_ts > o1.purchase_ts
  AND o2.purchase_ts <= DATE_ADD(o1.purchase_ts, INTERVAL 30 DAY);

SELECT 'Step 7 complete: joins' AS status;
