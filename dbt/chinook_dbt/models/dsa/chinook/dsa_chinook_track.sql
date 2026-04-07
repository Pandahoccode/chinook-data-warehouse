{{
    config(
        materialized='table',
        schema='dsa_chinook',
        post_hook=[
            "ALTER TABLE {{ this }} ADD PRIMARY KEY (track_id)"
         ]
    )
}}

SELECT
    track_id,
    name AS track_name,
    album_id,
    media_type_id,
    genre_id,
    composer,
    milliseconds,
    bytes,
    unit_price
FROM {{ source('chinook', 'track') }}
WHERE track_id IS NOT NULL
