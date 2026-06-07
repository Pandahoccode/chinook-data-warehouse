{{ config(materialized='table', schema='datawarehouse') }}

SELECT CAST(date_day AS DATE) AS date_day
FROM generate_series(
  '2000-01-01'::DATE,
  '2030-12-31'::DATE,
  '1 day'::INTERVAL
) AS date_day
