-- =====================================================================
-- STEP 0 · Create the project database
-- Topics: CREATE DATABASE, USE
-- ⚠️ Drops and recreates revenue_audit, so the project can be rerun from scratch.
-- =====================================================================

DROP DATABASE IF EXISTS revenue_audit;

CREATE DATABASE revenue_audit
    CHARACTER SET utf8mb4;          -- keeps names such as "Müller GmbH" intact

USE revenue_audit;

SELECT 'Step 0 complete: database revenue_audit created' AS status;
