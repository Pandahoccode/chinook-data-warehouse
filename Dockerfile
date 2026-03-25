FROM apache/airflow:3.1.7

USER root

RUN pip install apache-airflow-providers-postgres

USER airflow
