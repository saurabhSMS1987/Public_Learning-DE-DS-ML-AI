-- =====================================================================
-- Setup: create the four operating expense tables and load the sample data.
-- Run from this folder with the mysql command-line client:
--   mysql --local-infile=1 -u root -p < setup.sql
-- In MySQL Workbench: replace each 'data/...' path with the full path
-- (forward slashes) and enable OPT_LOCAL_INFILE=1 on the connection.
-- =====================================================================
CREATE DATABASE IF NOT EXISTS audit_fy2026;
USE audit_fy2026;

DROP TABLE IF EXISTS ce_expenses, ce_budget, ce_cost_centers, ce_employees;

-- Employees with their manager and approval limit (delegation of authority)
CREATE TABLE ce_employees (
    emp_id          VARCHAR(5)     NOT NULL,
    name            VARCHAR(40)    NOT NULL,
    title           VARCHAR(40)    NOT NULL,
    manager_id      VARCHAR(5)     NULL,          -- NULL = top of the hierarchy
    approval_limit  DECIMAL(15,2)  NOT NULL,
    PRIMARY KEY (emp_id),
    FOREIGN KEY (manager_id) REFERENCES ce_employees (emp_id)
);

-- Cost centres (like SAP CSKS) and their owners
CREATE TABLE ce_cost_centers (
    cost_center  VARCHAR(10)  NOT NULL,
    name         VARCHAR(30)  NOT NULL,
    owner_id     VARCHAR(5)   NOT NULL,
    PRIMARY KEY (cost_center),
    FOREIGN KEY (owner_id) REFERENCES ce_employees (emp_id)
);

-- Annual FY2026 budget by cost centre and expense type
CREATE TABLE ce_budget (
    cost_center    VARCHAR(10)    NOT NULL,
    expense_type   VARCHAR(20)    NOT NULL,
    budget_amount  DECIMAL(15,2)  NOT NULL,
    PRIMARY KEY (cost_center, expense_type),
    FOREIGN KEY (cost_center) REFERENCES ce_cost_centers (cost_center)
);

-- Operating expense postings FY2026 (like SAP BSEG lines on opex accounts)
CREATE TABLE ce_expenses (
    doc_no        BIGINT         NOT NULL,
    posting_date  DATE           NOT NULL,
    cost_center   VARCHAR(10)    NOT NULL,
    expense_type  VARCHAR(20)    NOT NULL,
    vendor        VARCHAR(40)    NOT NULL,
    amount        DECIMAL(15,2)  NOT NULL,
    approved_by   VARCHAR(5)     NOT NULL,
    PRIMARY KEY (doc_no),
    FOREIGN KEY (cost_center) REFERENCES ce_cost_centers (cost_center),
    FOREIGN KEY (approved_by) REFERENCES ce_employees (emp_id)
);

LOAD DATA LOCAL INFILE 'data/employees.csv' INTO TABLE ce_employees
CHARACTER SET utf8mb4 FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' IGNORE 1 LINES
(emp_id, name, title, @manager_id, approval_limit)
SET manager_id = NULLIF(@manager_id, '');      -- blank in the CSV → NULL

LOAD DATA LOCAL INFILE 'data/cost_centers.csv' INTO TABLE ce_cost_centers
CHARACTER SET utf8mb4 FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'data/budget.csv' INTO TABLE ce_budget
CHARACTER SET utf8mb4 FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'data/expenses.csv' INTO TABLE ce_expenses
CHARACTER SET utf8mb4 FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

SHOW WARNINGS;
SELECT (SELECT COUNT(*) FROM ce_employees)          AS employees,     -- 8
       (SELECT COUNT(*) FROM ce_cost_centers)       AS cost_centers,  -- 4
       (SELECT COUNT(*) FROM ce_budget)             AS budget_lines,  -- 9
       (SELECT COUNT(*) FROM ce_expenses)           AS expenses,      -- 42
       (SELECT SUM(budget_amount) FROM ce_budget)   AS total_budget,  -- 427,600.00
       (SELECT SUM(amount) FROM ce_expenses)        AS total_actual;  -- 436,348.00
