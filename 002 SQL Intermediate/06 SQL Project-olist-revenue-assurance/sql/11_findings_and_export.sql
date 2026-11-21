-- =====================================================================
-- STEP 11 · Record findings, propose the adjustment, export, clean up
-- Topics: CREATE TABLE (AUTO_INCREMENT, DEFAULT), INSERT … VALUES,
--         INSERT … SELECT, UPDATE, DELETE, transactions (COMMIT / ROLLBACK),
--         ALTER TABLE, CREATE TABLE … AS SELECT / LIKE, TRUNCATE, DROP,
--         SELECT … INTO OUTFILE
-- =====================================================================
USE olist_audit;

SET @fy_start = '2017-01-01';
SET @fy_end   = '2017-12-31 23:59:59';

-- 11.1 Findings log
DROP TABLE IF EXISTS audit_findings;
CREATE TABLE audit_findings (
    finding_id   INT AUTO_INCREMENT PRIMARY KEY,
    test_id      VARCHAR(3)     NOT NULL,
    order_id     CHAR(32)       NULL,
    amount_brl   DECIMAL(12,2)  NOT NULL DEFAULT 0,
    description  VARCHAR(100)   NOT NULL,
    status       VARCHAR(12)    NOT NULL DEFAULT 'OPEN',
    created_at   DATETIME       DEFAULT CURRENT_TIMESTAMP
);

-- 11.2 INSERT … SELECT: one row per exception from the tests
INSERT INTO audit_findings (test_id, order_id, amount_brl, description)
SELECT 'T2', o.order_id, 0, 'Delivered order with no payment'
FROM orders o
LEFT JOIN order_payments p ON p.order_id = o.order_id
WHERE p.order_id IS NULL;

INSERT INTO audit_findings (test_id, order_id, amount_brl, description)
SELECT 'T3', o.order_id, SUM(p.payment_value), CONCAT('Paid but ', o.order_status)
FROM orders o
JOIN order_payments p ON p.order_id = o.order_id
WHERE o.order_status IN ('canceled', 'unavailable')
GROUP BY o.order_id, o.order_status;

INSERT INTO audit_findings (test_id, order_id, amount_brl, description)
SELECT 'T5', order_id, 0, 'Delivered without a delivery date'
FROM orders
WHERE order_status = 'delivered' AND delivered_customer_ts IS NULL;

-- 11.3 INSERT … VALUES: a summary finding written by the auditor
INSERT INTO audit_findings (test_id, amount_brl, description)
VALUES ('T4', 349787.86, 'FY2017 sales delivered in 2018: revenue recognised too early');

SELECT test_id, COUNT(*) AS findings, SUM(amount_brl) AS amount_brl
FROM audit_findings
GROUP BY test_id
ORDER BY test_id;                                        -- T2 1 · T3 1,234 · T4 1 · T5 8

-- 11.4 UPDATE inside a transaction, checked before COMMIT
START TRANSACTION;
UPDATE audit_findings
SET status = 'CONFIRMED'
WHERE finding_id > 0 AND test_id IN ('T2', 'T4');        -- key in WHERE: safe-update friendly
SELECT status, COUNT(*) AS findings FROM audit_findings GROUP BY status;
COMMIT;

-- 11.5 ROLLBACK: an UPDATE that hits every row is undone
START TRANSACTION;
UPDATE audit_findings SET status = 'CLOSED' WHERE finding_id > 0;
SELECT COUNT(*) AS closed_before_rollback FROM audit_findings WHERE status = 'CLOSED';   -- 1,244
ROLLBACK;
SELECT COUNT(*) AS closed_after_rollback FROM audit_findings WHERE status = 'CLOSED';    -- 0

-- 11.6 DELETE: small refunds under 10 BRL are below the reporting threshold
DELETE FROM audit_findings
WHERE finding_id > 0 AND test_id = 'T3' AND amount_brl < 10;
SELECT COUNT(*) AS findings_after_delete FROM audit_findings;

-- 11.7 ALTER TABLE: add an owner column
ALTER TABLE audit_findings ADD COLUMN owner VARCHAR(30) NULL AFTER status;
UPDATE audit_findings SET owner = 'Revenue team' WHERE finding_id > 0 AND status = 'CONFIRMED';

-- 11.8 Proposed adjustment (CREATE TABLE … AS SELECT): FY2017 revenue on delivery basis
DROP TABLE IF EXISTS proposed_adjustment;
CREATE TABLE proposed_adjustment AS
SELECT 'Defer FY2017 sales delivered after year-end' AS description,
       SUM(i.price)                                  AS revenue_overstatement_brl
FROM orders o
JOIN order_items i ON i.order_id = o.order_id
WHERE o.order_status = 'delivered'
  AND o.purchase_ts BETWEEN @fy_start AND @fy_end
  AND o.delivered_customer_ts > @fy_end;
SELECT * FROM proposed_adjustment;                       -- 349,787.86 BRL

-- 11.9 Check the backup from step 4 still matches, then clean up
SELECT (SELECT COUNT(*) FROM orders) AS orders_now, (SELECT COUNT(*) FROM orders_bkp) AS orders_backup;
CREATE TABLE scratch_findings LIKE audit_findings;       -- copy the structure
INSERT INTO scratch_findings SELECT * FROM audit_findings;
TRUNCATE TABLE scratch_findings;                         -- empty it (cannot be rolled back)
DROP TABLE scratch_findings, orders_bkp;                 -- delete them

-- 11.10 Final findings view (top 10 by amount)
SELECT finding_id, test_id, order_id, amount_brl, status, owner, description
FROM audit_findings
ORDER BY amount_brl DESC, finding_id
LIMIT 10;

-- 11.11 Export (optional): writes a CSV on the database server, only into the
--       secure_file_priv folder (SHOW VARIABLES LIKE 'secure_file_priv';).
--       In MySQL Workbench you can instead use the result grid's Export button.
-- SELECT 'finding_id','test_id','order_id','amount_brl','status','description'
-- UNION ALL
-- SELECT finding_id, test_id, IFNULL(order_id, ''), amount_brl, status, description FROM audit_findings
-- INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.4/Uploads/audit_findings.csv'
-- FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
-- LINES TERMINATED BY '\r\n';

SELECT 'Step 11 complete: findings recorded. Project finished.' AS status;
