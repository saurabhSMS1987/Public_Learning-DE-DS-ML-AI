# ⚡ MySQL Cheat Sheet: SQL Basics

Syntax and examples for every topic in the [key takeaways](KEY_TAKEAWAYS.md), in the same order. Every `sql` block runs on the demo data in [`cheatsheet_examples.sql`](cheatsheet_examples.sql) (tables `customers` and `sales`). Blocks marked `text` are templates.

## Contents

0. [Query order](#0--query-order)
1. [Setting up](#1--setting-up)
2. [Creating tables](#2--creating-tables)
3. [Importing and exporting](#3--importing-and-exporting)
4. [Changing data](#4--changing-data)
5. [Text queries](#5--text-queries)
6. [Numeric queries](#6--numeric-queries)
7. [Summary analytics](#7--summary-analytics)
8. [HAVING](#8--having)
9. [Calculated columns](#9--calculated-columns)

---

## 0 · Query order

```text
SELECT   [DISTINCT] columns, expressions AS alias       -- written order
FROM     table
WHERE    row conditions
GROUP BY columns
HAVING   group conditions
ORDER BY columns [ASC | DESC]
LIMIT    n OFFSET m;
```

```text
FROM → WHERE → GROUP BY → HAVING → SELECT → DISTINCT → ORDER BY → LIMIT / OFFSET    -- run order
```

## 1 · Setting up

```sql
USE cheatsheet_demo;                     -- run the following queries in this database
```

## 2 · Creating tables

```sql
CREATE DATABASE IF NOT EXISTS cheatsheet_demo;
USE cheatsheet_demo;

CREATE TABLE demo_table (
    code         VARCHAR(10)    NOT NULL,              -- text keeps leading zeros
    customer_id  VARCHAR(10)    NOT NULL,
    amount       DECIMAL(15,2)  NOT NULL DEFAULT 0,    -- exact money
    doc_date     DATE           NOT NULL,              -- 'YYYY-MM-DD'
    status       CHAR(1)        NOT NULL,
    PRIMARY KEY (code),                                                 -- no duplicates
    CONSTRAINT fk_demo_customer FOREIGN KEY (customer_id)
        REFERENCES customers (customer_id),                             -- no orphans
    CHECK (status IN ('O', 'C'))                                        -- allowed values
);

ALTER TABLE demo_table ADD COLUMN note VARCHAR(50) NULL;   -- change a table
TRUNCATE TABLE demo_table;                                 -- empty it (no undo)
DROP TABLE demo_table;                                     -- delete it (no undo)
```

| Data | Type |
| --- | --- |
| Codes and IDs | `VARCHAR(n)` |
| Money | `DECIMAL(15,2)` |
| Dates | `DATE` |

```sql
CREATE TABLE sales_bkp LIKE sales;                        -- copy the structure
INSERT INTO sales_bkp SELECT * FROM sales;                -- copy the rows

CREATE TABLE sales_2026 AS                                -- copy data from a query
SELECT * FROM sales
WHERE invoice_date BETWEEN '2026-01-01' AND '2026-12-31';

DROP TABLE sales_bkp, sales_2026;
```

```sql
CREATE INDEX idx_sales_date ON sales (invoice_date);              -- speed up a filter
EXPLAIN SELECT * FROM sales WHERE invoice_date >= '2026-12-01';   -- check the key is used
DROP INDEX idx_sales_date ON sales;
```

## 3 · Importing and exporting

| Task | How |
| --- | --- |
| Excel → loadable file | **File → Save As → CSV UTF-8 (comma delimited)** |
| Import (point and click) | Right-click table → **Table Data Import Wizard**, then compare row counts |
| Export a table | Right-click table → **Table Data Export Wizard** |
| Export query results | Result grid → **Export** |

```text
-- Fast, repeatable load with format conversion
-- (needs local file loading: SET GLOBAL local_infile = 1; and --local-infile=1)
LOAD DATA LOCAL INFILE 'C:/data/sales.csv'
INTO TABLE sales
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(invoice_no, line_no, @inv_date, customer_id, product, qty_kg,
 unit_price, unit_cost, @amount, currency, doc_type, created_by, @note)
SET invoice_date = STR_TO_DATE(@inv_date, '%d.%m.%Y'),   -- 31.12.2026 → 2026-12-31
    amount       = REPLACE(@amount, ',', ''),            -- 1,250.00  → 1250.00
    note         = NULLIF(@note, '');                    -- blank     → NULL
```

```sql
-- Staging table: everything as text, so nothing is lost
CREATE TABLE stg_sales (invoice_no VARCHAR(50), invoice_date VARCHAR(50), amount VARCHAR(50));
INSERT INTO stg_sales VALUES ('9000000099', '31.12.2026', '1,250.00');

-- Move clean rows on with INSERT … SELECT, converting as you go
CREATE TABLE clean_sales (invoice_no VARCHAR(10), invoice_date DATE, amount DECIMAL(15,2));
INSERT INTO clean_sales
SELECT invoice_no, STR_TO_DATE(invoice_date, '%d.%m.%Y'), REPLACE(amount, ',', '')
FROM stg_sales;

-- Validate the load: row count and control total against the source
SELECT COUNT(*) AS row_count, SUM(amount) AS control_total FROM clean_sales;   -- 1 / 1250.00

DROP TABLE stg_sales, clean_sales;
```

```text
-- Export with SQL (writes into the server's secure_file_priv folder)
SELECT invoice_no, amount FROM sales
INTO OUTFILE '/var/lib/mysql-files/sales.csv'
FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';

-- Back up a whole database (command line)
mysqldump -u root -p cheatsheet_demo > cheatsheet_demo.sql
```

## 4 · Changing data

```sql
START TRANSACTION;

INSERT INTO customers (customer_id, name, region, created_on)          -- add
VALUES ('0000100006', 'Prairie Agro Co', 'Midwest', '2026-03-01');

SELECT * FROM customers WHERE customer_id = '0000100006';              -- preview
UPDATE customers SET region = 'West' WHERE customer_id = '0000100006'; -- change

SELECT * FROM customers WHERE customer_id = '0000100006';              -- preview
DELETE FROM customers WHERE customer_id = '0000100006';                -- remove

ROLLBACK;                       -- undo everything since START TRANSACTION (COMMIT saves)
```

## 5 · Text queries

```sql
SELECT * FROM sales;                                    -- all columns
SELECT invoice_no, invoice_date, amount FROM sales;     -- named columns

SELECT COUNT(*)                 AS line_count,          -- 12 rows
       COUNT(DISTINCT customer_id) AS customer_count    -- 5 unique customers
FROM sales;

SELECT DISTINCT product FROM sales;                     -- unique values
SELECT DISTINCT customer_id, product FROM sales;        -- unique combinations
```

| `LIKE` pattern | Matches |
| --- | --- |
| `'Steel%'` | starts with `Steel` |
| `'%box'` | ends with `box` |
| `'%year-end%'` | contains `year-end` |
| `'SD_CLERK_'` | `_` = exactly one character |

```sql
SELECT * FROM sales WHERE product LIKE 'Steel%';
SELECT * FROM sales WHERE note LIKE '%year-end%';
SELECT * FROM sales WHERE created_by LIKE 'SD_CLERK_';

SELECT * FROM sales WHERE currency = 'EUR';                    -- text in quotes
SELECT * FROM sales WHERE invoice_date = '2026-12-31';         -- dates in quotes
SELECT * FROM sales WHERE note IS NULL;                        -- never "= NULL"
```

## 6 · Numeric queries

| Operator | Meaning |
| --- | --- |
| `=` / `<>` | equal / not equal |
| `<` `<=` `>` `>=` | less / greater than (or equal) |
| `AND` / `OR` | both / either condition (`AND` is evaluated first: use brackets) |
| `BETWEEN a AND b` | range, both ends included |
| `IN (a, b, c)` | value in a list |

```sql
SELECT * FROM sales WHERE amount >= 2500;
SELECT * FROM sales WHERE amount > 0 AND amount < 2000;
SELECT * FROM sales WHERE currency = 'EUR' OR (doc_type = 'G2' AND amount < -1000);
SELECT * FROM sales WHERE amount BETWEEN 1000 AND 3000;
SELECT * FROM sales WHERE line_no IN (1, 2);
```

```sql
SELECT * FROM sales ORDER BY amount;                           -- ascending (default)
SELECT * FROM sales ORDER BY amount DESC;                      -- descending

SELECT * FROM sales ORDER BY amount DESC, invoice_no LIMIT 3;            -- top 3
SELECT * FROM sales ORDER BY amount ASC,  invoice_no LIMIT 3;            -- bottom 3
SELECT * FROM sales ORDER BY amount DESC, invoice_no LIMIT 3 OFFSET 3;   -- page 2 (rows 4-6)
SELECT * FROM sales ORDER BY amount DESC, invoice_no LIMIT 1 OFFSET 1;   -- 2nd largest
```

## 7 · Summary analytics

```sql
SELECT SUM(amount)       AS net_sales,
       MIN(amount)       AS smallest_line,
       MAX(amount)       AS largest_line,
       AVG(amount)       AS average_line,
       COUNT(*)          AS line_count
FROM sales;

SELECT customer_id,                                   -- one row per customer
       COUNT(*)    AS line_count,
       SUM(amount) AS net_sales
FROM sales
GROUP BY customer_id;                                 -- every non-aggregated column grouped
```

## 8 · HAVING

```sql
SELECT customer_id, SUM(amount) AS net_sales
FROM sales
WHERE invoice_date BETWEEN '2026-01-01' AND '2026-12-31'   -- WHERE: rows, before grouping
GROUP BY customer_id
HAVING SUM(amount) > 5000;                                 -- HAVING: groups, after grouping

SELECT customer_id, SUM(amount) AS net_sales
FROM sales
GROUP BY customer_id
HAVING net_sales > 5000 AND COUNT(*) >= 2;                 -- aliases and aggregates allowed
```

| `WHERE` | `HAVING` |
| --- | --- |
| Filters rows, before `GROUP BY` | Filters groups, after `GROUP BY` |
| Any table column, even if not selected | Grouped columns, aggregates, `SELECT` aliases |
| No aggregates | Aggregates allowed |

## 9 · Calculated columns

```sql
-- Derived columns: revenue and profit
SELECT invoice_no,
       qty_kg * unit_price                 AS revenue,
       qty_kg * unit_cost                  AS cost,
       qty_kg * (unit_price - unit_cost)   AS profit
FROM sales;

-- Unit conversion (kg → tonnes) and currency conversion (EUR → USD at a rate)
SELECT invoice_no,
       qty_kg / 1000                                AS qty_tonnes,
       IF(currency = 'EUR', amount * 1.085, amount) AS amount_usd
FROM sales;
```

```sql
-- IF: two outcomes
SELECT invoice_no, IF(amount < 0, 'Credit', 'Invoice') AS line_type
FROM sales;

-- CASE: more than two outcomes (first true WHEN wins; always add ELSE)
SELECT invoice_no, amount,
       CASE
           WHEN amount >= 10000 THEN 'Large'
           WHEN amount >= 2000  THEN 'Medium'
           WHEN amount >= 0     THEN 'Small'
           ELSE 'Credit'
       END AS size_band
FROM sales;
```

```sql
-- YEAR and the current year
SELECT invoice_no, YEAR(invoice_date) AS invoice_year FROM sales;

SELECT YEAR(CURDATE()) AS current_year;

SELECT * FROM sales WHERE YEAR(invoice_date) = YEAR(CURDATE());

-- Fixed as-at date for repeatable results
SET @as_at = '2026-12-31';
SELECT * FROM sales WHERE invoice_date <= @as_at;
```
