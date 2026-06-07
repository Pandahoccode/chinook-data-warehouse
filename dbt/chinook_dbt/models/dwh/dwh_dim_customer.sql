-- models/dwh/dim_customer.sql
{{ config(schema='datawarehouse') }}

SELECT
  {{ generate_surrogate_key(['customer_id', 'dbt_valid_from']) }} AS customer_sk,
  customer_id,
  first_name,
  last_name,
  company,
  address,
  city,
  state,
  country,
  postal_code,
  phone,
  fax,
  email,
  support_rep_id,
  dbt_valid_from AS valid_from,
  dbt_valid_to AS valid_to,
  CASE WHEN dbt_valid_to IS NULL THEN true ELSE false END AS is_current
FROM {{ ref('snapshot_chinook_customer') }}
