"""
dbt Operator Helper Module

This module defines a factory function to construct containerized dbt tasks
using DockerOperator. It automatically configures local path binds, project
environments, target schemas, and networking parameters to ensure containerized
dbt commands can run and communicate with the Postgres database.
"""

from airflow.providers.docker.operators.docker import DockerOperator
from docker.types import Mount
import os

WINDOWS_PATH = os.getenv(
    "HOST_WORKSPACE_PATH",
    "D:/04_Code-est-le-pain/401_PROJECTS/chinook-data-warehouse-v2",
)

def dbt_docker_operator(task_id: str, command: str, **kwargs) -> DockerOperator:
    """
    Constructs a DockerOperator configured to run dbt-postgres commands.

    Args:
        task_id (str): The unique identifier for the Airflow task.
        command (str): The dbt CLI command to run (e.g. 'run', 'test', 'snapshot').
        **kwargs: Additional parameters passed to the DockerOperator (e.g., trigger_rule).

    Returns:
        DockerOperator: An Airflow DockerOperator instance.
    """
    return DockerOperator(
        task_id=task_id,
        image="ghcr.io/dbt-labs/dbt-postgres:1.9.0",
        command=command,
        network_mode="chinook-data-warehouse-v2_airflow-network",
        docker_url="unix:///var/run/docker.sock",
        environment={
            "DBT_PROFILES_DIR": "/root/.dbt"
        },
        mounts=[
            Mount(
                source=os.path.join(WINDOWS_PATH, "dbt", "chinook_dbt"),
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
        **kwargs
    )
