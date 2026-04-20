# AcmeMart Data Platform

> A centralized data warehouse and transformation project built on Snowflake, dbt, and Airbyte — designed to unify AcmeMart's fragmented retail data into a single source of truth for analytics and decision-making.

---

## Table of Contents

- [Company Overview](#company-overview)
- [Business Challenge](#business-challenge)
- [Project Objectives](#project-objectives)
- [Architecture](#architecture)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Data Layers](#data-layers)
  - [Staging Layer](#staging-layer)
  - [Gold Layer — Facts](#gold-layer--facts)
  - [Gold Layer — Dimensions](#gold-layer--dimensions)
  - [Gold Layer — Aggregates](#gold-layer--aggregates)
- [dbt Models & Tests](#dbt-models--tests)
- [Getting Started](#getting-started)
- [Deliverables](#deliverables)

---

## Company Overview

**AcmeMart** is a mid-sized retail and e-commerce company that operates both physical stores and an online shopping platform. The company sells a wide range of consumer goods, including groceries, household items, and personal care products.

With growing customer demand and increasing transaction volume across multiple channels, AcmeMart generates large amounts of data daily — from in-store purchases to online transactions and customer interactions.

**Core business areas:**

- **Retail Sales (In-store):** Transactions from physical store locations
- **Customer Management:** Capturing customer profiles, purchase history, and behaviour
- **Supplier & Product Management:** Managing product catalogue, pricing, and vendor relationships

---

## Business Challenge

Despite generating significant data across channels, AcmeMart's data landscape presents several limitations:

| Challenge | Description |
|---|---|
| **Data Silos** | Data stored in Google Drive remains logically siloed across multiple source files with no unified schema or integration layer |
| **Limited Analytics** | Difficulty generating insights like total sales by product, store performance, or customer behaviour trends |
| **Manual Reporting** | Teams rely on manual processes and spreadsheets, leading to delays and inconsistencies |
| **Poor Data Quality** | Inconsistent data types and formats across source files |
| **No Scalable Model** | No structured data warehouse layer to support analytics at scale |

---

## Project Objectives

This project establishes a centralized and well-structured data platform to support AcmeMart's analytics needs. Specific objectives include:

1. **Data Integration** — Consolidate data into a centralized warehouse
2. **Data Transformation** — Implement staging and gold layers
3. **Data Modeling** — Create fact and dimension tables
4. **Aggregation Layer** — Build summarized datasets for reporting
5. **Data Quality & Testing** — Ensure accuracy through validations
6. **Analytics Enablement** — Make data usable for self-service reporting

Strategic goals:
- Establish a single source of truth for business data
- Enable self-service analytics for business users
- Improve data reliability and consistency
- Transition from reactive reporting to proactive decision-making
- Build a scalable data foundation for future use cases

---

## Architecture

![AcmeMart Data Platform Architecture](./AcmeMart.svg)

The platform follows a layered architecture:

```
Google Drive (Source)
        |
        v
    Airbyte (Ingestion)
        |
        v
   Snowflake (Raw)
        |
        v
   dbt Staging Layer (stg_*)
        |
        v
   dbt Gold Layer
    |-- facts/
    |-- dimensions/
    +-- aggregates/
```

---

## Tech Stack

| Component | Tool |
|---|---|
| **Data Warehouse** | Snowflake |
| **Transformation & Modeling** | dbt (Data Build Tool) |
| **Data Ingestion** | Airbyte |
| **Source Storage** | Google Drive |
| **Version Control** | Git / GitHub |

---

## Project Structure

```
acmemart-dbt/
+-- models/
|   +-- staging/
|   |   +-- stg_transactions.sql
|   +-- gold/
|       +-- facts/
|       |   +-- fct_trn_history.sql
|       |   +-- schema.yml
|       +-- dimensions/
|       |   +-- dim_customers.sql
|       |   +-- dim_products.sql
|       |   +-- dim_stores.sql
|       |   +-- dim_date.sql
|       |   +-- schema.yml
|       +-- aggregates/
|           +-- daily_sales_summary.sql
|           +-- historical_lifetime_value.sql
|           +-- product_performance.sql
|           +-- revenue_trend.sql
|           +-- schema.yml
+-- dbt_project.yml
+-- README.md
```

---

## Data Layers

### Staging Layer

The staging layer (`stg_*`) ingests raw data from Snowflake and applies light cleaning — renaming columns, casting data types, and standardising formats. It serves as the foundation for all gold layer models.

| Model | Source | Description |
|---|---|---|
| `stg_transactions` | Raw Snowflake table | Cleaned and typed transaction records from all channels |

---

### Gold Layer — Facts

The facts layer contains the core business events at the lowest grain available.

| Model | Grain | Description |
|---|---|---|
| `fct_trn_history` | One row per transaction | All completed transactions with keys, amounts, and timestamps |

**Key columns:** `transaction_id`, `customer_id`, `store_id`, `product_id`, `payment_method`, `quantity`, `unit_price`, `total_amount`, `trn_timestamp`, `trn_date`

---

### Gold Layer — Dimensions

Dimension tables provide descriptive context to the fact table.

| Model | Grain | Description |
|---|---|---|
| `dim_customers` | One row per customer | Distinct customer identifiers |
| `dim_products` | One row per product | Product identifiers, names, and categories |
| `dim_stores` | One row per store | Distinct store identifiers |
| `dim_date` | One row per calendar date | 90-day date spine (2026-01-01 onwards) with calendar attributes |

**`dim_date` columns:** `date_day`, `year`, `month`, `day`, `quarter`, `day_of_week`, `day_name`, `week_of_year`, `day_type`

---

### Gold Layer — Aggregates

Pre-aggregated models designed for reporting and dashboarding.

| Model | Grain | Description |
|---|---|---|
| `daily_sales_summary` | Date x Product | Units sold, revenue, and transaction counts per product per day |
| `historical_lifetime_value` | Customer | Total orders, lifetime spend, and average order value per customer |
| `product_performance` | Product | Revenue, units sold, and transactions per product enriched with product details |
| `revenue_trend` | Year x Month x Day | Daily revenue and transaction counts with full calendar context from `dim_date` |

---

## dbt Models & Tests

The `schema.yml` in each subfolder documents all models and enforces data quality through built-in dbt tests:

| Test | Applied To |
|---|---|
| `not_null` | All key and measure columns |
| `unique` | All primary keys (`transaction_id`, `customer_id`, `product_id`, `date_day`) |
| `accepted_values` | `dim_date.day_type` — enforces `weekday` or `weekend` only |

**Run all models:**
```bash
dbt run
```

**Run all tests:**
```bash
dbt test
```

**Run and test together (recommended):**
```bash
dbt build
```

**Target a specific layer:**
```bash
dbt run --select tag:facts
dbt run --select tag:dimensions
dbt run --select tag:aggregates
```

> **Note:** Always run `dbt run` before `dbt test`. Tests like `not_null` and `unique` query the actual tables in Snowflake — they will fail if the models have not been built yet. Using `dbt build` handles this automatically by running and testing each model in DAG order.

---

## Getting Started

### Prerequisites

- Snowflake account with appropriate permissions
- dbt Core installed (`pip install dbt-snowflake`)
- Airbyte instance connected to Google Drive source
- Python 3.8+

### Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/acmemart/acmemart-dbt.git
   cd acmemart-dbt
   ```

2. **Configure dbt profile**

   Add your Snowflake credentials to `~/.dbt/profiles.yml`:
   ```yaml
   acmemart:
     target: dev
     outputs:
       dev:
         type: snowflake
         account: <your_account>
         user: <your_user>
         password: <your_password>
         role: <your_role>
         database: <your_database>
         warehouse: <your_warehouse>
         schema: gold
   ```

3. **Install dbt dependencies**
   ```bash
   dbt deps
   ```

4. **Build the project**
   ```bash
   dbt build
   ```

---

## Deliverables

- Centralized Snowflake data warehouse
- Clean, tested fact and dimension tables
- Aggregated datasets ready for reporting and dashboarding
- Improved data quality enforced through dbt tests
- Faster insight generation replacing manual spreadsheet workflows
- Reduced dependency on manual reporting processes