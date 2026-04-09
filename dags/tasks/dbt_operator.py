from airflow.providers.docker.operators.docker import DockerOperator
from docker.types import Mount
import os

WINDOWS_PATH="D:/3. Mes études/3.1 BUT SD/BUT 2 Phuc Anh/SEM_4 - DANG/chinook-data-warehouse-v2"

def dbt_docker_operator(task_id: str, command: str) -> DockerOperator:
    return DockerOperator(
        task_id=task_id,
        image="ghcr.io/dbt-labs/dbt-postgres:1.9.0",
        command=command,
        network_mode="bridge",
        docker_url="unix://var/run/docker.sock",
        environment={
            "DBT_PROFILES_DIR": "/root/.dbt"
        },
        mounts=[
            Mount(
                source=os.path.join(WINDOWS_PATH, "dbt/chinook_dbt"),
                target="/usr/app",
                type="bind"
            ),
            Mount(
                source=os.path.join(WINDOWS_PATH, "dbt_profiles"),
                target="/root/.dbt",
                type="bind"
            )
        ],
        working_dir="/usr/app",
        mount_tmp_dir=False,
        auto_remove="success",
    )
