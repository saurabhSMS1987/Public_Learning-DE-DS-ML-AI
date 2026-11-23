# Databricks notebook source
# =============================================================================
# One-time setup: Unity Catalog objects for the Revenue & AR audit project
# -----------------------------------------------------------------------------
# Run this notebook once (on any compute) before creating the pipeline.
# It creates:
#   catalog  healthcare_audit
#     schema landing  -> volume raw_files (where the CSV extracts are uploaded)
#     schema bronze   -> raw tables      (written by the pipeline)
#     schema silver   -> clean tables    (written by the pipeline)
#     schema gold     -> audit outputs   (written by the pipeline)
# =============================================================================

CATALOG = "healthcare_audit"

spark.sql(f"CREATE CATALOG IF NOT EXISTS {CATALOG}")
for schema in ["landing", "bronze", "silver", "gold"]:
    spark.sql(f"CREATE SCHEMA IF NOT EXISTS {CATALOG}.{schema}")
spark.sql(f"CREATE VOLUME IF NOT EXISTS {CATALOG}.landing.raw_files")

# COMMAND ----------

# Create one folder per source system inside the volume.
# Upload the matching CSV files into each folder (Catalog > healthcare_audit >
# landing > raw_files > folder > "Upload to this volume").
SOURCES = ["billing_transactions", "gl_journal_entries", "chart_of_accounts",
           "claims", "encounters", "payers"]
for folder in SOURCES:
    dbutils.fs.mkdirs(f"/Volumes/{CATALOG}/landing/raw_files/{folder}")

display(dbutils.fs.ls(f"/Volumes/{CATALOG}/landing/raw_files"))

# COMMAND ----------

# Access control: auditors can read Gold only; the data engineering group owns
# everything else. Replace the group names with your own before running.
AUDITORS, ENGINEERS = "audit_team", "data_engineering"

# spark.sql(f"GRANT USE CATALOG ON CATALOG {CATALOG} TO `{AUDITORS}`")
# spark.sql(f"GRANT USE SCHEMA, SELECT ON SCHEMA {CATALOG}.gold TO `{AUDITORS}`")
# spark.sql(f"GRANT ALL PRIVILEGES ON CATALOG {CATALOG} TO `{ENGINEERS}`")
