# Introduction to Databricks

> Study notes summarizing an introductory deck on Databricks: what the platform is, how its layers fit together, and how it supports data engineering and GenAI work.

---

## Table of Contents

1. [What is Databricks?](#1-what-is-databricks)
2. [The Databricks Data Intelligence Platform](#2-the-databricks-data-intelligence-platform)
3. [Concept of a Data Lake](#3-concept-of-a-data-lake)
4. [Delta Lake and Parquet: The Storage Layer](#4-delta-lake-and-parquet-the-storage-layer)
5. [Apache Spark: The Data Processing Engine](#5-apache-spark-the-data-processing-engine)
6. [Unity Catalog: The Data Governance Layer](#6-unity-catalog-the-data-governance-layer)
7. [Data Engineering with Databricks](#7-data-engineering-with-databricks)
8. [GenAI Engineering with Databricks](#8-genai-engineering-with-databricks)
9. [Conclusion](#9-conclusion)
10. [Key Takeaways](#10-key-takeaways)
11. [Industry Examples](#11-industry-examples)
12. [Glossary](#12-glossary)

---

## 1. What is Databricks?

**Databricks is a unified, open analytics platform for building, deploying, sharing, and maintaining enterprise-grade data, analytics, and AI solutions at scale.**

- It **integrates with the cloud storage and security in your own cloud account** (AWS, Azure, or GCP).
- It **manages and deploys the cloud infrastructure for you**, so you don't hand-build clusters.
- It is **committed to open source**: Databricks maintains its open-source integrations (Spark, Delta Lake, MLflow, and others) and ships updates through **Databricks Runtime** releases.

---

## 2. The Databricks Data Intelligence Platform

The platform is easiest to understand as a stack of three layers:

```
┌──────────────────────────────────────────────────────────────┐
│  AI / BI LAYER                                               │
│  Mosaic AI · DB SQL · Lakebase · AI/BI · Lakeflow · Apps ·   │
│  Marketplace                                                 │
├──────────────────────────────────────────────────────────────┤
│  DATA GOVERNANCE LAYER                                       │
│  Unity Catalog                                               │
├──────────────────────────────────────────────────────────────┤
│  DATA STORAGE & DATA PROCESSING LAYER                        │
│  Delta Lake · Apache Iceberg · Parquet  (+ Spark engine)     │
└──────────────────────────────────────────────────────────────┘
                     = THE LAKEHOUSE
```

| Product | What it does |
|---|---|
| **Mosaic AI** | Artificial intelligence: building, serving and governing ML/GenAI |
| **DB SQL** | Data warehousing and SQL analytics |
| **Lakebase** | Transactional (operational) database |
| **AI/BI** | Business intelligence dashboards and natural-language analytics |
| **Lakeflow** | Ingestion, ETL and streaming |
| **Apps** | Secure data and AI applications |
| **Marketplace** | Data and AI marketplace for sharing and acquiring datasets and models |

---

## 3. Concept of a Data Lake

A **Data Lake** is a centralized storage system for all types of data.

- Stores data in its **raw, native format**.
- Scales **cheaply and almost without limit** on cloud object storage.
- Holds vast amounts of **structured** (tables), **semi-structured** (JSON, CSV, logs) and **unstructured** (images, audio, PDFs) data.

### Schema-on-Read

| | Schema-on-Write (traditional warehouse) | Schema-on-Read (data lake) |
|---|---|---|
| When is the schema applied? | Before data is loaded | At query or processing time |
| Ingestion speed | Slower, because data must conform first | Faster, because you just land the data |
| Flexibility | Rigid | Adapts to evolving data sources |

**The catch:** a plain data lake has no transactions, no enforcement and no versioning, so it can easily turn into a "data swamp". Delta Lake fixes that.

---

## 4. Delta Lake and Parquet: The Storage Layer

### How it's built
- **Delta Lake is built on top of Parquet files.**
- The actual data is stored as **immutable Parquet files** in cloud storage (**ADLS / S3 / GCS**).
- A **Delta table is not a single file but a folder structure**:

```
my_table/
├── _delta_log/                 ← transaction log (JSON commits + checkpoints)
│   ├── 00000000000000000000.json
│   └── 00000000000000000001.json
├── part-00000-....snappy.parquet
├── part-00001-....snappy.parquet
└── ...
```

### Why it matters
- Databricks provides the **Delta Lake engine**.
- Delta Lake brings **ACID transactions** to data lake storage.
- It makes lake data **more accountable**: every change is recorded in the transaction log, which enables time travel, auditing and rollback.

### The key equation

> **Data Lake + Delta Lake = Data Lakehouse**

You get the low cost and flexibility of a lake together with the reliability and performance of a warehouse.

---

## 5. Apache Spark: The Data Processing Engine

- **Apache Spark** is a **distributed data processing engine**.
- It is designed to **process large datasets in parallel**.
- It works natively with data in **data lakes and Delta Lake**.

### How Spark processes data

```
            Input data
                │
   ┌────────────┼────────────┐
   ▼            ▼            ▼
Partition 1  Partition 2  Partition N
   │            │            │
Worker 1     Worker 2     Worker N     ← processed in parallel
   └────────────┼────────────┘
                ▼
              Result
```

1. Input data is **split into partitions**.
2. Each partition is **processed in parallel** across multiple machines (worker nodes), coordinated by a **driver**.
3. This gives **horizontal scalability**: more data means adding more machines, not buying a bigger one.

---

## 6. Unity Catalog: The Data Governance Layer

**Unity Catalog** is Databricks' **centralized governance layer**.

- Provides **fine-grained access control** across **all data and AI assets** (tables, views, volumes/files, ML models, functions).
- Works **across multiple workspaces from a single metastore**.

### What Unity Catalog is and isn't

| ❌ Unity Catalog is NOT | ✅ Unity Catalog IS |
|---|---|
| Compute | Governance |
| Storage | Access control |

> **One metastore → multiple workspaces → consistent security**

Objects follow a three-level namespace: `catalog.schema.table` (for example `prod.sales.orders`).

---

## 7. Data Engineering with Databricks

### Spark Declarative Pipelines (formerly Delta Live Tables)

A **declarative** way to build pipelines: **you define *what* the data should look like, not *how* to run it.**

Databricks handles:
- Automatic operations
- Dependency management between tables
- Data quality checks (expectations)
- Observability and monitoring
- Incremental processing

### Lakeflow Jobs

The **orchestration layer** for pipelines. It handles:
- **Triggers**: scheduled, continuous, or event-based
- **Control flow and dependencies** between tasks
- **Observability and retries**
- **Serverless execution**
- **Governance by Unity Catalog**

> Mental model: **Declarative Pipelines = the "what"** (transformations). **Lakeflow Jobs = the "when and in what order"** (orchestration).

---

## 8. GenAI Engineering with Databricks

Databricks supports several approaches to GenAI development. They **increase in complexity and compute cost** from left to right:

```
Prompt Engineering  →  RAG  →  Fine-tuning  →  Pre-training
   (simplest/cheapest)                       (most complex/expensive)
```

| Approach | What it means |
|---|---|
| **Prompt engineering** | Crafting specialized prompts and pipelines to guide GenAI behavior |
| **Retrieval Augmented Generation (RAG)** | Combining an LLM with custom enterprise data |
| **Fine-tuning** | Adapting a pre-trained model to specific datasets or domains |
| **Pre-training** | Training a GenAI model from scratch |

> Most enterprise use cases **start simple** (prompting or RAG) and **evolve over time**.

### Mosaic AI Model Serving

A **unified serving layer for GenAI workloads** that supports:

| Category | Examples |
|---|---|
| **External models** | OpenAI, Anthropic, AI21 Labs, Cohere |
| **Databricks-hosted models** | Meta (Llama), Mistral, Databricks models |
| **Agents and chains** | LangChain, LlamaIndex, MLflow |

It is **production-ready**, with built-in **scaling, monitoring and governance** (through Mosaic AI Gateway and Unity Catalog).

---

## 9. Conclusion

Databricks is a **unified Data Intelligence Platform** that brings together:

- 🛠️ **Data Engineering**
- 📊 **Analytics & BI**
- 🤖 **Machine Learning**
- ✨ **GenAI workloads**

…all **built on the Lakehouse architecture**.

---

## 10. Key Takeaways

1. **One platform, many workloads.** Databricks removes the need for separate systems for ETL, warehousing, BI, ML and GenAI.
2. **Lakehouse = Data Lake + Delta Lake.** Cheap, open cloud storage combined with warehouse-grade reliability (ACID, schema enforcement, time travel).
3. **Your data stays open and in your cloud.** It is stored as Parquet in *your* S3/ADLS/GCS account, which avoids proprietary lock-in.
4. **A Delta table is a folder, not a file.** Parquet data files plus a `_delta_log` transaction log, and the log is what gives you ACID.
5. **Schema-on-read gives flexibility; Delta adds discipline.** Land data fast, then enforce quality as it moves through your pipeline.
6. **Spark scales horizontally.** Partitions are processed in parallel across workers, so more data means more machines.
7. **Unity Catalog is governance only.** It is not compute or storage. One metastore gives consistent security across all workspaces.
8. **Declare, don't orchestrate by hand.** Declarative Pipelines define the "what"; Lakeflow Jobs handle the "when".
9. **GenAI is a ladder.** Start with prompt engineering or RAG and move to fine-tuning or pre-training only when needed, because cost and complexity rise at each step.
10. **Model-agnostic serving.** Mosaic AI Model Serving lets you mix external, hosted and custom models and agents behind one governed endpoint.

---

## 11. Industry Examples

How the lakehouse pattern is typically applied across industries:

| Industry | Typical use case | Databricks components involved |
|---|---|---|
| **Retail & E-commerce** | Demand forecasting, product recommendations, real-time inventory, customer 360 | Lakeflow (streaming POS/clickstream), Delta Lake, MLflow, AI/BI dashboards |
| **Financial Services** | Real-time fraud detection, credit risk modelling, regulatory reporting, AML | Spark Structured Streaming, Delta time travel (audit trails), Unity Catalog (fine-grained access, lineage) |
| **Healthcare & Life Sciences** | Genomics processing, clinical trial analytics, drug discovery, RAG over medical literature | Spark at scale, Unity Catalog (PHI/PII governance), Mosaic AI (RAG, fine-tuning) |
| **Media & Entertainment** | Content personalization, viewer churn prediction, ad targeting | Delta Lake on clickstream data, ML feature engineering, Model Serving |
| **Manufacturing & Energy** | Predictive maintenance from IoT sensors, supply-chain optimization, energy forecasting | Streaming ingestion with Lakeflow, Declarative Pipelines, ML models |
| **Telecommunications** | Network performance monitoring, churn prediction, GenAI customer-support agents | Large-scale log processing in Spark, Mosaic AI agents, DB SQL |
| **Transportation & Logistics** | Route optimization, ETA prediction, fleet telemetry analytics | Streaming plus Delta, geospatial processing, ML |

### Example end-to-end flow (retail)

```
POS + web clickstream ──► Lakeflow ingestion ──► Bronze (raw Delta)
                                                     │  Declarative Pipelines
                                                     ▼  (quality checks)
                                                 Silver (cleaned)
                                                     │
                                                     ▼
                                                 Gold (aggregated)
                                         ┌───────────┼─────────────┐
                                         ▼           ▼             ▼
                                   AI/BI dashboard  Forecast   RAG shopping
                                   (DB SQL)         model       assistant
                                                  (MLflow)    (Mosaic AI)
            ── all governed by Unity Catalog; orchestrated by Lakeflow Jobs ──
```

> **Note:** Bronze → Silver → Gold is the **Medallion Architecture**, the standard way of layering data quality in a Databricks lakehouse. It is worth learning next.

---

## 12. Glossary

| Term | Meaning |
|---|---|
| **Lakehouse** | Architecture combining data lake storage with data warehouse capabilities |
| **Delta Lake** | Open-source storage layer adding ACID transactions to Parquet files |
| **Parquet** | Open, columnar file format optimized for analytics |
| **ACID** | Atomicity, Consistency, Isolation, Durability: guarantees for reliable transactions |
| **Schema-on-read** | Schema applied when data is queried, not when it's written |
| **Partition** | A chunk of data that Spark processes independently and in parallel |
| **Metastore** | Top-level container of metadata in Unity Catalog |
| **Databricks Runtime** | The packaged set of Spark and libraries that runs on Databricks clusters |
| **RAG** | Retrieval Augmented Generation: feeding relevant enterprise data to an LLM at query time |
| **Serverless** | Compute that Databricks provisions and scales for you automatically |

---

*Notes compiled from the "Introduction to Databricks" presentation as part of my Databricks learning journey.*
