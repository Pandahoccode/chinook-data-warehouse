{{
    config(
        materialized='table',
        schema='ods_chinook'
    )
}}

SELECT
    track_id,
    track_name,
    album_id,
    media_type_id,
    genre_id,
    composer,
    milliseconds,
    bytes,
    unit_price,
    CURRENT_TIMESTAMP AS updated_at
FROM {{ ref('dsa_chinook_track') }}
