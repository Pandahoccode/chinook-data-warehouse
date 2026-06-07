from airflow import DAG
from airflow.providers.docker.operators.docker import DockerOperator
from datetime import datetime, timedelta
import os
from docker.types import Mount

DBT_DIR = "/opt/airflow/dbt"
WINDOWS_PATH = os.getenv(
    "HOST_WORKSPACE_PATH",
    "D:/04_Code-est-le-pain/401_PROJECTS/chinook-data-warehouse-v2",
)

with DAG(
    dag_id="dbt_ods_to_snapshots",
    description="Run dbt snapshots for SCD Type 2",
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

      dbt_run_snapshot_chinook = DockerOperator(
          task_id="dbt_run_snapshot_chinook",
          image="ghcr.io/dbt-labs/dbt-postgres:1.9.0",
          command="snapshot --select snapshot_chinook_*",
          network_mode="chinook-data-warehouse-v2_airflow-network",
          docker_url="unix://var/run/docker.sock",
          environment={
              "DBT_PROFILES_DIR": "/root/.dbt"
          },
          mounts=[
              Mount(source=os.path.join(str(WINDOWS_PATH), "dbt/chinook_dbt"), target="/usr/app", type="bind"),
              Mount(source=os.path.join(str(WINDOWS_PATH), "dbt_profiles"), target="/root/.dbt", type="bind")
          ],
          working_dir="/usr/app",
          mount_tmp_dir=False,
          auto_remove="success",
      )

      dbt_run_snapshot_magasin = DockerOperator(
          task_id="dbt_run_snapshot_magasin",
          image="ghcr.io/dbt-labs/dbt-postgres:1.9.0",
          command="snapshot --select snapshot_magasin_*",
          network_mode="chinook-data-warehouse-v2_airflow-network",
          docker_url="unix:///var/run/docker.sock",
          environment={
              "DBT_PROFILES_DIR": "/root/.dbt"
          },
          mounts=[
              Mount(source=os.path.join(str(WINDOWS_PATH), "dbt/chinook_dbt"), target="/usr/app", type="bind"),
              Mount(source=os.path.join(str(WINDOWS_PATH), "dbt_profiles"), target="/root/.dbt", type="bind")
          ],
          working_dir="/usr/app",
          mount_tmp_dir=False,
          auto_remove="success",
      )

      dbt_tests_snapshots = DockerOperator(
          task_id="dbt_tests_snapshot",
          image="ghcr.io/dbt-labs/dbt-postgres:1.9.0",
          command="test --select snapshot.*",
          network_mode="chinook-data-warehouse-v2_airflow-network",
          docker_url="unix:///var/run/docker.sock",
          environment={
              "DBT_PROFILES_DIR": "/root/.dbt"
          },
          mounts=[
              Mount(source=os.path.join(str(WINDOWS_PATH), "dbt/chinook_dbt"), target="/usr/app", type="bind"),
              Mount(source=os.path.join(str(WINDOWS_PATH), "dbt_profiles"), target="/root/.dbt", type="bind")
          ],
          working_dir="/usr/app",
          mount_tmp_dir=False,
          auto_remove="success",
      )

      [dbt_run_snapshot_chinook, dbt_run_snapshot_magasin] >> dbt_tests_snapshots
