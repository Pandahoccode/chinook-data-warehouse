{{ config(schema='datawarehouse') }}

SELECT
    playlist_id,
    playlist_name AS name
FROM {{ ref('snapshot_chinook_playlist') }}
WHERE dbt_valid_to IS NULL

