# Chinook & Magasin DWH Operational Instructions

This document provides step-by-step instructions to run, develop, and verify the data warehouse pipelines, along with details on the dbt configurations and the Airflow operators.

---

## ⚙️ 1. Core Architecture & Configurations

### A. dbt Project Config (`dbt_project.yml`)
The dbt project configuration determines where tables are materialized, their default schema tags, and naming strategies.
*   **Custom Schema Naming**: The custom macro `get_custom_schema` is used to ensure all final warehouse dimension and fact tables are routed to the `datawarehouse` schema instead of being prefixed (e.g., `dwh_datawarehouse`).
*   **Model Schemas**:
    *   **dsa**: Materialized as `view` under `dsa_chinook` or `dsa_magasin`.
    *   **ods**: Materialized as `table` under `ods_chinook` or `ods_magasin`.
    *   **dwh**: Materialized as `table` under the custom `datawarehouse` schema.
*   **Snapshots**: Configured to write directly into `csd_snapshot_chinook` and `csd_snapshot_magasin`.

### B. Custom Macros (`macros/generate_surrogate_key.sql`)
To eliminate external packages like `dbt_utils` which cannot be easily retrieved dynamically inside default Docker container tasks, we use a native macro:
```sql
{% macro generate_surrogate_key(field_list) %}
    md5(
        {% for field in field_list %}
            coalesce(cast({{ field }} as varchar), '_dbt_utils_surrogate_key_null_')
            {% if not loop.last %} || '-' || {% endif %}
        {% endfor %}
    )
{% endmacro %}
```

### C. Airflow dbt Operator Helper (`dags/dbt_operator.py`)
All dbt actions inside Airflow DAGs run containerized via the standard `dbt_docker_operator` helper function. This ensures:
1.  **Network Integration**: Configures `network_mode="chinook-data-warehouse-v2_airflow-network"` so the dbt container can resolve and connect to the database container at host `postgres`.
2.  **Bind Mounts**:
    *   Mounts the dbt project directory (`dbt/chinook_dbt`) to `/usr/app` in the container.
    *   Mounts the local profile directory (`dbt_profiles`) containing `profiles.yml` to `/root/.dbt`.
3.  **Auto-cleanup**: The container is destroyed upon successful completion of the task.

---

## 🚀 2. Starting the Development Stack

To spin up all Airflow containers and the Postgres database, execute this command from the root of your workspace:

```bash
docker-compose up -d
```

Verify that all services are healthy and running:

```bash
docker ps
```

---

## ⚙️ 3. Triggering the Airflow Pipeline

### Via the Airflow UI
1. Open your web browser and navigate to: **[http://localhost:8080](http://localhost:8080)**
2. Log in using the default Airflow credentials (e.g. `airflow` / `airflow`).
3. Locate the DAG named **`dbt_full_pipeline`** or **`dbt_ingestion_pipeline`**.
4. Enable the DAG and click the **Trigger DAG** button (play icon) on the top right.

### Via the Command Line
Alternatively, you can trigger the DAGs directly from your terminal:

*   **Ingest raw source data (Run once)**:
    ```bash
    docker exec af-sche-chinook airflow dags trigger dbt_ingestion_pipeline
    ```
*   **Run full transformation pipeline**:
    ```bash
    docker exec af-sche-chinook airflow dags trigger dbt_full_pipeline
    ```

You can monitor the execution progress by querying the task states:

```bash
docker exec af-sche-chinook airflow tasks states-for-dag-run dbt_full_pipeline <run_id>
```

---

## 🛠️ 4. Running dbt Manually in Docker

For development, testing, or debugging, you can run dbt commands directly inside the container environment. 

This mirrors the Airflow execution environment, mount mappings, and networking rules:

```bash
docker run --rm \
  -v "%cd%/dbt/chinook_dbt:/usr/app" \
  -v "%cd%/dbt_profiles:/root/.dbt" \
  --network chinook-data-warehouse-v2_airflow-network \
  -w /usr/app \
  ghcr.io/dbt-labs/dbt-postgres:1.9.0 \
  run --select dwh.*
```

*Change `run --select dwh.*` to other standard commands as needed (e.g., `test`, `snapshot`, etc.).*

---

## 📊 5. Querying & Verifying the Data

To check the loaded rows and query data inside the Postgres database directly, use `psql` inside the Postgres container:

### Count Rows in the Fact Table
Run this command to check how many rows from the Chinook and Magasin store systems are present in the final consolidated invoice fact table:

```bash
docker exec postgres-chinook psql -U chinook -d chinook -c "SELECT source_system, COUNT(*) FROM datawarehouse.dwh_fact_invoice GROUP BY source_system;"
```

### Query Sample Customer Dimensions
Check the slowly changing customer records in the warehouse layer:

```bash
docker exec postgres-chinook psql -U chinook -d chinook -c "SELECT customer_id, first_name, last_name, valid_from, valid_to, is_current FROM datawarehouse.dwh_dim_customer LIMIT 10;"
```
