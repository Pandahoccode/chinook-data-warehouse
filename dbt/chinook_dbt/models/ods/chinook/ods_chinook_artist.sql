{{
    config(
        materialized='table',
        schema='ods_chinook'
    )
}}

SELECT
    artist_id,
    artist_name,
    CURRENT_TIMESTAMP AS updated_at
FROM {{ ref('dsa_chinook_artist') }}
