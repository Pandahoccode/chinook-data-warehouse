from airflow import DAG
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
from datetime import datetime

with DAG(
    dag_id="init_chinook_pipeline",
    start_date=datetime(2024, 1, 1),
    schedule=None,
    catchup=False,
) as dag:

    create_schemas = SQLExecuteQueryOperator(
        task_id="create_schemas",
        conn_id="chinook_connection",
        sql="""
        CREATE SCHEMA IF NOT EXISTS chinook;
        CREATE SCHEMA IF NOT EXISTS ods_chinook;
        CREATE SCHEMA IF NOT EXISTS dsa_chinook;
        CREATE SCHEMA IF NOT EXISTS dwh_chinook;
        """
    )

    load_chinook = SQLExecuteQueryOperator(
        task_id="load_chinook_sql",
        conn_id="chinook_connection",
        sql="/opt/airflow/database/Chinook_PostgreSql.sql"
    )

    create_schemas >> load_chinook
