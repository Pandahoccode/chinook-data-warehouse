{{
    config(
        materialized='table',
        schema='dsa_chinook',
        post_hook=[
            "ALTER TABLE {{ this }} ADD PRIMARY KEY (album_id)",
            "ALTER TABLE {{ this }} ADD FOREIGN KEY (artist_id) REFERENCES {{ source('dsa_chinook', 'dsa_chinook_artist') }}(artist_id)"
        ]
    )
}}

SELECT
    album_id,
    title AS album_title,
    artist_id
FROM {{ source('chinook', 'album') }}
WHERE album_id IS NOT NULL
