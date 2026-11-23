# Databricks notebook source
# =============================================================================
# BRONZE LAYER: raw data, loaded as is
# -----------------------------------------------------------------------------
# Every source folder in the landing volume becomes one streaming table.
# Auto Loader picks up new monthly files automatically each time the pipeline
# runs, so next month's extract only needs to be dropped into the folder.
#
# Bronze rules:
#   * keep every column as a STRING (no type conversion, nothing dropped)
#   * add lineage columns: which file a row came from and when it was loaded
# =============================================================================

from pyspark import pipelines as dp
from pyspark.sql import functions as F

CATALOG = spark.conf.get("audit.catalog", "healthcare_audit")
LANDING = spark.conf.get("audit.landing_path", f"/Volumes/{CATALOG}/landing/raw_files")
BRONZE = f"{CATALOG}.bronze"


def autoload_csv(folder: str):
    """Incrementally read every CSV file in a landing folder with Auto Loader."""
    return (
        spark.readStream.format("cloudFiles")
        .option("cloudFiles.format", "csv")
        .option("cloudFiles.inferColumnTypes", "false")   # keep everything as text
        .option("header", "true")
        .load(f"{LANDING}/{folder}")
        .withColumn("_source_file", F.col("_metadata.file_path"))
        .withColumn("_ingested_at", F.current_timestamp())
    )


# -- Financial data -----------------------------------------------------------

@dp.table(
    name=f"{BRONZE}.billing_transactions",
    comment="Raw patient accounting subledger extract (charges and payments), one file per posting month.",
)
def bronze_billing_transactions():
    return autoload_csv("billing_transactions")


@dp.table(
    name=f"{BRONZE}.gl_journal_entries",
    comment="Raw general ledger journal entry lines, one file per fiscal period.",
)
def bronze_gl_journal_entries():
    return autoload_csv("gl_journal_entries")


@dp.table(
    name=f"{BRONZE}.chart_of_accounts",
    comment="Raw GL chart of accounts.",
)
def bronze_chart_of_accounts():
    return autoload_csv("chart_of_accounts")


# -- Master data from Synthea -------------------------------------------------

@dp.table(name=f"{BRONZE}.claims", comment="Raw Synthea claims.")
def bronze_claims():
    return autoload_csv("claims")


@dp.table(name=f"{BRONZE}.encounters", comment="Raw Synthea encounters (visits).")
def bronze_encounters():
    return autoload_csv("encounters")


@dp.table(name=f"{BRONZE}.payers", comment="Raw Synthea payers (insurers).")
def bronze_payers():
    return autoload_csv("payers")
