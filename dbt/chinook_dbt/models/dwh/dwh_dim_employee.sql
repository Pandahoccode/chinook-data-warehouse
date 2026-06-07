-- models/dwh/dim_employee.sql
{{ config(schema='datawarehouse') }}

SELECT
  {{ generate_surrogate_key(['employee_id', 'dbt_valid_from']) }} AS employee_sk,
  employee_id,
  first_name,
  last_name,
  title,
  reports_to,
  birth_date,
  hire_date,
  address,
  city,
  state,
  country,
  postal_code,
  phone,
  fax,
  email,
  dbt_valid_from AS valid_from,
  dbt_valid_to AS valid_to,
  CASE WHEN dbt_valid_to IS NULL THEN true ELSE false END AS is_current
FROM {{ ref('snapshot_chinook_employee') }}
