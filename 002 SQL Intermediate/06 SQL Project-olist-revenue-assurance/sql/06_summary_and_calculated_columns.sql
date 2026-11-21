-- =====================================================================
-- STEP 6 · Summary analytics and calculated columns
-- Topics: SUM, COUNT, MIN, MAX, AVG, AS, GROUP BY, HAVING (vs WHERE),
--         derived columns, revenue, IF, CASE, YEAR, YEAR(CURDATE()),
--         fixed as-at date, currency conversion, unit conversion, ROUND
-- Audit year: FY2017 (calendar year). Revenue = item price of delivered orders.
-- =====================================================================
USE olist_audit;

SET @fy_start    = '2017-01-01';
SET @fy_end      = '2017-12-31 23:59:59';
SET @as_at       = '2017-12-31';          -- fixed as-at date: results never change
SET @usd_per_brl = 0.31;                  -- illustrative average 2017 rate (assumption)
SET @commission  = 0.10;                  -- illustrative marketplace commission (assumption)

-- 6.1 Headline summary for FY2017 (delivered orders)
SELECT COUNT(DISTINCT o.order_id)        AS orders,
       COUNT(*)                          AS items,
       SUM(i.price)                      AS revenue_brl,
       SUM(i.freight_value)              AS freight_brl,
       MIN(i.price)                      AS cheapest_item,
       MAX(i.price)                      AS dearest_item,
       ROUND(AVG(i.price), 2)            AS avg_item_price
FROM orders o
JOIN order_items i ON i.order_id = o.order_id
WHERE o.order_status = 'delivered'
  AND o.purchase_ts BETWEEN @fy_start AND @fy_end;

-- 6.2 GROUP BY: revenue per customer state, HAVING keeps states above 100,000 BRL
SELECT c.state,
       COUNT(DISTINCT o.order_id) AS orders,
       SUM(i.price)               AS revenue_brl
FROM orders o
JOIN customers   c ON c.customer_id = o.customer_id
JOIN order_items i ON i.order_id    = o.order_id
WHERE o.order_status = 'delivered'                       -- WHERE: rows
  AND o.purchase_ts BETWEEN @fy_start AND @fy_end
GROUP BY c.state
HAVING SUM(i.price) > 100000                             -- HAVING: groups
ORDER BY revenue_brl DESC;

-- 6.3 Derived columns: amount charged, estimated platform profit (commission),
--     revenue in USD (currency conversion), weight in kg (unit conversion)
SELECT i.order_id,
       i.price,
       i.freight_value,
       i.price + i.freight_value                    AS amount_charged_brl,
       ROUND(i.price * @commission, 2)              AS est_commission_brl,
       ROUND(i.price * (1 - @commission), 2)        AS seller_net_brl,
       ROUND((i.price + i.freight_value) * @usd_per_brl, 2) AS amount_charged_usd,
       p.weight_g,
       ROUND(p.weight_g / 1000, 2)                  AS weight_kg
FROM order_items i
JOIN products p ON p.product_id = i.product_id
LIMIT 5;

-- 6.3b Estimated FY2017 platform profit from commission
SELECT SUM(i.price)                          AS revenue_brl,
       ROUND(SUM(i.price) * @commission, 2)  AS est_commission_brl
FROM orders o
JOIN order_items i ON i.order_id = o.order_id
WHERE o.order_status = 'delivered'
  AND o.purchase_ts BETWEEN @fy_start AND @fy_end;            -- 5,962,902.01 · 596,290.20

-- 6.4 IF: two outcomes. Was the order delivered on time?
SELECT IF(DATE(delivered_customer_ts) <= estimated_delivery_date, 'On time', 'Late') AS delivery,
       COUNT(*) AS orders
FROM orders
WHERE order_status = 'delivered'
  AND delivered_customer_ts IS NOT NULL
GROUP BY delivery;

-- 6.5 CASE: more than two outcomes. Order value bands
SELECT CASE
           WHEN order_value >= 1000 THEN '4 · 1,000+'
           WHEN order_value >= 200  THEN '3 · 200-999'
           WHEN order_value >= 50   THEN '2 · 50-199'
           ELSE                          '1 · under 50'
       END                       AS value_band,
       COUNT(*)                  AS orders,
       SUM(order_value)          AS value_brl
FROM (SELECT order_id, SUM(price) AS order_value FROM order_items GROUP BY order_id) v
GROUP BY value_band
ORDER BY value_band;

-- 6.6 YEAR and a year-by-year view
SELECT YEAR(o.purchase_ts) AS purchase_year,
       COUNT(DISTINCT o.order_id) AS orders,
       SUM(i.price)        AS revenue_brl
FROM orders o
JOIN order_items i ON i.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY YEAR(o.purchase_ts)
ORDER BY purchase_year;

-- 6.7 Current year vs fixed as-at date
SELECT YEAR(CURDATE())                         AS current_year,         -- changes over time
       YEAR(CURDATE()) - YEAR(MAX(purchase_ts)) AS years_since_last_order,
       YEAR(@as_at)                            AS audit_year,           -- never changes
       DATEDIFF(@as_at, MIN(purchase_ts))      AS days_of_history_at_year_end
FROM orders;

SELECT 'Step 6 complete: summary analytics and calculated columns' AS status;
