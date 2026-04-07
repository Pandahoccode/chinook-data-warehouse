{{
    config(
        materialized='table',
        schema='ods_chinook'
    )
}}

SELECT
    playlist_id,
    playlist_name,
    CURRENT_TIMESTAMP AS updated_at
FROM {{ ref('dsa_chinook_playlist') }}
