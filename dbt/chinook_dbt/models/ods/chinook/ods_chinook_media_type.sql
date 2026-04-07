{{
    config(
        materialized='table',
        schema='ods_chinook'
    )
}}

SELECT
    media_type_id,
    media_type_name,
    CURRENT_TIMESTAMP AS updated_at
FROM {{ ref('dsa_chinook_media_type') }}
