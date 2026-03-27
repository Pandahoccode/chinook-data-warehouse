{{
    config(
        materialized='table',
        schema='dsa_chinook',
        post_hook=[
            "ALTER TABLE {{ this }} ADD PRIMARY KEY (playlist_id)"
        ]
    )
}}

SELECT
    playlist_id,
    name AS playlist_name
FROM {{ source('chinook', 'playlist') }}
WHERE playlist_id IS NOT NULL
