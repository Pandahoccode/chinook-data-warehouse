{{
    config(
        materialized='table',
        schema='ods_chinook'
    )
}}

SELECT
    album_id,
    album_title,
    artist_id,
    CURRENT_TIMESTAMP AS updated_at
FROM {{ ref('dsa_chinook_album') }}
