{{
    config(
        materialized='table',
        schema='dsa_chinook',
        post_hook=[
            "ALTER TABLE {{ this }} ADD PRIMARY KEY (playlist_id, track_id)"
         ]
    )
}}

SELECT
    playlist_id,
    track_id
FROM {{ source('chinook', 'playlist_track') }}
WHERE playlist_id IS NOT NULL AND track_id IS NOT NULL
