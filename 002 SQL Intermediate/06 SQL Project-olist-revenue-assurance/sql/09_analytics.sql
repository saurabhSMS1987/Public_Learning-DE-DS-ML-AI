-- =====================================================================
-- STEP 9 · Analytics on tables
-- Topics: merge tables for insight, GROUP BY, % of total (CROSS JOIN to a
--         one-row total), Top N / Bottom N (ORDER BY + LIMIT), period
--         comparison with IF, NULLIF in ratios, CASE buckets, HAVING
-- =====================================================================
USE olist_audit;

SET @fy_start = '2017-01-01';
SET @fy_end   = '2017-12-31 23:59:59';

-- Helper table: one row per delivered FY2017 item with its category in English
DROP TABLE IF EXISTS fy2017_sales;
CREATE TABLE fy2017_sales AS
SELECT o.order_id, o.purchase_ts, o.customer_id, i.seller_id, i.product_id,
       COALESCE(t.category_name_en, p.category_name, 'uncategorised') AS category,
       i.price, i.freight_value
FROM orders o
JOIN order_items i ON i.order_id   = o.order_id
JOIN products    p ON p.product_id = i.product_id
LEFT JOIN category_translation t ON t.category_name = p.category_name
WHERE o.order_status = 'delivered'
  AND o.purchase_ts BETWEEN @fy_start AND @fy_end;

SELECT COUNT(*) AS items, SUM(price) AS revenue_brl FROM fy2017_sales;    -- 49,556 · 5,962,902.01

-- 9.1 Monthly revenue trend FY2017
SELECT DATE_FORMAT(purchase_ts, '%Y-%m') AS sales_month,
       COUNT(DISTINCT order_id)          AS orders,
       SUM(price)                        AS revenue_brl
FROM fy2017_sales
GROUP BY sales_month
ORDER BY sales_month;                    -- November peak (Black Friday)

-- 9.2 Top 10 categories with % of total revenue
SELECT s.category,
       SUM(s.price)                                 AS revenue_brl,
       ROUND(SUM(s.price) / t.total * 100, 1)       AS pct_of_revenue
FROM fy2017_sales s
CROSS JOIN (SELECT SUM(price) AS total FROM fy2017_sales) t
GROUP BY s.category, t.total
ORDER BY revenue_brl DESC
LIMIT 10;

-- 9.3 Bottom 5 categories (with at least 10 items sold)
SELECT category, COUNT(*) AS items, SUM(price) AS revenue_brl
FROM fy2017_sales
GROUP BY category
HAVING COUNT(*) >= 10
ORDER BY revenue_brl ASC
LIMIT 5;

-- 9.4 Seller concentration: share of the top 10 sellers
SELECT SUM(top10.revenue)                                   AS top10_revenue_brl,
       ROUND(SUM(top10.revenue) / (SELECT SUM(price) FROM fy2017_sales) * 100, 1) AS top10_pct
FROM (SELECT seller_id, SUM(price) AS revenue
      FROM fy2017_sales
      GROUP BY seller_id
      ORDER BY revenue DESC
      LIMIT 10) top10;

-- 9.5 Growth: Jan–Aug 2018 vs Jan–Aug 2017 (same months, fair comparison)
SELECT SUM(IF(o.purchase_ts BETWEEN '2017-01-01' AND '2017-08-31 23:59:59', i.price, 0)) AS jan_aug_2017,
       SUM(IF(o.purchase_ts BETWEEN '2018-01-01' AND '2018-08-31 23:59:59', i.price, 0)) AS jan_aug_2018,
       ROUND((SUM(IF(o.purchase_ts BETWEEN '2018-01-01' AND '2018-08-31 23:59:59', i.price, 0))
            / NULLIF(SUM(IF(o.purchase_ts BETWEEN '2017-01-01' AND '2017-08-31 23:59:59', i.price, 0)), 0)
            - 1) * 100, 1)                                                                 AS growth_pct
FROM orders o
JOIN order_items i ON i.order_id = o.order_id
WHERE o.order_status = 'delivered';

-- 9.6 Payment mix: share of payment value by method (all orders)
SELECT p.payment_type,
       COUNT(*)                                        AS payments,
       SUM(p.payment_value)                            AS value_brl,
       ROUND(SUM(p.payment_value) / t.total * 100, 1)  AS pct_of_value,
       ROUND(AVG(p.payment_installments), 1)           AS avg_installments
FROM order_payments p
CROSS JOIN (SELECT SUM(payment_value) AS total FROM order_payments) t
GROUP BY p.payment_type, t.total
ORDER BY value_brl DESC;

-- 9.7 Delivery performance by customer state: late-delivery rate, worst 5 states
SELECT c.state,
       COUNT(*)                                                               AS delivered_orders,
       SUM(IF(DATE(o.delivered_customer_ts) > o.estimated_delivery_date, 1, 0)) AS late_orders,
       ROUND(SUM(IF(DATE(o.delivered_customer_ts) > o.estimated_delivery_date, 1, 0))
             / COUNT(*) * 100, 1)                                             AS late_pct,
       ROUND(AVG(DATEDIFF(o.delivered_customer_ts, o.purchase_ts)), 1)        AS avg_days_to_deliver
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
  AND o.delivered_customer_ts IS NOT NULL
GROUP BY c.state
HAVING COUNT(*) >= 100
ORDER BY late_pct DESC
LIMIT 5;

-- 9.8 Average order value and items per order, by year
SELECT YEAR(o.purchase_ts)                           AS purchase_year,
       ROUND(SUM(b.order_value) / COUNT(*), 2)       AS avg_order_value,
       ROUND(SUM(b.items) / COUNT(*), 2)             AS avg_items_per_order
FROM orders o
JOIN (SELECT order_id, SUM(price) AS order_value, COUNT(*) AS items
      FROM order_items GROUP BY order_id) b ON b.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY purchase_year
ORDER BY purchase_year;

SELECT 'Step 9 complete: analytics' AS status;
