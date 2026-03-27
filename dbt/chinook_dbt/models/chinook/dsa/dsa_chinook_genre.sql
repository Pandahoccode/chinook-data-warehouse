{{
    config(
        materialized='table',
        schema='dsa_chinook',
        post_hook=[
            "ALTER TABLE {{ this }} ADD PRIMARY KEY (genre_id)"
        ]
    )
}}

SELECT
    genre_id,
    name AS genre_name
FROM {{ source('chinook', 'genre') }}
WHERE genre_id IS NOT NULL
