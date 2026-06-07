from airflow import DAG
from datetime import datetime, timedelta, timedelta
from dbt_operator import dbt_docker_operator

with DAG(
    dag_id="dbt_full_pipeline",
    description="Run full dbt pipeline for Chinook and Magasin ",
    default_args={
        "owner": "airflow",
        "depends_on_past": False,
        "retries": 1,
        "retry_delay": timedelta(minutes=5),
    },
    schedule="@daily",
    start_date=datetime(2024, 1, 1),
    catchup=False,
    tags=["dbt", "snapshot", "chinook", "magasin"],
) as dag :

    dbt_run_dsa_chinook = dbt_docker_operator(
        task_id="dbt_run_dsa_chinook",
        command="run --select dsa.chinook.*",
    )

    dbt_run_dsa_magasin = dbt_docker_operator(
        task_id="dbt_run_dsa_magasin",
        command="run --select dsa.magasin.*",
    )

    dbt_tests_dsa = dbt_docker_operator(
        task_id="dbt_tests_dsa",
        command="test --select dsa.*",
    )

    dbt_run_ods_chinook = dbt_docker_operator(
        task_id="dbt_run_ods_chinook",
        command="run --select ods.chinook.*",
    )

    dbt_run_ods_magasin = dbt_docker_operator(
        task_id="dbt_run_ods_magasin",
        command="run --select ods.magasin.*",
    )

    dbt_tests_ods = dbt_docker_operator(
        task_id="dbt_tests_ods",
        command="test --select ods.*",
    )

    dbt_run_snapshot_chinook = dbt_docker_operator(
        task_id="dbt_run_snapshot_chinook",
        command="snapshot --select snapshot_chinook_*",
    )

    dbt_run_snapshot_magasin = dbt_docker_operator(
        task_id="dbt_run_snapshot_magasin",
        command="snapshot --select snapshot_magasin_*",
    )

    dbt_tests_snapshot = dbt_docker_operator(
        task_id="dbt_tests_snapshot",
        command="test --select snapshot.*",
    )

    dbt_run_dwh = dbt_docker_operator(
        task_id="dbt_run_dwh",
        command="run --select dwh.*",
    )

    dbt_tests_dwh = dbt_docker_operator(
        task_id="dbt_tests_dwh",
        command="test --select dwh.*",
    )

    [dbt_run_dsa_chinook, dbt_run_dsa_magasin] >> dbt_tests_dsa
    dbt_tests_dsa >> [dbt_run_ods_chinook, dbt_run_ods_magasin] >> dbt_tests_ods
    dbt_tests_ods >> [dbt_run_snapshot_chinook, dbt_run_snapshot_magasin] >> dbt_tests_snapshot
    dbt_tests_snapshot >> dbt_run_dwh >> dbt_tests_dwh



