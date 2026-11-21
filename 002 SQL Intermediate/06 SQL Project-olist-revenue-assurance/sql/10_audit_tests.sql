-- =====================================================================
-- STEP 10 · Revenue assurance tests (FY2017 audit)
-- Each test answers one audit question and lists the items to follow up.
-- Topics: everything so far, combined.
-- =====================================================================
USE olist_audit;

SET @fy_start = '2017-01-01';
SET @fy_end   = '2017-12-31 23:59:59';

-- T1 · ACCURACY: do payments equal items + freight for delivered orders?
--      (aggregate first to avoid fan-out; tolerance 1.00 BRL)
SELECT COUNT(*)                                     AS orders_compared,
       SUM(IF(ABS(IFNULL(pd.paid, 0) - b.billed) > 1, 1, 0))  AS orders_with_difference,
       SUM(IF(IFNULL(pd.paid, 0) - b.billed > 1,  IFNULL(pd.paid, 0) - b.billed, 0)) AS paid_more,
       SUM(IF(IFNULL(pd.paid, 0) - b.billed < -1, IFNULL(pd.paid, 0) - b.billed, 0)) AS paid_less
FROM orders o
JOIN (SELECT order_id, SUM(price + freight_value) AS billed
      FROM order_items GROUP BY order_id) b      ON b.order_id  = o.order_id
LEFT JOIN (SELECT order_id, SUM(payment_value) AS paid
      FROM order_payments GROUP BY order_id) pd  ON pd.order_id = o.order_id
WHERE o.order_status = 'delivered';
-- Expected: 96,478 compared · 310 with a difference · +3,036.57 · -5,040.74

-- T1 detail: the 5 largest differences
SELECT o.order_id, b.billed, IFNULL(pd.paid, 0) AS paid,
       IFNULL(pd.paid, 0) - b.billed AS difference
FROM orders o
JOIN (SELECT order_id, SUM(price + freight_value) AS billed
      FROM order_items GROUP BY order_id) b      ON b.order_id  = o.order_id
LEFT JOIN (SELECT order_id, SUM(payment_value) AS paid
      FROM order_payments GROUP BY order_id) pd  ON pd.order_id = o.order_id
WHERE o.order_status = 'delivered'
  AND ABS(IFNULL(pd.paid, 0) - b.billed) > 1
ORDER BY ABS(IFNULL(pd.paid, 0) - b.billed) DESC
LIMIT 5;

-- T2 · OCCURRENCE: delivered orders with no payment at all
SELECT o.order_id, o.purchase_ts, o.order_status
FROM orders o
LEFT JOIN order_payments p ON p.order_id = o.order_id
WHERE p.order_id IS NULL;                                          -- 1 delivered order

-- T3 · REFUNDS: canceled / unavailable orders that were paid
SELECT o.order_status,
       COUNT(DISTINCT o.order_id) AS orders,
       SUM(p.payment_value)       AS paid_brl
FROM orders o
JOIN order_payments p ON p.order_id = o.order_id
WHERE o.order_status IN ('canceled', 'unavailable')
GROUP BY o.order_status;                                           -- 1,234 orders · 269,735.11 BRL

-- T4 · CUT-OFF: revenue on purchase date vs on delivery date for FY2017
SELECT SUM(IF(o.purchase_ts           BETWEEN @fy_start AND @fy_end, i.price, 0)) AS revenue_purchase_basis,
       SUM(IF(o.delivered_customer_ts BETWEEN @fy_start AND @fy_end, i.price, 0)) AS revenue_delivery_basis,
       SUM(IF(o.purchase_ts           BETWEEN @fy_start AND @fy_end, i.price, 0))
     - SUM(IF(o.delivered_customer_ts BETWEEN @fy_start AND @fy_end, i.price, 0)) AS difference
FROM orders o
JOIN order_items i ON i.order_id = o.order_id
WHERE o.order_status = 'delivered';
-- 5,962,902.01 vs 5,612,817.85 → 350,084.16

-- T4 detail: FY2017 orders delivered after year-end
SELECT COUNT(DISTINCT o.order_id) AS orders,
       SUM(i.price)               AS revenue_brl,
       MAX(o.delivered_customer_ts) AS latest_delivery
FROM orders o
JOIN order_items i ON i.order_id = o.order_id
WHERE o.order_status = 'delivered'
  AND o.purchase_ts BETWEEN @fy_start AND @fy_end
  AND o.delivered_customer_ts > @fy_end;                           -- 2,496 orders · 349,787.86

-- T5 · TIMESTAMP INTEGRITY: events in an impossible or missing order
SELECT
    (SELECT COUNT(*) FROM orders WHERE order_status = 'delivered' AND delivered_customer_ts IS NULL) AS delivered_no_date,
    (SELECT COUNT(*) FROM orders WHERE order_status = 'delivered' AND approved_ts IS NULL)           AS delivered_not_approved,
    (SELECT COUNT(*) FROM orders WHERE delivered_carrier_ts < approved_ts)                           AS shipped_before_approval;
-- 8 · 14 · 1,359

-- T6 · PRICING: items sold at more than 2× the seller's own average for that product
SELECT COUNT(*) AS items_over_2x_avg
FROM order_items i
JOIN (SELECT seller_id, product_id, AVG(price) AS avg_price
      FROM order_items
      GROUP BY seller_id, product_id
      HAVING COUNT(*) >= 5) sp
  ON sp.seller_id = i.seller_id AND sp.product_id = i.product_id
WHERE i.price > sp.avg_price * 2;                                 -- 8 items

-- T7 · PAYMENTS: zero-value and undefined payment methods
SELECT payment_type, COUNT(*) AS payments, SUM(payment_value) AS value_brl
FROM order_payments
WHERE payment_value = 0 OR payment_type = 'not_defined'
GROUP BY payment_type;                                             -- voucher 6 · not_defined 3

-- T8 · SERVICE: deliveries more than 30 days late (claims / refunds risk)
SELECT COUNT(*) AS orders_30plus_days_late
FROM orders
WHERE order_status = 'delivered'
  AND DATEDIFF(delivered_customer_ts, estimated_delivery_date) > 30;   -- 345

-- T9 · TEST SUMMARY
SELECT 'T1 Payment ≠ items + freight'   AS test, COUNT(*) AS items, SUM(diff) AS value_brl
FROM (SELECT IFNULL(pd.paid, 0) - b.billed AS diff
      FROM orders o
      JOIN (SELECT order_id, SUM(price + freight_value) AS billed FROM order_items GROUP BY order_id) b ON b.order_id = o.order_id
      LEFT JOIN (SELECT order_id, SUM(payment_value) AS paid FROM order_payments GROUP BY order_id) pd ON pd.order_id = o.order_id
      WHERE o.order_status = 'delivered') x
WHERE ABS(diff) > 1
UNION ALL
SELECT 'T3 Paid but canceled/unavailable', COUNT(DISTINCT o.order_id), SUM(p.payment_value)
FROM orders o JOIN order_payments p ON p.order_id = o.order_id
WHERE o.order_status IN ('canceled', 'unavailable')
UNION ALL
SELECT 'T4 FY2017 sales delivered in 2018', COUNT(DISTINCT o.order_id), SUM(i.price)
FROM orders o JOIN order_items i ON i.order_id = o.order_id
WHERE o.order_status = 'delivered' AND o.purchase_ts BETWEEN @fy_start AND @fy_end
  AND o.delivered_customer_ts > @fy_end;

SELECT 'Step 10 complete: audit tests' AS status;
