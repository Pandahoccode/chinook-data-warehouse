"""
dbt Full Transformation Pipeline DAG

This DAG orchestrates the daily end-to-end data transformation pipeline.
It handles running and testing the staged layer (DSA), operational layer (ODS),
slowly changing dimensions history tracking (Snapshot), and finally, building and
testing the consolidated dimensional warehouse layer (DWH) inside the PostgreSQL db.
"""

from airflow import DAG
from datetime import datetime, timedelta
# pyrefly: ignore [missing-import]
from dbt_operator import dbt_docker_operator

with DAG(
    dag_id="dbt_full_pipeline",
    description="Run full dbt pipeline for Chinook and Magasin",
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

    # -------------------------------------------------------------
    # 1. DSA (Data Staging Area) Layer
    # -------------------------------------------------------------
    # Initial layer that stages raw source data.
    dbt_run_dsa_chinook = dbt_docker_operator(
        task_id="dbt_run_dsa_chinook",
        command="run --select dsa.chinook.*",
    )

    dbt_run_dsa_magasin = dbt_docker_operator(
        task_id="dbt_run_dsa_magasin",
        command="run --select dsa.magasin.*",
    )

    # Validate staged datasets using dbt test suites
    dbt_tests_dsa = dbt_docker_operator(
        task_id="dbt_tests_dsa",
        command="test --select dsa.*",
    )

    # -------------------------------------------------------------
    # 2. ODS (Operational Data Store) Layer
    # -------------------------------------------------------------
    # Normalizes column structures and formats dates into standard types.
    dbt_run_ods_chinook = dbt_docker_operator(
        task_id="dbt_run_ods_chinook",
        command="run --select ods.chinook.*",
    )

    dbt_run_ods_magasin = dbt_docker_operator(
        task_id="dbt_run_ods_magasin",
        command="run --select ods.magasin.*",
    )

    # Validate cleaned operational datasets
    dbt_tests_ods = dbt_docker_operator(
        task_id="dbt_tests_ods",
        command="test --select ods.*",
    )

    # -------------------------------------------------------------
    # 3. Snapshot (SCD Type 2) Layer
    # -------------------------------------------------------------
    # Tracks structural changes in digital assets over time (e.g. tracks, customer info)
    dbt_run_snapshot_chinook = dbt_docker_operator(
        task_id="dbt_run_snapshot_chinook",
        command="snapshot --select snapshot_chinook_*",
    )

    dbt_run_snapshot_magasin = dbt_docker_operator(
        task_id="dbt_run_snapshot_magasin",
        command="snapshot --select snapshot_magasin_*",
    )

    # Validate SCD Type 2 fields and unique keys
    dbt_tests_snapshot = dbt_docker_operator(
        task_id="dbt_tests_snapshot",
        command="test --select snapshot.*",
    )

    # -------------------------------------------------------------
    # 4. DWH (Core Data Warehouse) Layer
    # -------------------------------------------------------------
    # Builds the final consolidated facts and dimensions in the 'datawarehouse' schema.
    dbt_run_dwh = dbt_docker_operator(
        task_id="dbt_run_dwh",
        command="run --select dwh.*",
    )

    # Execute final integration and constraint checks on facts/dimensions
    dbt_tests_dwh = dbt_docker_operator(
        task_id="dbt_tests_dwh",
        command="test --select dwh.*",
    )

    # -------------------------------------------------------------
    # 5. Elementary Data Observability & Monitoring
    # -------------------------------------------------------------
    # Collects test results, metrics, and anomaly detection logs into the 'elementary' schema.
    # We use trigger_rule="all_done" to guarantee telemetry is updated even if some tests fail.
    dbt_run_elementary = dbt_docker_operator(
        task_id="dbt_run_elementary",
        command="run --select elementary",
        trigger_rule="all_done",
    )

    # -------------------------------------------------------------
    # Dependency Configuration
    # -------------------------------------------------------------
    # DSA -> ODS -> Snapshots -> DWH -> Elementary
    [dbt_run_dsa_chinook, dbt_run_dsa_magasin] >> dbt_tests_dsa
    dbt_tests_dsa >> [dbt_run_ods_chinook, dbt_run_ods_magasin] >> dbt_tests_ods
    dbt_tests_ods >> [dbt_run_snapshot_chinook, dbt_run_snapshot_magasin] >> dbt_tests_snapshot
    dbt_tests_snapshot >> dbt_run_dwh >> dbt_tests_dwh >> dbt_run_elementary
