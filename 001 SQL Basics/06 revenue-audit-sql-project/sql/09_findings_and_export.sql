-- =====================================================================
-- STEP 9 · Record findings, propose the adjustment, export
-- Topics: CREATE TABLE (AUTO_INCREMENT, DEFAULT), INSERT ... SELECT,
--         INSERT ... VALUES, UPDATE, DELETE, transactions (ROLLBACK / COMMIT),
--         ALTER TABLE, CREATE TABLE ... AS SELECT, SELECT ... INTO OUTFILE
-- =====================================================================
USE revenue_audit;

-- 9.1 Findings log
DROP TABLE IF EXISTS audit_findings;
CREATE TABLE audit_findings (
    finding_id  INT AUTO_INCREMENT PRIMARY KEY,
    test_id     VARCHAR(4)     NOT NULL,
    vbeln       VARCHAR(10)    NOT NULL,
    kunag       VARCHAR(10)    NOT NULL,
    amount      DECIMAL(15,2)  NOT NULL,
    description VARCHAR(100)   NOT NULL,
    status      VARCHAR(12)    NOT NULL DEFAULT 'OPEN',
    created_at  DATETIME       DEFAULT CURRENT_TIMESTAMP
);

-- 9.2 INSERT ... SELECT: load exceptions from the tests
INSERT INTO audit_findings (test_id, vbeln, kunag, amount, description)
SELECT 'T1', vgbel, kunag, -netwr, 'Invoice reversed by credit memo after year-end'
FROM billing_lines
WHERE fkart = 'G2' AND fkdat >= '2027-01-01'
  AND vgbel IN (SELECT vbeln FROM billing_lines WHERE fkdat <= '2026-12-31');

INSERT INTO audit_findings (test_id, vbeln, kunag, amount, description)
SELECT 'T6', vbeln, kunag, netwr, 'Billing document dated on a weekend'
FROM billing_lines
WHERE DAYOFWEEK(fkdat) IN (1, 7);

INSERT INTO audit_findings (test_id, vbeln, kunag, amount, description)
SELECT 'T7', vbeln, kunag, netwr, 'Zero-value invoice line'
FROM billing_lines
WHERE fkart = 'F2' AND netpr = 0;

-- 9.3 INSERT ... VALUES: a manual note
INSERT INTO audit_findings (test_id, vbeln, kunag, amount, description)
VALUES ('T2', '0090000545', '0000100020', 355800.00, 'New customer: 3 invoices on 29-31 Dec, created 15 Dec');

SELECT test_id, COUNT(*) AS findings, SUM(amount) AS amount
FROM audit_findings GROUP BY test_id ORDER BY test_id;        -- T1 2, T2 1, T6 2, T7 3

-- 9.4 UPDATE inside a transaction, checked before COMMIT
START TRANSACTION;
UPDATE audit_findings SET status = 'CONFIRMED'
WHERE finding_id > 0 AND test_id IN ('T1', 'T2');   -- key in WHERE: allowed in Workbench safe-update mode
SELECT status, COUNT(*) AS findings FROM audit_findings GROUP BY status;   -- CONFIRMED 3, OPEN 5
COMMIT;

-- 9.5 ROLLBACK demo: an accidental update without the right WHERE is undone
START TRANSACTION;
UPDATE audit_findings SET status = 'CLOSED' WHERE finding_id > 0;         -- oops: every row
SELECT COUNT(*) AS closed_rows FROM audit_findings WHERE status = 'CLOSED';
ROLLBACK;
SELECT COUNT(*) AS closed_rows_after_rollback FROM audit_findings WHERE status = 'CLOSED';   -- 0

-- 9.6 DELETE: zero-value lines confirmed as approved free samples are cleared
DELETE FROM audit_findings WHERE finding_id > 0 AND test_id = 'T7';
SELECT COUNT(*) AS remaining_findings FROM audit_findings;                -- 5

-- 9.7 ALTER TABLE: add an owner column for follow-up
ALTER TABLE audit_findings ADD COLUMN owner VARCHAR(30) NULL AFTER status;
UPDATE audit_findings SET owner = 'Revenue team' WHERE finding_id > 0 AND status = 'CONFIRMED';

-- 9.8 Proposed audit adjustment: reverse 2026 revenue for the cut-off finding
CREATE TABLE proposed_adjustment AS
SELECT 'Reverse FY2026 revenue: sales cancelled in January 2027' AS description,
       SUM(-netwr) AS revenue_overstatement
FROM billing_lines
WHERE fkart = 'G2' AND fkdat >= '2027-01-01'
  AND vgbel IN (SELECT vbeln FROM billing_lines WHERE fkdat <= '2026-12-31');
SELECT * FROM proposed_adjustment;                                         -- 245,400.00

-- 9.9 Final view of the findings
SELECT finding_id, test_id, vbeln, kunag, amount, status, owner, description
FROM audit_findings
ORDER BY finding_id;

-- 9.10 Export (optional): writes a CSV on the database server.
--      Works only into the folder shown by SHOW VARIABLES LIKE 'secure_file_priv';
--      Uncomment and edit the path to use. Alternatively, export the result grid
--      of 9.9 from MySQL Workbench (Export button → CSV).
-- SELECT 'FINDING_ID','TEST_ID','VBELN','KUNAG','AMOUNT','STATUS'
-- UNION ALL
-- SELECT finding_id, test_id, vbeln, kunag, amount, status FROM audit_findings
-- INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.4/Uploads/audit_findings.csv'
-- FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
-- LINES TERMINATED BY '\r\n';

SELECT 'Step 9 complete: findings recorded. Project finished.' AS status;
