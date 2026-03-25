from airflow import DAG
from airflow.providers.standard.operators.python import PythonOperator
from airflow.models import Connection
from airflow.settings import Session
from datetime import datetime

def create_connection():
    session = Session()

    conn = Connection(
        conn_id="chinook_postgres",
        conn_type="postgres",
        host="localhost",
        schema="chinook",
        login="chinook",
        password="chinook",
        port=5432,
    )

    session.merge(conn)
    session.commit()

with DAG(
    dag_id="create_connection_dag",
    start_date=datetime(2024, 1, 1),
    schedule=None,
    catchup=False,
) as dag:

    create_conn = PythonOperator(
        task_id="create_connection",
        python_callable=create_connection,
    )
