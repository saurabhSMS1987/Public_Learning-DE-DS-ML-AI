# Databricks notebook source
# =============================================================================
# SILVER LAYER: cleaned, typed and linked data
# -----------------------------------------------------------------------------
# What happens here:
#   1. Convert text columns to proper types (dates, decimals)
#   2. Remove technical duplicates (the same transaction_id loaded twice)
#   3. Apply data quality rules ("expectations"):
#        - rows that pass go to the clean table
#        - rows that fail go to a quarantine table for follow-up,
#          so nothing silently disappears
#   4. Link each billing transaction to its claim and payer
# =============================================================================

from pyspark import pipelines as dp
from pyspark.sql import functions as F
from pyspark.sql.window import Window

CATALOG = spark.conf.get("audit.catalog", "healthcare_audit")
BRONZE, SILVER = f"{CATALOG}.bronze", f"{CATALOG}.silver"

MONEY = "DECIMAL(18,2)"


def to_date(col_name: str):
    """Text -> DATE; anything that isn't a valid yyyy-MM-dd becomes NULL."""
    return F.to_date(F.try_to_timestamp(F.col(col_name), F.lit("yyyy-MM-dd")))


def to_money(col_name: str):
    return F.expr(f"try_cast({col_name} AS {MONEY})")


# -----------------------------------------------------------------------------
# Claims master: claim -> encounter -> payer
# -----------------------------------------------------------------------------

@dp.materialized_view(
    name=f"{SILVER}.claims",
    comment="One row per claim with its encounter and payer.",
)
@dp.expect_or_drop("claim_id_present", "claim_id IS NOT NULL")
@dp.expect("payer_found", "payer_name IS NOT NULL")
def silver_claims():
    claims = spark.read.table(f"{BRONZE}.claims").select(
        F.col("Id").alias("claim_id"),
        F.col("PATIENTID").alias("patient_id"),
        F.col("APPOINTMENTID").alias("encounter_id"),
        F.to_date(F.col("SERVICEDATE").substr(1, 10)).alias("claim_service_date"),
    ).dropDuplicates(["claim_id"])

    encounters = spark.read.table(f"{BRONZE}.encounters").select(
        F.col("Id").alias("encounter_id"),
        F.col("PAYER").alias("payer_id"),
        F.col("ENCOUNTERCLASS").alias("encounter_class"),
        F.col("ORGANIZATION").alias("organization_id"),
    ).dropDuplicates(["encounter_id"])

    payers = spark.read.table(f"{BRONZE}.payers").select(
        F.col("Id").alias("payer_id"),
        F.col("NAME").alias("payer_name"),
        F.col("OWNERSHIP").alias("payer_type"),      # GOVERNMENT / PRIVATE / NO_INSURANCE
    ).dropDuplicates(["payer_id"])

    return (claims
            .join(encounters, "encounter_id", "left")
            .join(payers, "payer_id", "left"))


# -----------------------------------------------------------------------------
# Billing subledger: typed, de-duplicated, validated
# -----------------------------------------------------------------------------

BILLING_RULES = {
    "amount_present_and_positive": "amount IS NOT NULL AND amount > 0",
    "posting_date_valid": "posting_date IS NOT NULL",
    "service_date_valid": "service_date IS NOT NULL",
    "transaction_type_valid": "transaction_type IN ('CHARGE', 'PAYMENT')",
}
ALL_RULES_PASS = " AND ".join(f"({r})" for r in BILLING_RULES.values())


def typed_billing():
    """Bronze billing rows with proper types and technical duplicates removed."""
    latest_first = Window.partitionBy("transaction_id").orderBy(F.col("_ingested_at").desc())
    return (
        spark.read.table(f"{BRONZE}.billing_transactions")
        .withColumn("_rn", F.row_number().over(latest_first))
        .filter("_rn = 1")                                    # drop exact re-loaded duplicates
        .select(
            "transaction_id", "claim_id", "charge_line_id", "patient_id",
            F.upper(F.trim("transaction_type")).alias("transaction_type"),
            to_date("service_date").alias("service_date"),
            to_date("posting_date").alias("posting_date"),
            F.col("posting_date").alias("posting_date_raw"),
            to_money("amount").alias("amount"),
            "payment_method", "procedure_code", "procedure_description", "department_id",
            "_source_file", "_ingested_at",
        )
    )


@dp.materialized_view(
    name=f"{SILVER}.billing_transactions",
    comment="Clean billing transactions linked to claim and payer. Rows failing data quality rules are dropped here and kept in billing_transactions_quarantine.",
)
@dp.expect_all_or_drop(BILLING_RULES)
def silver_billing_transactions():
    claims = spark.read.table(f"{SILVER}.claims").select(
        "claim_id", "encounter_class", "payer_id", "payer_name", "payer_type")
    return (
        typed_billing()
        .join(claims, "claim_id", "left")
        .withColumn("has_matching_claim", F.col("payer_type").isNotNull())
        .withColumn("posting_period", F.date_format("posting_date", "yyyy-MM"))
    )


@dp.materialized_view(
    name=f"{SILVER}.billing_transactions_quarantine",
    comment="Billing rows that failed at least one data quality rule, with the reason.",
)
def silver_billing_quarantine():
    return (
        typed_billing()
        .filter(f"NOT ({ALL_RULES_PASS}) OR ({ALL_RULES_PASS}) IS NULL")
        .withColumn(
            "quarantine_reason",
            F.when(F.col("amount").isNull(), "Missing amount")
             .when(F.col("amount") <= 0, "Zero or negative amount")
             .when(F.col("posting_date").isNull(), "Invalid posting date")
             .when(F.col("service_date").isNull(), "Invalid service date")
             .otherwise("Invalid transaction type"),
        )
    )


# -----------------------------------------------------------------------------
# General ledger: typed journal lines with account names
# -----------------------------------------------------------------------------

@dp.materialized_view(
    name=f"{SILVER}.gl_journal_lines",
    comment="Typed GL journal entry lines joined to the chart of accounts.",
)
@dp.expect_or_drop("posting_date_valid", "posting_date IS NOT NULL")
@dp.expect_or_drop("amounts_not_negative", "debit >= 0 AND credit >= 0")
@dp.expect("account_in_chart_of_accounts", "account_name IS NOT NULL")
def silver_gl_journal_lines():
    coa = spark.read.table(f"{BRONZE}.chart_of_accounts").select(
        "account_number", "account_name", "account_type", "fs_line"
    ).dropDuplicates(["account_number"])

    return (
        spark.read.table(f"{BRONZE}.gl_journal_entries")
        .select(
            "je_id",
            F.col("je_line").cast("int").alias("je_line"),
            to_date("posting_date").alias("posting_date"),
            "fiscal_period", "account_number",
            to_money("debit").alias("debit"),
            to_money("credit").alias("credit"),
            "je_source", "batch_reference", "created_by",
            F.try_to_timestamp(F.col("created_at")).alias("created_at"),
            "description",
        )
        .dropDuplicates(["je_id", "je_line"])
        .join(coa, "account_number", "left")
        .withColumn("net_debit", F.col("debit") - F.col("credit"))
        .withColumn("is_manual", F.col("je_source") == "MANUAL")
    )
