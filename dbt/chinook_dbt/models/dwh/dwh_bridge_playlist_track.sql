{{ config(schema='datawarehouse') }}

SELECT
    playlist_id,
    track_id
FROM {{ ref('snapshot_chinook_playlist_track') }}
WHERE dbt_valid_to IS NULL

