-- =====================================================================
-- STEP 1 · Create the tables
-- Topics: CREATE TABLE, data types, NOT NULL, DEFAULT, CHECK,
--         PRIMARY KEY, FOREIGN KEY, AUTO_INCREMENT, CREATE INDEX, DESCRIBE
-- =====================================================================
USE revenue_audit;

-- ---------------------------------------------------------------------
-- 1.1 Customer master (like SAP KNA1) · parent table
-- ---------------------------------------------------------------------
CREATE TABLE customers (
    kunnr       VARCHAR(10)    NOT NULL,              -- customer number (text keeps leading zeros)
    name1       VARCHAR(40)    NOT NULL,              -- customer name
    region      VARCHAR(20)    NOT NULL,              -- sales region
    land1       CHAR(2)        NOT NULL,              -- country
    kdgrp       CHAR(2)        NOT NULL,              -- customer group
    kdgrp_text  VARCHAR(20)    NOT NULL,              -- customer group text
    erdat       DATE           NOT NULL,              -- created on
    klimk       DECIMAL(15,2)  NOT NULL DEFAULT 0,    -- credit limit
    PRIMARY KEY (kunnr),
    CHECK (klimk >= 0)
);

-- ---------------------------------------------------------------------
-- 1.2 Material master with list prices (like SAP MARA/MAKT) · parent table
-- ---------------------------------------------------------------------
CREATE TABLE materials (
    matnr       VARCHAR(18)    NOT NULL,              -- material number
    maktx       VARCHAR(40)    NOT NULL,              -- description
    matkl_text  VARCHAR(20)    NOT NULL,              -- product group
    list_price  DECIMAL(11,2)  NOT NULL,              -- standard selling price
    PRIMARY KEY (matnr),
    CHECK (list_price >= 0)
);

-- ---------------------------------------------------------------------
-- 1.3 Staging table: raw SAP export, all text, so no row is lost on load
-- ---------------------------------------------------------------------
CREATE TABLE stg_billing_raw (
    row_id     INT AUTO_INCREMENT PRIMARY KEY,        -- file line number
    vbeln      VARCHAR(50),
    posnr      VARCHAR(50),
    fkart      VARCHAR(50),
    fkdat      VARCHAR(50),                            -- 31.12.2026
    kunag      VARCHAR(50),
    matnr      VARCHAR(50),
    fkimg      VARCHAR(50),                            -- 80-  (trailing minus)
    netpr      VARCHAR(50),                            -- 1,950.00
    netwr      VARCHAR(50),                            -- 156,000.00-
    waerk      VARCHAR(50),
    ernam      VARCHAR(50),
    vgbel      VARCHAR(50),
    loaded_at  DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ---------------------------------------------------------------------
-- 1.4 Billing lines (like SAP VBRK/VBRP) · clean, typed child table
-- ---------------------------------------------------------------------
CREATE TABLE billing_lines (
    vbeln   VARCHAR(10)    NOT NULL,                  -- billing document
    posnr   CHAR(6)        NOT NULL,                  -- item
    fkart   CHAR(2)        NOT NULL,                  -- F2 invoice, G2 credit memo
    fkdat   DATE           NOT NULL,                  -- billing date
    kunag   VARCHAR(10)    NOT NULL,                  -- customer
    matnr   VARCHAR(18)    NOT NULL,                  -- material
    fkimg   DECIMAL(13,3)  NOT NULL,                  -- quantity (negative for credits)
    netpr   DECIMAL(11,2)  NOT NULL,                  -- net unit price
    netwr   DECIMAL(15,2)  NOT NULL,                  -- net value (negative for credits)
    waerk   CHAR(3)        NOT NULL DEFAULT 'USD',    -- currency
    ernam   VARCHAR(12)    NOT NULL,                  -- created by
    vgbel   VARCHAR(10)    NULL,                      -- reference invoice (credit memos)
    PRIMARY KEY (vbeln, posnr),
    CONSTRAINT fk_bl_customer FOREIGN KEY (kunag) REFERENCES customers (kunnr) ON DELETE RESTRICT,
    CONSTRAINT fk_bl_material FOREIGN KEY (matnr) REFERENCES materials (matnr) ON DELETE RESTRICT,
    CHECK (fkart IN ('F2', 'G2')),
    CHECK ((fkart = 'F2' AND netwr >= 0) OR (fkart = 'G2' AND netwr <= 0))
);

-- ---------------------------------------------------------------------
-- 1.5 Indexes for the columns the audit tests filter on most
-- ---------------------------------------------------------------------
CREATE INDEX idx_bl_fkdat ON billing_lines (fkdat);
CREATE INDEX idx_bl_ernam ON billing_lines (ernam);

-- ---------------------------------------------------------------------
-- 1.6 Check the result
-- ---------------------------------------------------------------------
SHOW TABLES;
DESCRIBE billing_lines;

SELECT 'Step 1 complete: 4 tables created' AS status;
