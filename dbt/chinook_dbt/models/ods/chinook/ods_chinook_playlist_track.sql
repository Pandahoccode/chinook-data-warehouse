{{
    config(
        materialized='table',
        schema='ods_chinook'
    )
}}

SELECT
    playlist_id,
    track_id,
    CURRENT_TIMESTAMP AS updated_at
FROM {{ ref('dsa_chinook_playlist_track') }}
