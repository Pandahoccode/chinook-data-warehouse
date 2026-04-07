from airflow import DAG
from airflow.providers.docker.operators.docker import DockerOperator
from datetime import datetime, timedelta
import os
from docker.types import Mount

DBT_DIR = "/opt/airflow/dbt"
WINDOWS_PATH="D:/3. Mes études/3.1 BUT SD/BUT 2 Phuc Anh/SEM_4 - DANG/chinook-data-warehouse-v2"

with DAG(
    dag_id="dbt_dsa_to_ods",
    description="Run dbt ods layer transformations for Chinook and Magasin",
    default_args={
        "owner": "airflow",
        "depends_on_past": False,
        "retries": 1,
        "retry_delay": timedelta(minutes=5),
    },
    schedule="@daily",
    start_date=datetime(2024, 1, 1),
    catchup=False,
    tags=["dbt", "ods", "chinook", "magasin"],
) as dag :

      dbt_run_ods_chinook = DockerOperator(
          task_id="dbt_run_ods_chinook",
          image="ghcr.io/dbt-labs/dbt-postgres:1.9.0",
          command="run --select ods.chinook.*",
          network_mode="bridge",
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

      dbt_run_ods_magasin = DockerOperator(
          task_id="dbt_run_ods_magasin",
          image="ghcr.io/dbt-labs/dbt-postgres:1.9.0",
          command="run --select ods.magasin.*",
          network_mode="bridge",
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

      dbt_tests_ods = DockerOperator(
          task_id="dbt_tests_ods",
          image="ghcr.io/dbt-labs/dbt-postgres:1.9.0",
          command="test --select ods.*",
          network_mode="bridge",
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

      [dbt_run_ods_chinook, dbt_run_ods_magasin] >> dbt_tests_ods
