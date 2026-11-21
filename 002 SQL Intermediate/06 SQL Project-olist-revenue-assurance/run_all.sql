-- =====================================================================
-- Run the whole project in one go (MySQL command-line client).
--
-- From the project root folder:
--   mysql --local-infile=1 -u root -p --table < run_all.sql > output.txt
--
-- SOURCE is a mysql client command, so this file does not run in
-- MySQL Workbench: there, open and run the scripts in sql/ in order.
-- =====================================================================
SOURCE sql/00_create_database.sql
SOURCE sql/01_create_tables.sql
SOURCE sql/02_load_staging.sql
SOURCE sql/03_data_quality_checks.sql
SOURCE sql/04_transform_and_load.sql
SOURCE sql/05_exploration.sql
SOURCE sql/06_summary_and_calculated_columns.sql
SOURCE sql/07_joins.sql
SOURCE sql/08_multi_table_and_transformations.sql
SOURCE sql/09_analytics.sql
SOURCE sql/10_audit_tests.sql
SOURCE sql/11_findings_and_export.sql
