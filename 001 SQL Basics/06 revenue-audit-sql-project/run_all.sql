-- =====================================================================
-- Run the whole project in one go (MySQL command-line client).
--
-- From the project root folder:
--   mysql --local-infile=1 -u root -p --table < run_all.sql
--
-- SOURCE is a mysql client command, so this file does not run in
-- MySQL Workbench: there, open and run the scripts in sql/ in order.
-- =====================================================================
SOURCE sql/00_create_database.sql
SOURCE sql/01_create_tables.sql
SOURCE sql/02_load_data.sql
SOURCE sql/03_data_quality_checks.sql
SOURCE sql/04_transform_and_load.sql
SOURCE sql/05_exploration.sql
SOURCE sql/06_summary_analytics.sql
SOURCE sql/07_having_analysis.sql
SOURCE sql/08_audit_tests.sql
SOURCE sql/09_findings_and_export.sql
