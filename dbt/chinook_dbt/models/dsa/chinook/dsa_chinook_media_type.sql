{{
    config(
        materialized='table',
        schema='dsa_chinook',
        post_hook=[
            "ALTER TABLE {{ this }} ADD PRIMARY KEY (media_type_id)"
         ]
    )
}}

SELECT
    media_type_id,
    name AS media_type_name
FROM {{ source('chinook', 'media_type') }}
WHERE media_type_id IS NOT NULL
