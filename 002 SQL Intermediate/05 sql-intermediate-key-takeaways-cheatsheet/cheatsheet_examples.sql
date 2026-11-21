-- =====================================================================
-- Demo data for CHEATSHEET.md: every query in the cheat sheet runs on it.
-- Self-contained (no files to load). Run with:
--   mysql -u root -p < cheatsheet_examples.sql
-- or open in MySQL Workbench and Execute (⚡).
-- ⚠️ Drops and recreates the database cheatsheet_intermediate.
-- =====================================================================
DROP DATABASE IF EXISTS cheatsheet_intermediate;
CREATE DATABASE cheatsheet_intermediate CHARACTER SET utf8mb4;
USE cheatsheet_intermediate;

CREATE TABLE customers (
    customer_id  VARCHAR(10)  NOT NULL PRIMARY KEY,
    name         VARCHAR(40)  NOT NULL,
    region       VARCHAR(20)  NOT NULL
);

CREATE TABLE products (
    product_id   VARCHAR(10)  NOT NULL PRIMARY KEY,
    description  VARCHAR(40)  NOT NULL
);

-- Price list per product AND region (joined on two columns)
CREATE TABLE price_list (
    product_id  VARCHAR(10)    NOT NULL,
    region      VARCHAR(20)    NOT NULL,
    list_price  DECIMAL(11,2)  NOT NULL,
    PRIMARY KEY (product_id, region)
);

CREATE TABLE employees (
    emp_id      VARCHAR(5)   NOT NULL PRIMARY KEY,
    name        VARCHAR(40)  NOT NULL,
    manager_id  VARCHAR(5)   NULL                  -- another employee (self join)
);

CREATE TABLE orders (
    order_no     VARCHAR(10)  NOT NULL PRIMARY KEY,
    order_date   DATE         NOT NULL,
    customer_id  VARCHAR(10)  NOT NULL,
    created_by   VARCHAR(5)   NOT NULL
);

CREATE TABLE order_items (
    order_no    VARCHAR(10)    NOT NULL,
    line_no     SMALLINT       NOT NULL,
    product_id  VARCHAR(10)    NOT NULL,
    qty         DECIMAL(13,3)  NOT NULL,
    unit_price  DECIMAL(11,2)  NOT NULL,
    PRIMARY KEY (order_no, line_no)
);

CREATE TABLE payments (
    payment_no    VARCHAR(10)    NOT NULL PRIMARY KEY,
    payment_date  DATE           NOT NULL,
    order_no      VARCHAR(10)    NOT NULL,
    amount        DECIMAL(15,2)  NOT NULL
);

CREATE TABLE months (
    month_no    TINYINT      NOT NULL PRIMARY KEY,
    month_name  VARCHAR(10)  NOT NULL
);

INSERT INTO customers VALUES
('0000100001', 'Acme Retail',        'Midwest'),
('0000100002', ' northwind stores ', 'Northeast'),    -- messy text on purpose
('0000100003', 'Müller GmbH',        'Export'),
('0000100004', 'Sunrise Hospitals',  'Midwest'),
('0000100005', 'Great Lakes Supply', 'Northeast');    -- no orders

INSERT INTO products VALUES
('P-100', 'Steel beam'), ('P-200', 'Steel sheet'), ('P-300', 'Fastener box');

INSERT INTO price_list VALUES
('P-100', 'Midwest', 1250.00), ('P-100', 'Northeast', 1300.00), ('P-100', 'Export', 1200.00),
('P-200', 'Midwest',  480.00), ('P-200', 'Northeast',  500.00), ('P-200', 'Export',  470.00),
('P-300', 'Midwest',   35.50), ('P-300', 'Northeast',   36.00), ('P-300', 'Export',   34.00);

INSERT INTO employees VALUES
('E01', 'Laura Chen', NULL), ('E02', 'Mark Davis', 'E01'),
('E03', 'Tom Wilson', 'E02'), ('E04', 'Jake Kim',   'E02');

INSERT INTO orders VALUES
('5000000001', '2026-01-14', '0000100001', 'E03'),
('5000000002', '2026-01-28', '0000100002', 'E03'),
('5000000003', '2026-02-11', '0000100003', 'E04'),
('5000000004', '2026-02-25', '0000100001', 'E04'),
('5000000005', '2026-03-10', '0000100004', 'E03'),
('5000000006', '2026-03-28', '0000100002', 'E02');   -- Saturday

INSERT INTO order_items VALUES
('5000000001', 1, 'P-100', 20,  1250.00), ('5000000001', 2, 'P-300', 200, 35.50),
('5000000002', 1, 'P-200', 60,   500.00),
('5000000003', 1, 'P-100', 30,  1200.00), ('5000000003', 2, 'P-200', 40, 470.00),
('5000000004', 1, 'P-200', 50,   480.00),
('5000000005', 1, 'P-100', 15,  1250.00),
('5000000006', 1, 'P-100', 25,  1450.00);            -- above the Northeast list price

INSERT INTO payments VALUES
('1400000001', '2026-02-12', '5000000001', 32100.00),
('1400000002', '2026-02-26', '5000000002', 15000.00),
('1400000003', '2026-03-05', '5000000002', 15000.00),   -- second payment for the same order
('1400000004', '2026-04-10', '5000000003', 54800.00),
('1400000005', '2026-03-26', '5000000004', 24000.00);

INSERT INTO months VALUES (1, 'January'), (2, 'February'), (3, 'March');

SELECT 'cheatsheet_intermediate ready' AS status,
       (SELECT COUNT(*) FROM orders)      AS orders,        -- 6
       (SELECT COUNT(*) FROM order_items) AS order_lines,   -- 8
       (SELECT COUNT(*) FROM payments)    AS payments;      -- 5
