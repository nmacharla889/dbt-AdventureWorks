# dbt Dimensional Modelling — AdventureWorks

## Business Problem

AdventureWorks manufactures bicycles and sells them to consumers (B2C) and 
businesses (B2B) across the world. This project answers the following 
business question:

> How much revenue did AdventureWorks generate for the year ending 2011, 
> broken down by product category and subcategory, customer, order status, 
> and shipping location?

---

## Project Overview

A dimensional model built using the Kimball methodology on the AdventureWorks 
dataset. The project demonstrates a full modern data stack analytics workflow 
using dbt Core and DuckDB.

**Stack**
- dbt Core 1.11
- DuckDB (local analytical database)
- Python 3.12
- Windows / VS Code

**dbt packages used**
- `dbt_utils` — surrogate key generation and star macro
- `codegen` — YML scaffolding

---

## Data Model

The project follows a star schema design with an additional one big table (OBT) 
for flat reporting use cases.

### Fact Table
- `my_fct_sales` — one row per order line item, grain is 
`sales_order_id + sales_order_detail_id`

### Dimensions
- `my_dim_product` — product enriched with subcategory and category
- `my_dim_customer` — individual and store customers
- `my_dim_address` — shipping addresses with state and country
- `my_dim_date` — calendar date with derived time attributes

### One Big Table
- `my_obt_sales` — fully denormalised flat table joining all dimensions 
to the fact table, intended for BI tools that cannot handle multi-table joins

### Lineage
sources → staging → dims → fct → obt

---

## Key Design Decisions

**Kimball star schema**
Chosen to learn and demonstrate dimensional modelling fundamentals including 
surrogate keys, conformed dimensions and fact table grain definition.

**OBT alongside star schema**
The star schema supports flexible analytical queries. The OBT is an additional 
layer for flat reporting tools. In an interview context: these serve different 
consumers, not competing approaches.

**Surrogate keys**
Generated using `dbt_utils.generate_surrogate_key` on all dimension and fact 
tables to decouple the model from source system natural keys.

**Data quality decisions**
Three confirmed source data issues were investigated and documented with 
`severity: warn` rather than failing the build:

| Issue                                 | Count    | Decision                                |
|---------------------------------------|----------|-----------------------------------------|
| Orders with no shipping address match | 69 rows  | warn — orphaned rows in source          |
| Products with no subcategory assigned | 209 rows | warn — incomplete source classification |
| Orders with no credit card on record  | 49 rows  | warn — non-card payment orders          |

---

## How to Run Locally

### Prerequisites
- Python 3.12
- Git

### Setup

```bash
# Clone the repo
git clone https://github.com/nmacharla889/dbt-AdventureWorks.git
cd dbt-AdventureWorks/adventureworks

# Create and activate virtual environment
python -m venv dbt-env
dbt-env\Scripts\activate

# Install dependencies
pip install dbt-duckdb

# Install dbt packages
dbt deps
```

### Run the project

```bash
# Load seed data (raw AdventureWorks CSV files)
dbt seed

# Build all models and run all tests
dbt build

# Generate and view documentation
dbt docs generate
dbt docs serve
```

### Run tests only

```bash
# Test sources
dbt test --select source:*

# Test staging
dbt test --select my_staging

# Test marts
dbt test --select my_marts
```

---

## What I Would Do Differently in Production

- **Database** — replace DuckDB with a cloud warehouse such as Snowflake or 
Azure Synapse for multi-user access and scalability
- **Ingestion** — use a tool like Fivetran or Azure Data Factory to load raw 
data rather than CSV seeds
- **Orchestration** — schedule dbt runs using Airflow or Azure Data Factory 
pipelines instead of running manually
- **CI/CD** — add GitHub Actions to run `dbt build` automatically on every 
pull request to catch breaking changes before merge
- **Slowly changing dimensions** — implement SCD Type 2 snapshots on customer 
and product dims to track historical changes over time

---

## Repository Structure
adventureworks/
├── models/
│   ├── my_staging/        # 15 staging models, one per source table
│   └── my_marts/          # dims, fct, obt
├── seeds/                 # raw AdventureWorks CSV data
├── snapshots/             # (planned)
├── dbt_project.yml
└── packages.yml

---

## Author

Nikhil Macharla
[LinkedIn](https://www.linkedin.com/in/nikhilmacharla/) | [GitHub](https://github.com/nmacharla889/)