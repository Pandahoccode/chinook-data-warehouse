from datetime import datetime, timedelta
from airflow import DAG
from airflow.providers.standard.operators.empty import EmptyOperator

default_args = {
    "owner": "airflow",
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
}
with DAG(
    dag_id="first-dag",
    default_args=default_args,
    description="This is my first DAG",
    schedule="@daily",
    start_date=datetime(2024, 6, 1),
    catchup=False,
) as dag:
    start = EmptyOperator(task_id="start")
