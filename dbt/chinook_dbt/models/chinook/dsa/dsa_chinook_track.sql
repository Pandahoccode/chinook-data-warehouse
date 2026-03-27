{{
    config(
        materialized='table',
        schema='dsa_chinook',
        post_hook=[
            "ALTER TABLE {{ this }} ADD PRIMARY KEY (track_id)",
            "ALTER TABLE {{ this }} ADD FOREIGN KEY (album_id) REFERENCES {{ source('dsa_chinook', 'dsa_chinook_album') }}(album_id)",
            "ALTER TABLE {{ this }} ADD FOREIGN KEY (media_type_id) REFERENCES {{ source('dsa_chinook', 'dsa_chinook_media_type') }}(media_type_id)",
            "ALTER TABLE {{ this }} ADD FOREIGN KEY (genre_id) REFERENCES {{ source('dsa_chinook', 'dsa_chinook_genre') }}(genre_id)"
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
