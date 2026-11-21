-- =====================================================================
-- STEP 0 · Create the project database
-- Topics: CREATE DATABASE, USE, DROP
-- ⚠️ Drops and recreates olist_audit so the project can be rerun from scratch.
-- =====================================================================

DROP DATABASE IF EXISTS olist_audit;

CREATE DATABASE olist_audit
    CHARACTER SET utf8mb4;          -- Portuguese city names such as "são paulo"

USE olist_audit;

SELECT 'Step 0 complete: database olist_audit created' AS status;
