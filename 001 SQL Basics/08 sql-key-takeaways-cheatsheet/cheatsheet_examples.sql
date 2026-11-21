-- =====================================================================
-- Demo data for CHEATSHEET.md: every query in the cheat sheet runs on it.
-- Self-contained (no files to load). Run with:
--   mysql -u root -p < cheatsheet_examples.sql
-- or open in MySQL Workbench and Execute (⚡).
-- ⚠️ Drops and recreates the database cheatsheet_demo.
-- =====================================================================
DROP DATABASE IF EXISTS cheatsheet_demo;
CREATE DATABASE cheatsheet_demo CHARACTER SET utf8mb4;
USE cheatsheet_demo;

CREATE TABLE customers (
    customer_id  VARCHAR(10)  NOT NULL,
    name         VARCHAR(40)  NOT NULL,
    region       VARCHAR(20)  NOT NULL,
    created_on   DATE         NOT NULL,
    PRIMARY KEY (customer_id)
);

CREATE TABLE sales (
    invoice_no    VARCHAR(10)    NOT NULL,
    line_no       SMALLINT       NOT NULL,
    invoice_date  DATE           NOT NULL,
    customer_id   VARCHAR(10)    NOT NULL,
    product       VARCHAR(30)    NOT NULL,
    qty_kg        DECIMAL(12,3)  NOT NULL,              -- quantity in kilograms
    unit_price    DECIMAL(11,2)  NOT NULL,              -- price per kg, in currency
    unit_cost     DECIMAL(11,2)  NOT NULL,              -- cost per kg, in currency
    amount        DECIMAL(15,2)  NOT NULL,              -- qty_kg × unit_price (negative = credit)
    currency      CHAR(3)        NOT NULL DEFAULT 'USD',
    doc_type      CHAR(2)        NOT NULL,              -- F2 invoice, G2 credit memo
    created_by    VARCHAR(12)    NOT NULL,
    note          VARCHAR(50)    NULL,
    PRIMARY KEY (invoice_no, line_no),
    CONSTRAINT fk_sales_customer FOREIGN KEY (customer_id) REFERENCES customers (customer_id),
    CHECK (doc_type IN ('F2', 'G2'))
);

INSERT INTO customers VALUES
('0000100001', 'Acme Retail',        'Midwest',   '2019-03-14'),
('0000100002', 'Northwind Stores',   'Northeast', '2018-07-02'),
('0000100003', 'Müller GmbH',        'Export',    '2020-01-20'),
('0000100004', 'Sunrise Hospitals',  'South',     '2017-11-05'),
('0000100005', 'Delta Distributors', 'South',     '2026-12-15');

INSERT INTO sales VALUES
('9000000001', 1, '2026-01-15', '0000100001', 'Steel beam',   2000.000, 1.25, 0.90,   2500.00, 'USD', 'F2', 'BATCH_SD',  NULL),
('9000000002', 1, '2026-02-10', '0000100002', 'Steel sheet',  5000.000, 0.48, 0.35,   2400.00, 'USD', 'F2', 'BATCH_SD',  NULL),
('9000000002', 2, '2026-02-10', '0000100002', 'Fastener box',  400.000, 3.55, 2.10,   1420.00, 'USD', 'F2', 'BATCH_SD',  NULL),
('9000000003', 1, '2026-03-05', '0000100003', 'Steel beam',   3000.000, 1.15, 0.90,   3450.00, 'EUR', 'F2', 'BATCH_SD',  'Export order'),
('9000000004', 1, '2026-05-20', '0000100004', 'Steel sheet',  2500.000, 0.48, 0.35,   1200.00, 'USD', 'F2', 'SD_CLERK1', NULL),
('9000000005', 1, '2026-06-24', '0000100004', 'Steel sheet',  -500.000, 0.48, 0.35,   -240.00, 'USD', 'G2', 'SD_CLERK1', 'Return of damaged goods'),
('9000000006', 1, '2026-08-07', '0000100001', 'Steel beam',   2200.000, 1.25, 0.90,   2750.00, 'USD', 'F2', 'BATCH_SD',  NULL),
('9000000007', 1, '2026-09-18', '0000100003', 'Fastener box',  600.000, 3.30, 2.10,   1980.00, 'EUR', 'F2', 'BATCH_SD',  'Export order'),
('9000000008', 1, '2026-11-13', '0000100002', 'Steel beam',   1800.000, 1.25, 0.90,   2250.00, 'USD', 'F2', 'BATCH_SD',  NULL),
('9000000009', 1, '2026-12-27', '0000100005', 'Steel beam',   8000.000, 1.95, 0.90,  15600.00, 'USD', 'F2', 'SALES_MGR', 'Year-end deal'),
('9000000010', 1, '2026-12-31', '0000100005', 'Steel sheet', 15000.000, 0.48, 0.35,   7200.00, 'USD', 'F2', 'SALES_MGR', 'Year-end deal'),
('9000000011', 1, '2027-01-08', '0000100005', 'Steel beam',  -8000.000, 1.95, 0.90, -15600.00, 'USD', 'G2', 'SALES_MGR', 'Reversal of 9000000009');

SELECT 'cheatsheet_demo ready' AS status,
       (SELECT COUNT(*) FROM customers) AS customers,     -- 5
       (SELECT COUNT(*) FROM sales)     AS sales_lines;   -- 12
