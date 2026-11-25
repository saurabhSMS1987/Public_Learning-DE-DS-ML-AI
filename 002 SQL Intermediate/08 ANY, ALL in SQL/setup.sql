-- =====================================================================
-- Setup: create the three operating expense tables and load the sample data.
-- Run from this folder with the mysql command-line client:
--   mysql --local-infile=1 -u root -p < setup.sql
-- In MySQL Workbench: replace each 'data/...' path with the full path
-- (forward slashes) and enable OPT_LOCAL_INFILE=1 on the connection.
-- =====================================================================
CREATE DATABASE IF NOT EXISTS audit_fy2026;
USE audit_fy2026;

DROP TABLE IF EXISTS ox_expenses, ox_vendors, ox_approvers;

-- Approvers and their approval limits (delegation of authority)
CREATE TABLE ox_approvers (
    emp_id          VARCHAR(5)     NOT NULL,
    name            VARCHAR(40)    NOT NULL,
    title           VARCHAR(40)    NOT NULL,
    approval_limit  DECIMAL(15,2)  NULL,        -- NULL = limit not yet set
    PRIMARY KEY (emp_id)
);

-- Vendor master (like SAP LFA1): approved list and related-party flag
CREATE TABLE ox_vendors (
    vendor_id      VARCHAR(5)   NOT NULL,
    name           VARCHAR(40)  NOT NULL,
    category       VARCHAR(20)  NOT NULL,
    approved       CHAR(1)      NOT NULL,
    related_party  CHAR(1)      NOT NULL,
    PRIMARY KEY (vendor_id)
);

-- Operating expense postings (like SAP BSEG lines on opex accounts)
CREATE TABLE ox_expenses (
    doc_no        BIGINT         NOT NULL,
    posting_date  DATE           NOT NULL,
    cost_center   VARCHAR(10)    NOT NULL,
    vendor_id     VARCHAR(5)     NOT NULL,
    expense_type  VARCHAR(20)    NOT NULL,
    amount        DECIMAL(15,2)  NOT NULL,
    approved_by   VARCHAR(5)     NOT NULL,
    PRIMARY KEY (doc_no),
    FOREIGN KEY (vendor_id)   REFERENCES ox_vendors (vendor_id),
    FOREIGN KEY (approved_by) REFERENCES ox_approvers (emp_id)
);

LOAD DATA LOCAL INFILE 'data/approvers.csv' INTO TABLE ox_approvers
CHARACTER SET utf8mb4 FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' IGNORE 1 LINES
(emp_id, name, title, @limit)
SET approval_limit = NULLIF(@limit, '');      -- blank in the CSV → NULL

LOAD DATA LOCAL INFILE 'data/vendors.csv' INTO TABLE ox_vendors
CHARACTER SET utf8mb4 FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'data/expenses.csv' INTO TABLE ox_expenses
CHARACTER SET utf8mb4 FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

SHOW WARNINGS;
SELECT (SELECT COUNT(*) FROM ox_approvers)  AS approvers,     -- 6
       (SELECT COUNT(*) FROM ox_vendors)    AS vendors,       -- 7
       (SELECT COUNT(*) FROM ox_expenses)   AS expenses,      -- 27
       (SELECT SUM(amount) FROM ox_expenses) AS total_opex;   -- 663,448.00
