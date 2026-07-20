# Data Engineering with Apache Projects Hands-On Implementations

![Spark](https://img.shields.io/badge/Apache%20Spark-E25A1C?logo=apachespark&logoColor=white)
![Iceberg](https://img.shields.io/badge/Apache%20Iceberg-1B98E0?logo=apacheiceberg&logoColor=white)
![Kafka](https://img.shields.io/badge/Apache%20Kafka-231F20?logo=apachekafka&logoColor=white)
![Flink](https://img.shields.io/badge/Apache%20Flink-E6526F?logo=apacheflink&logoColor=white)
![Airflow](https://img.shields.io/badge/Apache%20Airflow-017CEE?logo=apacheairflow&logoColor=white)
![Trino](https://img.shields.io/badge/Trino-DD00A1?logo=trino&logoColor=white)
![ClickHouse](https://img.shields.io/badge/ClickHouse-FFCC01?logo=clickhouse&logoColor=black)
![Postgres](https://img.shields.io/badge/PostgreSQL-4169E1?logo=postgresql&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?logo=python&logoColor=white)

A collection of **10 end-to-end data engineering projects** I built to work through the full modern open-source stack from lakehouse storage and batch ETL, through real-time streaming and CDC, to ML feature engineering and vector search.

Every project runs locally as a self-contained Docker Compose environment, so each pipeline is reproducible end to end: spin it up, load data, run, and tear it down resources.

---

## Why I built this

Most data engineering tutorials stop at "here's the syntax." I wanted to understand the **primitives**  how ingestion, storage, transformation, and serving actually fit together because those primitives are what the managed cloud platforms are built on top of.

Working on these projects alongside going deep on **Snowflake** (storage integrations, Snowpipe, dynamic tables), something clicked: the modern cloud warehouses (Snowflake, Databricks) are essentially productized versions of these same open-source ideas. Snowpipe is event-driven ingestion. Dynamic tables are materialized transformations. A lakehouse table format like Iceberg is what powers the "table" abstraction underneath.

Learning the open-source building blocks first makes the managed platforms feel intuitive rather than magical and that's the foundation I try to build everything on.

---

## The Projects

### Part 1 - Lakehouse, Batch ETL & Orchestration

**1. [Implementing the Data Lakehouse](./Implementing%20the%20Data%20Lakehouse%20(Chapter%2002))**
Built an **Apache Iceberg** lakehouse from the ground up. Created databases and Iceberg tables, wrote and queried records via PyIceberg and the PyIceberg CLI, and established the storage foundation that every later project builds on.

**2. [ETL Pipeline with Apache Spark](./ETL%20Pipeline%20with%20Apache%20Spark%20(chapter-03))**
Modeled the lakehouse using a **Medallion architecture** (bronze → silver → gold). Implemented batch **PySpark** ETL to load raw data into the bronze layer from Postgres and MinIO, then cleaned, denormalized, and enriched it into validated silver tables.

**3. [Data Visualization with Apache Superset](./Data%20Visualization%20with%20Apache%20Superset%20(Chapter%20-%2004))**
Defined **gold-layer** business tables using **Trino** as a distributed query engine over the lakehouse, then built BI dashboards in **Apache Superset** to surface KPIs.

**4. [ETL Orchestration with Apache Airflow](./ETL%20Orchestration%20with%20Apache%20Airflow%20(Chapter-05))**
Built an **Airflow** DAG that computes customer segments from the silver tables, exports the results to **MinIO** as CSV, and sends a completion notification including configuring TLS/HTTPS and the Trino connection for the orchestration layer.

### Part 2 - Streaming & Real-Time Analytics

**5. [Real-time Change Data Capture with Kafka & Debezium](./Real-time%20Change%20Data%20Capture%20with%20Kafka%20and%20Debezium%20(Chapter%20-%2006))**
Implemented a **CDC** pipeline that captures inventory changes from **Postgres** using **Debezium**, streams them through **Kafka**, transforms the change events, and reliably keeps an **OpenSearch** index in sync.

**6. [Low-Latency Real-time Analytics Dashboard with ClickHouse](./Low-Latency%20Real-time%20Analytics%20Dashboard%20with%20ClickHouse%20(chapter-07))**
Built a real-time flash-sale analytics pipeline: a change feed streamed through **Kafka** into **ClickHouse** for low-latency aggregation, visualized live in a **Streamlit** dashboard.

**7. [Streaming ETL & Anomaly Detection with Apache Flink](./Streaming%20ETL%20and%20Anomaly%20Detection%20with%20Apache%20Flink%20(chapter-08))**
Built a stateful stream-processing job with **Kafka + Apache Flink** (Flink SQL) to detect user-login anomalies in real time as events flow through the system.

### Part 3 - Data Engineering for AI & ML

**8. [Product Recommendation Engine with Spark MLlib](./Building%20a%20Product%20Recommendation%20Engine%20with%20Spark%20MLlib%20(chapter-09))**
Built a feature-engineering pipeline on the silver-layer data and trained an **ALS** collaborative-filtering model with **Spark MLlib**, storing the refined features in the gold layer and serving recommendations via a Flask endpoint.

**9. [Vector Similarity Search with Postgres & pgvector](./Vector%20Similarity%20Search%20with%20Postgres%20and%20pgvector%20(Ch%20-10))**
Implemented a **semantic similarity search** engine over customer reviews: generated vector embeddings and ran similarity queries using the **pgvector** extension on Postgres.

---

## Tech Stack

| Layer | Technologies |
|---|---|
| **Storage / Lakehouse** | Apache Iceberg, MinIO (S3), PostgreSQL |
| **Batch Processing** | Apache Spark / PySpark |
| **Query & Serving** | Trino, Apache Superset, Streamlit, Flask |
| **Streaming & Messaging** | Apache Kafka, Kafka Connect, Debezium |
| **Stream Processing** | Apache Flink (Flink SQL), ClickHouse |
| **Orchestration** | Apache Airflow |
| **ML / AI** | Spark MLlib (ALS), pgvector, OpenSearch |
| **Infra & Languages** | Docker Compose, Python, Java, SQL, YAML |

---

## Running the Projects

Every project is a self-contained **Docker Compose** stack — isolated, reproducible, and easy to tear down.

**Prerequisites**
- Docker Engine `20.10+`
- Docker Compose `2.0+`
- Recommended: 4+ CPU cores (8 for Spark-heavy projects), 8 GB+ RAM (16 GB recommended), 20 GB free disk

**Getting started**
```bash
# Clone the repo
git clone https://github.com/NagarjunaD024/data-engineering-apache-projects.git
cd data-engineering-apache-projects

# Enter any project folder and bring up its stack
cd "Implementing the Data Lakehouse (Chapter 02)"
docker compose up -d
```

Each project folder contains its own setup notes and the specific components to run.

**Familiarity assumed:** Python & PySpark, basic Java (for the Kafka/Flink pieces), SQL, and YAML for the Compose configs.

---

## About Me

I'm a data engineer focused on the *why* behind the stack not just how to click through a managed console, but understanding the primitives well enough to reason about trade-offs across ingestion, storage, transformation, and serving.

I'm currently **open to Data Engineer / Analytics Engineer roles**. If you're hiring or open to a conversation, I'd love to connect.

- **GitHub:** [NagarjunaD024](https://github.com/NagarjunaD024)
- **LinkedIn:** [Linkedin](https://www.linkedin.com/in/nagarjuna-gottipati-841995128/)

---

## Acknowledgment

The projects in this repository are based on the exercises from the book *Practical Data Engineering with Apache Projects Dunith Danushka*. The book provides boilerplate scaffolding for each project; my work focused on implementing the core data engineering components the pipelines, transformations, models, and integrations described above.
