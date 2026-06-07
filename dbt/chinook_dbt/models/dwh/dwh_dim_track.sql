-- models/dwh/dim_track.sql
{{ config(schema='datawarehouse') }}

SELECT
  {{ generate_surrogate_key(['track_id', 'dbt_valid_from']) }} AS track_sk,
  track_id,
  track_name,
  composer,
  milliseconds,
  bytes,
  unit_price,
  dbt_valid_from AS valid_from,
  dbt_valid_to AS valid_to,
  CASE WHEN dbt_valid_to IS NULL THEN true ELSE false END AS is_current
FROM {{ ref('snapshot_chinook_track') }}
