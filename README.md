# dbt-netflix-pipeline 🎬🍿

A production-grade ELT data pipeline built with **dbt Core (v1.11.x)** and **Snowflake Data Warehouse** to transform raw MovieLens metadata and streaming logs into a highly optimized, business-ready Kimball Star Schema.

This project showcases enterprise-level data engineering practices, including data quality enforcement at the ingestion layer, advanced string and array manipulation, derived behavioral modeling, and custom logarithmic performance metrics.

---

## 🏛️ Architecture Overview

The pipeline follows a modular **three-tier architecture** designed for high maintainability, strict schema isolation, and optimal execution performance in cloud data warehouses:

[ Snowflake Raw Ingestion Schema ]
                │
                ▼
 1. STAGING LAYER (models/staging/)  ──> Materialized as Views (Data Cleaning & Casting)
                │
                ▼
 2. DIM-CORE LAYER (models/marts/dim/)  ──> Materialized as Tables ( Kimball Dimensions )
                │
                ▼
 3. FACT LAYER (models/marts/fct/)  ──> Materialized as Tables ( Heavy Metrics & Indexes )


### 🗂️ Project Layers & Data Strategy

1. **Staging Layer (`models/staging/`):** Directly references the raw ingestion tables (`RAW_MOVIES`, `RAW_RATINGS`, `RAW_TAGS`, etc.). Acts as the structural gatekeeper—handling explicit data type casting, normalizing strings (`LOWER`/`TRIM`), eliminating case fragmentation, and mapping junk text placeholders (`'none'`, `'null'`, `'n/a'`) to true database `NULL` markers.
2. **Core Dimensional Layer (`models/marts/dim/`):** Contains the core business dimensions (nouns) materialized as physical tables. 
   * `dim_movies`: Transforms pipe-delimited strings into clean structural arrays, maps vintage cohorts, and implements optimized boolean flag matching.
   * `dim_users`: Dynamically derives behavioral customer profiles from transaction records, tracking lifecycles and segmenting reviewer sentiment cohorts.
   * `dim_tags`: Bridges unstructured user-generated events with the formal system genome catalog while tracking live execution metrics.
3. **Performance Fact Layer (`models/marts/fct/`):** Focuses on heavy quantitative event metrics. Centralizes dense streaming review data, structural tracking distributions, and advanced analytical index rankings at the core grain of execution.

---

## 🛠️ Tech Stack & Prerequisites

* **Data Warehouse:** Snowflake (Standard/Enterprise Edition)
* **Transformation Engine:** dbt Core `v1.11.12`
* **Adapter:** `dbt-snowflake==1.11.0`
* **Language:** SQL (Snowflake-native dialects)
* **Version Control:** Git & GitHub
* **Environment Manager:** Python `venv` (Python 3.9+)

---

## 🚀 Setup & Installation Instructions

Follow these steps to spin up the local development environment and run the data pipeline.

### 1. Clone the Repository & Navigate to Root
```bash
git clone [https://github.com/YOUR_USERNAME/dbt-netflix-pipeline.git](https://github.com/YOUR_USERNAME/dbt-netflix-pipeline.git)
cd netflix_project
```bash

2. Set Up Virtual Environment & Install Dependencies
Create an isolated Python environment to keep dependencies clean and prevent version conflicts:

# Create the environment
python3 -m venv venv

# Activate the environment
source venv/bin/activate

# Install dbt-snowflake adapter (installs dbt-core automatically)
pip install dbt-snowflake==1.11.0


3. Configure dbt Profiles (profiles.yml)
dbt expects authentication tokens inside a hidden file located in your user directory (~/.dbt/profiles.yml). Create or update this file with your Snowflake developer details:

netflix_project:
  outputs:
    dev:
      type: snowflake
      account: your_snowflake_account_locator.region
      user: your_username
      password: your_secure_password
      role: your_developer_role
      database: DEV
      warehouse: COMPUTE_WH
      schema: public
      threads: 4
  target: dev


🏃 Run the Data Pipeline
Once connected, execute the following build pipeline steps using the dbt CLI:

# Compile and build the staging layers only
dbt run --select staging

# Build a specific target dimensional entity
dbt run --select dim_movies

# Execute the entire end-to-end data pipeline
dbt run


🧬 Advanced Analytics & Engineering Highlight
Enterprise Deduplication (QUALIFY)
To guarantee strict granularity enforcement inside stg_links.sql, the pipeline replaces slow, nested subqueries with Snowflake's native QUALIFY clause paired with programmatic sorting order constraints:

QUALIFY ROW_NUMBER() OVER (PARTITION BY movie_id ORDER BY tmdb_id DESC NULLS LAST) = 1


The Movie Popularity Log IndexInside the Fact Layer, raw metrics are mapped against an advanced quantitative equation balancing critical sentiment against engagement volume using a base-10 logarithmic scaling index to prevent low-sample size ranking distortions:

$$\text{Popularity Index} = (\text{Average Rating} \times 0.6) + (\log_{10}(\text{Total Reviews} + 1) \times 0.4)$$


👥 Professional Profile
Developer: Prabhakar Karayat

Role: Data Engineering 

Expertise: Advanced SQL Analytics, Cloud Migrations, Data Validation, Test Automation Frameworks