{{
    config(
        materialized='table',
        schema='dsa_chinook',
        post_hook=[
            "ALTER TABLE {{ this }} ADD PRIMARY KEY (artist_id)"
        ]
    )
}}

SELECT
    artist_id,
    name AS artist_name
FROM {{ source('chinook', 'artist') }}
WHERE artist_id IS NOT NULL
