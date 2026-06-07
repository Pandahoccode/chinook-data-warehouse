"""
dbt Ingestion Pipeline DAG

This DAG sets up the initial PostgreSQL schema namespaces (ods, dsa, datawarehouse)
and seeds the raw database with static Chinook and Magasin store data dumps.
It is intended to be executed once on setup to bootstrap the raw data layer.
"""

from airflow import DAG
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
from datetime import datetime

with DAG(
    dag_id="dbt_ingestion_pipeline",
    start_date=datetime(2024, 1, 1),
    schedule="@once",   # Run only once on-demand to seed the initial data
    catchup=False,
) as dag:

    # 1. Create Target Schemas:
    # Set up the logical namespaces in the database required by dbt layers.
    create_schemas = SQLExecuteQueryOperator(
        task_id="create_schemas",
        conn_id="chinook_connection",
        sql="""
        CREATE SCHEMA IF NOT EXISTS ods_magasin;
        CREATE SCHEMA IF NOT EXISTS dsa_magasin;
        CREATE SCHEMA IF NOT EXISTS ods_chinook;
        CREATE SCHEMA IF NOT EXISTS dsa_chinook;
        CREATE SCHEMA IF NOT EXISTS datawarehouse;
        """
    )

    # 2. Seed Raw Chinook Data:
    # Run the SQL dump to import the raw digital media store schema & data.
    load_chinook = SQLExecuteQueryOperator(
        task_id="load_chinook_sql",
        conn_id="chinook_connection",
        sql="data/Chinook_PostgreSql.sql"
    )

    # 3. Seed Raw Magasin Data:
    # Run the SQL dump to import the raw retail sales transaction schema & data.
    load_magasin = SQLExecuteQueryOperator(
        task_id="load_magasin_sql",
        conn_id="chinook_connection",
        sql="data/Magasin_PostgreSql.sql"
    )

    # Dependency Tree
    # Schema creation must complete before attempting to load data into them
    create_schemas >> [load_chinook, load_magasin]
