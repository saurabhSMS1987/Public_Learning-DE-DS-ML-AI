-- =====================================================================
-- Setup: create the four tables and load the sample data.
-- Run from this folder with the mysql command-line client:
--   mysql --local-infile=1 -u root -p < setup.sql
-- In MySQL Workbench: replace each 'data/...' path with the full path
-- (forward slashes) and enable OPT_LOCAL_INFILE=1 on the connection.
-- =====================================================================
CREATE DATABASE IF NOT EXISTS audit_fy2026;
USE audit_fy2026;

DROP TABLE IF EXISTS billing, deliveries, materials, customers;

-- Customer master (like SAP KNA1)
CREATE TABLE customers (
    customer_id  VARCHAR(10)  NOT NULL,
    name         VARCHAR(40)  NOT NULL,
    region       VARCHAR(20)  NOT NULL,
    PRIMARY KEY (customer_id)
);

-- Material master with list prices (like SAP MARA/MAKT)
CREATE TABLE materials (
    material_id  VARCHAR(18)    NOT NULL,
    description  VARCHAR(40)    NOT NULL,
    unit         VARCHAR(3)     NOT NULL,
    list_price   DECIMAL(11,2)  NOT NULL,
    PRIMARY KEY (material_id)
);

-- Outbound deliveries: VOLUME shipped (like SAP LIKP/LIPS)
CREATE TABLE deliveries (
    delivery_no    VARCHAR(10)    NOT NULL,
    delivery_date  DATE           NOT NULL,   -- goods issue date
    customer_id    VARCHAR(10)    NOT NULL,
    material_id    VARCHAR(18)    NOT NULL,
    qty_shipped    DECIMAL(13,3)  NOT NULL,
    PRIMARY KEY (delivery_no)
);

-- Billing documents: REVENUE (like SAP VBRK/VBRP)
-- No foreign keys on purpose: the data contains reconciliation errors to find with joins.
CREATE TABLE billing (
    billing_no    VARCHAR(10)    NOT NULL,
    billing_date  DATE           NOT NULL,
    delivery_no   VARCHAR(10)    NULL,       -- reference delivery (NULL = none)
    customer_id   VARCHAR(10)    NOT NULL,
    material_id   VARCHAR(18)    NOT NULL,
    qty_billed    DECIMAL(13,3)  NOT NULL,
    net_price     DECIMAL(11,2)  NOT NULL,
    net_value     DECIMAL(15,2)  NOT NULL,
    PRIMARY KEY (billing_no)
);

LOAD DATA LOCAL INFILE 'data/customers.csv' INTO TABLE customers
CHARACTER SET utf8mb4 FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'data/materials.csv' INTO TABLE materials
CHARACTER SET utf8mb4 FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'data/deliveries.csv' INTO TABLE deliveries
CHARACTER SET utf8mb4 FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'data/billing.csv' INTO TABLE billing
CHARACTER SET utf8mb4 FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' IGNORE 1 LINES
(billing_no, billing_date, @delivery_no, customer_id, material_id, qty_billed, net_price, net_value)
SET delivery_no = NULLIF(@delivery_no, '');            -- blank → NULL

SHOW WARNINGS;
SELECT (SELECT COUNT(*) FROM customers)  AS customers,      -- 6
       (SELECT COUNT(*) FROM materials)  AS materials,      -- 5
       (SELECT COUNT(*) FROM deliveries) AS deliveries,     -- 16
       (SELECT COUNT(*) FROM billing)    AS billing_docs;   -- 18
