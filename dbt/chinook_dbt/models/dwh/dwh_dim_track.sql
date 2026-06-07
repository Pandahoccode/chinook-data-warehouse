-- models/dwh/dim_track.sql
{{ config(schema='datawarehouse') }}

SELECT
  {{ generate_surrogate_key(['track_id']) }} AS track_sk,
  track_id,
  track_name,
  composer,
  milliseconds,
  bytes,
  unit_price
FROM {{ ref('snapshot_chinook_track') }}
