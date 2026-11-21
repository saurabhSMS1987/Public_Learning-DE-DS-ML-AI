-- =====================================================================
-- Setup: create the five tables and load the sample data.
-- Run from this folder with the mysql command-line client:
--   mysql --local-infile=1 -u root -p < setup.sql
-- In MySQL Workbench: replace each 'data/...' path with the full path
-- (forward slashes) and enable OPT_LOCAL_INFILE=1 on the connection.
-- =====================================================================
CREATE DATABASE IF NOT EXISTS audit_fy2026;
USE audit_fy2026;

DROP TABLE IF EXISTS opex_postings, periods, expense_categories, cost_centers, employees;

-- Employees with their manager (self-reference) and approval limit
CREATE TABLE employees (
    emp_id          VARCHAR(5)     NOT NULL,
    name            VARCHAR(40)    NOT NULL,
    title           VARCHAR(40)    NOT NULL,
    manager_id      VARCHAR(5)     NULL,        -- points to another employee (NULL = top)
    approval_limit  DECIMAL(15,2)  NOT NULL,
    PRIMARY KEY (emp_id)
);

-- Cost centers (like SAP CSKS)
CREATE TABLE cost_centers (
    cost_center  VARCHAR(10)  NOT NULL,
    name         VARCHAR(30)  NOT NULL,
    department   VARCHAR(30)  NOT NULL,
    PRIMARY KEY (cost_center)
);

-- Operating expense G/L accounts
CREATE TABLE expense_categories (
    gl_account  VARCHAR(10)  NOT NULL,
    category    VARCHAR(30)  NOT NULL,
    PRIMARY KEY (gl_account)
);

-- Fiscal periods of 2026
CREATE TABLE periods (
    period      TINYINT      NOT NULL,
    month_name  VARCHAR(10)  NOT NULL,
    period_end  DATE         NOT NULL,
    PRIMARY KEY (period)
);

-- Operating expense postings (like SAP BSEG lines on expense accounts / COEP)
CREATE TABLE opex_postings (
    doc_no        VARCHAR(10)    NOT NULL,
    posting_date  DATE           NOT NULL,
    period        TINYINT        NOT NULL,
    cost_center   VARCHAR(10)    NOT NULL,
    gl_account    VARCHAR(10)    NOT NULL,
    vendor        VARCHAR(40)    NOT NULL,
    amount        DECIMAL(15,2)  NOT NULL,
    requested_by  VARCHAR(5)     NOT NULL,
    approved_by   VARCHAR(5)     NOT NULL,
    description   VARCHAR(50)    NOT NULL,
    PRIMARY KEY (doc_no)
);

LOAD DATA LOCAL INFILE 'data/employees.csv' INTO TABLE employees
CHARACTER SET utf8mb4 FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' IGNORE 1 LINES
(emp_id, name, title, @manager_id, approval_limit)
SET manager_id = NULLIF(@manager_id, '');            -- blank → NULL (the CFO has no manager)

LOAD DATA LOCAL INFILE 'data/cost_centers.csv' INTO TABLE cost_centers
CHARACTER SET utf8mb4 FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'data/expense_categories.csv' INTO TABLE expense_categories
CHARACTER SET utf8mb4 FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'data/periods.csv' INTO TABLE periods
CHARACTER SET utf8mb4 FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'data/opex_postings.csv' INTO TABLE opex_postings
CHARACTER SET utf8mb4 FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

SHOW WARNINGS;
SELECT (SELECT COUNT(*) FROM employees)          AS employees,       -- 6
       (SELECT COUNT(*) FROM cost_centers)       AS cost_centers,    -- 4
       (SELECT COUNT(*) FROM expense_categories) AS categories,      -- 5
       (SELECT COUNT(*) FROM periods)            AS periods,         -- 12
       (SELECT COUNT(*) FROM opex_postings)      AS postings,        -- 28
       (SELECT SUM(amount) FROM opex_postings)   AS total_opex;      -- 387,840.00
