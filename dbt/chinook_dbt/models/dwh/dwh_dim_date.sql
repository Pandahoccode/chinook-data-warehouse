-- models/dwh/dim_date.sql
{{ config(schema='datawarehouse') }}

SELECT
  date_day AS date_id,
  EXTRACT(DAY FROM date_day) AS day,
  EXTRACT(MONTH FROM date_day) AS month,
  EXTRACT(YEAR FROM date_day) AS year
FROM {{ ref('date_spine') }}
