"""
Run the exact pipeline source files (src/pipeline/*.py) on a laptop with plain
PySpark, to check the logic before deploying to Databricks.

How it works:
  * A small stand-in for `pyspark.pipelines` records each @dp.table /
    @dp.materialized_view function and its expectations.
  * Auto Loader (`spark.readStream.format("cloudFiles")`) is swapped for a normal
    batch CSV read of the same folder.
  * Tables are written to a local Spark catalog (spark_catalog.bronze/silver/gold).
  * Expectation results (rows passed / failed / dropped) are printed and saved,
    just like the pipeline event log in Databricks.
  * Gold tables are exported to CSV in ../outputs/.

Usage:
    python run_pipeline_locally.py --landing ../../work/landing --out ../outputs
"""

import argparse
import json
import sys
import types
from pathlib import Path

import pyspark
from pyspark.sql import SparkSession, functions as F

REGISTRY, EXPECTATION_LOG = [], []


# ---------------------------------------------------------------------------
# Stand-in for `from pyspark import pipelines as dp`
# ---------------------------------------------------------------------------

def _add_expectations(fn, rules, action):
    fn.__dict__.setdefault("_expectations", []).append((rules, action))
    return fn


def _dataset(kind):
    def decorator(name=None, comment=None, **_):
        def wrap(fn):
            REGISTRY.append({"name": name, "kind": kind, "fn": fn,
                             "expectations": list(reversed(fn.__dict__.get("_expectations", [])))})
            return fn
        return wrap
    return decorator


dp = types.ModuleType("pyspark.pipelines")
dp.table = _dataset("streaming table")
dp.materialized_view = _dataset("materialized view")
dp.expect = lambda n, c: lambda fn: _add_expectations(fn, {n: c}, "warn")
dp.expect_or_drop = lambda n, c: lambda fn: _add_expectations(fn, {n: c}, "drop")
dp.expect_or_fail = lambda n, c: lambda fn: _add_expectations(fn, {n: c}, "fail")
dp.expect_all = lambda r: lambda fn: _add_expectations(fn, r, "warn")
dp.expect_all_or_drop = lambda r: lambda fn: _add_expectations(fn, r, "drop")
dp.expect_all_or_fail = lambda r: lambda fn: _add_expectations(fn, r, "fail")
sys.modules["pyspark.pipelines"] = dp
pyspark.pipelines = dp


# ---------------------------------------------------------------------------
# Auto Loader stand-in: readStream.format("cloudFiles") -> batch CSV read
# ---------------------------------------------------------------------------

class _AutoLoaderShim:
    def __init__(self, spark):
        self._spark, self._fmt, self._opts = spark, None, {}

    def format(self, fmt):
        self._fmt = fmt
        return self

    def option(self, k, v):
        if k == "cloudFiles.format":
            self._fmt = v
        elif not k.startswith("cloudFiles."):
            self._opts[k] = v
        return self

    def load(self, path):
        return self._spark.read.format(self._fmt).options(**self._opts).load(path)


class _SparkShim:
    """Behaves like the `spark` object inside a Databricks pipeline."""
    def __init__(self, spark):
        self._spark = spark

    @property
    def readStream(self):
        return _AutoLoaderShim(self._spark)

    def __getattr__(self, item):
        return getattr(self._spark, item)


# ---------------------------------------------------------------------------
# Runner
# ---------------------------------------------------------------------------

def apply_expectations(df, ds):
    for rules, action in ds["expectations"]:
        for rule_name, cond in rules.items():
            failed = df.filter(f"NOT ({cond}) OR ({cond}) IS NULL").count()
            EXPECTATION_LOG.append({"dataset": ds["name"], "expectation": rule_name,
                                    "action": action, "failed_rows": failed})
            if failed and action == "fail":
                raise RuntimeError(f"Expectation {rule_name} failed on {ds['name']}")
        if action == "drop":
            combined = " AND ".join(f"({c})" for c in rules.values())
            df = df.filter(f"({combined}) IS TRUE")
    return df


def main(landing: Path, out: Path, repo_root: Path):
    spark = (SparkSession.builder.master("local[*]").appName("revenue-ar-audit-local")
             .config("spark.sql.warehouse.dir", str(out.parent / "local_warehouse"))
             .config("spark.sql.shuffle.partitions", "8")
             .config("spark.driver.memory", "4g")
             .config("audit.catalog", "spark_catalog")
             .config("audit.landing_path", str(landing.resolve()))
             .config("audit.fiscal_year", "2025")
             .getOrCreate())
    spark.sparkContext.setLogLevel("ERROR")
    for schema in ("bronze", "silver", "gold"):
        spark.sql(f"CREATE DATABASE IF NOT EXISTS {schema}")

    shim = _SparkShim(spark)
    for src in sorted((repo_root / "src" / "pipeline").glob("*.py")):
        REGISTRY.clear()
        exec(compile(src.read_text(), str(src), "exec"), {"spark": shim, "__name__": "pipeline"})
        for ds in REGISTRY:
            df = apply_expectations(ds["fn"](), ds)
            df.write.mode("overwrite").saveAsTable(ds["name"])
            n = spark.read.table(ds["name"]).count()
            print(f"{ds['kind']:<18} {ds['name']:<55} {n:>9,} rows")

    out.mkdir(parents=True, exist_ok=True)
    for t in spark.catalog.listTables("gold"):
        spark.read.table(f"gold.{t.name}").toPandas().to_csv(out / f"gold_{t.name}.csv", index=False)
    spark.read.table("silver.billing_transactions_quarantine").drop("_source_file", "_ingested_at") \
        .toPandas().to_csv(out / "silver_billing_transactions_quarantine.csv", index=False)
    (out / "expectation_results.json").write_text(json.dumps(EXPECTATION_LOG, indent=2))
    print("\nExpectations:")
    for e in EXPECTATION_LOG:
        print(f"  {e['dataset']:<45} {e['expectation']:<32} {e['action']:<5} failed={e['failed_rows']}")


if __name__ == "__main__":
    p = argparse.ArgumentParser()
    p.add_argument("--landing", type=Path, required=True)
    p.add_argument("--out", type=Path, required=True)
    a = p.parse_args()
    main(a.landing, a.out, Path(__file__).resolve().parents[1])
