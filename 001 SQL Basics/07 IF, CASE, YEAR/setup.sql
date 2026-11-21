-- =====================================================================
-- Setup: create the cwip_assets table and load the sample data.
-- Run from this folder with the mysql command-line client:
--   mysql --local-infile=1 -u root -p < setup.sql
-- In MySQL Workbench: replace 'data/sap_cwip_fy2026.csv' with the full path
-- (forward slashes) and enable OPT_LOCAL_INFILE=1 on the connection.
-- =====================================================================
CREATE DATABASE IF NOT EXISTS audit_fy2026;
USE audit_fy2026;

DROP TABLE IF EXISTS cwip_assets;
CREATE TABLE cwip_assets (
    anln1         VARCHAR(12)    NOT NULL,   -- asset under construction (AuC) number
    txt50         VARCHAR(50)    NOT NULL,   -- description
    posid         VARCHAR(24)    NOT NULL,   -- WBS element / project
    proj_type     VARCHAR(20)    NOT NULL,   -- Building, Machinery, IT, Vehicles
    werks         CHAR(4)        NOT NULL,   -- plant
    start_date    DATE           NOT NULL,   -- project start
    plan_end      DATE           NOT NULL,   -- planned completion
    act_end       DATE           NULL,       -- actual completion (NULL = not finished)
    status        CHAR(4)        NOT NULL,   -- REL released, TECO technically complete, CLSD closed
    budget        DECIMAL(15,2)  NOT NULL,
    cost_to_date  DECIMAL(15,2)  NOT NULL,   -- costs capitalised on the AuC
    settled       DECIMAL(15,2)  NOT NULL,   -- amount settled to final fixed assets
    last_post     DATE           NULL,       -- last cost posting (NULL = no postings)
    resp          VARCHAR(20)    NOT NULL,   -- person responsible
    PRIMARY KEY (anln1)
);

LOAD DATA LOCAL INFILE 'data/sap_cwip_fy2026.csv'
INTO TABLE cwip_assets
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(anln1, txt50, posid, proj_type, werks, start_date, plan_end, @act_end,
 status, budget, cost_to_date, settled, @last_post, resp)
SET act_end   = NULLIF(@act_end, ''),        -- blank → NULL
    last_post = NULLIF(@last_post, '');

SHOW WARNINGS;
SELECT COUNT(*) AS rows_loaded,                        -- 24
       SUM(cost_to_date - settled) AS cwip_balance     -- 9,649,250.00
FROM cwip_assets;
