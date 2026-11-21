-- =====================================================================
-- Setup: create the five tables and load the sample data.
-- Run from this folder with the mysql command-line client:
--   mysql --local-infile=1 -u root -p < setup.sql
-- In MySQL Workbench: replace each 'data/...' path with the full path
-- (forward slashes) and enable OPT_LOCAL_INFILE=1 on the connection.
-- =====================================================================
CREATE DATABASE IF NOT EXISTS audit_fy2026;
USE audit_fy2026;

DROP TABLE IF EXISTS ar_payments, ar_invoice_items, ar_invoices, ar_products, ar_customers;

-- Customer master with payment terms and credit limit (like SAP KNA1 / KNB1 / KNKK)
CREATE TABLE ar_customers (
    customer_id         VARCHAR(10)    NOT NULL,
    name                VARCHAR(40)    NOT NULL,
    region              VARCHAR(20)    NOT NULL,
    payment_terms_days  SMALLINT       NOT NULL,
    credit_limit        DECIMAL(15,2)  NOT NULL,
    PRIMARY KEY (customer_id)
);

-- Product master with list prices (like SAP MARA / pricing)
CREATE TABLE ar_products (
    product_id   VARCHAR(10)    NOT NULL,
    description  VARCHAR(40)    NOT NULL,
    list_price   DECIMAL(11,2)  NOT NULL,
    PRIMARY KEY (product_id)
);

-- Invoice headers (like SAP VBRK)
CREATE TABLE ar_invoices (
    invoice_no    VARCHAR(10)  NOT NULL,
    invoice_date  DATE         NOT NULL,
    customer_id   VARCHAR(10)  NOT NULL,
    PRIMARY KEY (invoice_no),
    FOREIGN KEY (customer_id) REFERENCES ar_customers (customer_id)
);

-- Invoice lines (like SAP VBRP): many lines per invoice
CREATE TABLE ar_invoice_items (
    invoice_no  VARCHAR(10)    NOT NULL,
    line_no     SMALLINT       NOT NULL,
    product_id  VARCHAR(10)    NOT NULL,
    qty         DECIMAL(13,3)  NOT NULL,
    unit_price  DECIMAL(11,2)  NOT NULL,
    net_amount  DECIMAL(15,2)  NOT NULL,
    PRIMARY KEY (invoice_no, line_no),
    FOREIGN KEY (invoice_no) REFERENCES ar_invoices (invoice_no),
    FOREIGN KEY (product_id) REFERENCES ar_products (product_id)
);

-- Customer payments (cash receipts, like SAP BSAD clearing): many per invoice possible
CREATE TABLE ar_payments (
    payment_no    VARCHAR(10)    NOT NULL,
    payment_date  DATE           NOT NULL,
    invoice_no    VARCHAR(10)    NOT NULL,   -- invoice the payment was applied to
    customer_id   VARCHAR(10)    NOT NULL,   -- customer who paid
    amount        DECIMAL(15,2)  NOT NULL,
    PRIMARY KEY (payment_no),
    FOREIGN KEY (invoice_no)  REFERENCES ar_invoices (invoice_no),
    FOREIGN KEY (customer_id) REFERENCES ar_customers (customer_id)
);

LOAD DATA LOCAL INFILE 'data/customers.csv' INTO TABLE ar_customers
CHARACTER SET utf8mb4 FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'data/products.csv' INTO TABLE ar_products
CHARACTER SET utf8mb4 FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'data/invoices.csv' INTO TABLE ar_invoices
CHARACTER SET utf8mb4 FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'data/invoice_items.csv' INTO TABLE ar_invoice_items
CHARACTER SET utf8mb4 FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'data/payments.csv' INTO TABLE ar_payments
CHARACTER SET utf8mb4 FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

SHOW WARNINGS;
SELECT (SELECT COUNT(*) FROM ar_customers)          AS customers,       -- 6
       (SELECT COUNT(*) FROM ar_products)           AS products,        -- 4
       (SELECT COUNT(*) FROM ar_invoices)           AS invoices,        -- 23
       (SELECT COUNT(*) FROM ar_invoice_items)      AS invoice_lines,   -- 27
       (SELECT COUNT(*) FROM ar_payments)           AS payments,        -- 18
       (SELECT SUM(net_amount) FROM ar_invoice_items) AS total_billed;  -- 663,875.00
