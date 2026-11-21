-- =====================================================================
-- Setup: create the journal_entries table and load the sample data.
-- Run from this folder with the mysql command-line client:
--   mysql --local-infile=1 -u root -p < setup.sql
-- In MySQL Workbench: replace 'data/...' with the full path (forward slashes)
-- and enable OPT_LOCAL_INFILE=1 on the connection.
-- =====================================================================
CREATE DATABASE IF NOT EXISTS audit_fy2026;
USE audit_fy2026;

DROP TABLE IF EXISTS journal_entries;

-- SAP S/4HANA Universal Journal lines (like table ACDOCA)
-- Some columns are kept exactly as extracted (raw text) so they can be transformed.
CREATE TABLE journal_entries (
    rbukrs       CHAR(4)        NOT NULL,   -- company code
    gjahr        SMALLINT       NOT NULL,   -- fiscal year
    belnr        VARCHAR(10)    NOT NULL,   -- document number
    docln        CHAR(6)        NOT NULL,   -- line item
    blart        CHAR(2)        NOT NULL,   -- document type (KR vendor invoice, KZ payment, SA G/L)
    budat        DATE           NOT NULL,   -- posting date
    bldat        VARCHAR(8)     NOT NULL,   -- document date, RAW SAP format YYYYMMDD
    cpudt        DATETIME       NOT NULL,   -- entry date and time (when it was keyed in)
    racct        VARCHAR(10)    NOT NULL,   -- G/L account
    rcntr        VARCHAR(10)    NULL,       -- cost center
    lifnr        VARCHAR(10)    NULL,       -- vendor number, RAW (some without leading zeros)
    vendor_name  VARCHAR(40)    NULL,       -- vendor name, RAW (inconsistent case/spaces)
    drcrk        CHAR(1)        NOT NULL,   -- S debit, H credit
    hsl          DECIMAL(15,2)  NOT NULL,   -- amount in local currency (debit +, credit -)
    rhcur        CHAR(3)        NOT NULL,   -- local currency
    xblnr        VARCHAR(16)    NULL,       -- reference (vendor invoice number), RAW
    sgtxt        VARCHAR(50)    NOT NULL,   -- line text, RAW
    usnam        VARCHAR(12)    NOT NULL,   -- user, RAW (mixed case)
    tcode        VARCHAR(20)    NOT NULL,   -- transaction code
    PRIMARY KEY (rbukrs, gjahr, belnr, docln)
);

LOAD DATA LOCAL INFILE 'data/s4hana_journal_entries_fy2026.csv'
INTO TABLE journal_entries
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(rbukrs, gjahr, belnr, docln, blart, budat, bldat, cpudt, racct, @rcntr, @lifnr,
 @vendor_name, drcrk, hsl, rhcur, @xblnr, sgtxt, usnam, tcode)
SET rcntr       = NULLIF(@rcntr, ''),          -- blank → NULL
    lifnr       = NULLIF(@lifnr, ''),
    vendor_name = NULLIF(@vendor_name, ''),    -- spaces inside names are kept on purpose
    xblnr       = NULLIF(@xblnr, '');

SHOW WARNINGS;
SELECT COUNT(*)              AS line_count,     -- 28
       COUNT(DISTINCT belnr) AS documents,      -- 14
       SUM(hsl)              AS balance         -- 0.00 (debits = credits)
FROM journal_entries;
