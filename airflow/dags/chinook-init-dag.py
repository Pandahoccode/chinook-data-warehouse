from airflow import DAG
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
from datetime import datetime

with DAG(
    dag_id="init_chinook_pipeline",
    start_date=datetime(2024, 1, 1),
    schedule=None,  # run manually only
    catchup=False,
    description="Initialize Chinook DB with schemas and data",
) as dag:

    # Step 1 — Create schemas for the Chinook database
    create_schemas = SQLExecuteQueryOperator(
        task_id="create_chinook_schemas",
        conn_id="chinook_postgres",
        sql="""
        CREATE SCHEMA IF NOT EXISTS chinook;
        CREATE SCHEMA IF NOT EXISTS ods_chinook;
        CREATE SCHEMA IF NOT EXISTS dsa_chinook;
        CREATE SCHEMA IF NOT EXISTS dwh_chinook;
        """
    )

    # Step 2 — Load Chinook data
    load_chinook = SQLExecuteQueryOperator(
        task_id="load_chinook_sql",
        conn_id="chinook_postgres",
        sql="../database/Chinook_PostgreSql.sql"
    )

    create_schemas >> load_chinook
