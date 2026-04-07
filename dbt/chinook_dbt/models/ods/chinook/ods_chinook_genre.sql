{{
    config(
        materialized='table',
        schema='ods_chinook'
    )
}}

SELECT
    genre_id,
    genre_name,
    CURRENT_TIMESTAMP AS updated_at
FROM {{ ref('dsa_chinook_genre') }}
