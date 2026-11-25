-- =====================================================================
-- Setup: create the four revenue tables and load the sample data.
-- Run from this folder with the mysql command-line client:
--   mysql --local-infile=1 -u root -p < setup.sql
-- In MySQL Workbench: replace each 'data/...' path with the full path
-- (forward slashes) and enable OPT_LOCAL_INFILE=1 on the connection.
-- =====================================================================
CREATE DATABASE IF NOT EXISTS audit_fy2026;
USE audit_fy2026;

DROP TABLE IF EXISTS rv_billing_items, rv_billing_docs, rv_materials, rv_customers;

-- Customer master (like SAP KNA1 / KNKK): group, credit limit, billing block
CREATE TABLE rv_customers (
    customer_id     VARCHAR(10)    NOT NULL,
    name            VARCHAR(40)    NOT NULL,
    customer_group  VARCHAR(15)    NOT NULL,     -- Domestic / Export / Intercompany
    credit_limit    DECIMAL(15,2)  NOT NULL,
    blocked         CHAR(1)        NOT NULL DEFAULT 'N',
    created_on      DATE           NOT NULL,
    PRIMARY KEY (customer_id)
);

-- Material master with list prices (like SAP MARA / pricing)
CREATE TABLE rv_materials (
    material_id  VARCHAR(10)    NOT NULL,
    description  VARCHAR(40)    NOT NULL,
    list_price   DECIMAL(11,2)  NOT NULL,
    PRIMARY KEY (material_id)
);

-- Billing document headers (like SAP VBRK): F2 = invoice, G2 = credit memo
CREATE TABLE rv_billing_docs (
    billing_doc   INT            NOT NULL,
    billing_type  CHAR(2)        NOT NULL,
    billing_date  DATE           NOT NULL,
    posting_date  DATE           NOT NULL,
    customer_id   VARCHAR(10)    NOT NULL,
    ref_doc       INT            NULL,       -- credit memo: invoice it reverses
    net_value     DECIMAL(15,2)  NOT NULL,   -- header total (credit memos negative)
    PRIMARY KEY (billing_doc),
    FOREIGN KEY (customer_id) REFERENCES rv_customers (customer_id)
);

-- Billing document items (like SAP VBRP)
CREATE TABLE rv_billing_items (
    billing_doc  INT            NOT NULL,
    item_no      SMALLINT       NOT NULL,
    material_id  VARCHAR(10)    NOT NULL,
    qty          DECIMAL(13,3)  NOT NULL,   -- negative on credit memos
    unit_price   DECIMAL(11,2)  NOT NULL,
    net_amount   DECIMAL(15,2)  NOT NULL,
    PRIMARY KEY (billing_doc, item_no),
    FOREIGN KEY (billing_doc) REFERENCES rv_billing_docs (billing_doc),
    FOREIGN KEY (material_id) REFERENCES rv_materials (material_id)
);

LOAD DATA LOCAL INFILE 'data/customers.csv' INTO TABLE rv_customers
CHARACTER SET utf8mb4 FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'data/materials.csv' INTO TABLE rv_materials
CHARACTER SET utf8mb4 FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'data/billing_docs.csv' INTO TABLE rv_billing_docs
CHARACTER SET utf8mb4 FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' IGNORE 1 LINES
(billing_doc, billing_type, billing_date, posting_date, customer_id, @ref_doc, net_value)
SET ref_doc = NULLIF(@ref_doc, '');         -- blank in the CSV → NULL

LOAD DATA LOCAL INFILE 'data/billing_items.csv' INTO TABLE rv_billing_items
CHARACTER SET utf8mb4 FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

SHOW WARNINGS;
SELECT (SELECT COUNT(*) FROM rv_customers)            AS customers,      -- 8
       (SELECT COUNT(*) FROM rv_materials)            AS materials,      -- 5
       (SELECT COUNT(*) FROM rv_billing_docs)         AS billing_docs,   -- 24
       (SELECT COUNT(*) FROM rv_billing_items)        AS billing_items,  -- 30
       (SELECT SUM(net_value) FROM rv_billing_docs)   AS header_total,   -- 147,300.00
       (SELECT SUM(net_amount) FROM rv_billing_items) AS item_total;     -- 141,300.00
