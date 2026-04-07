{{
    config(
        materialized='table',
        schema='dsa_chinook',
        post_hook=[
            "ALTER TABLE {{ this }} ADD PRIMARY KEY (invoice_line_id)"
         ]
    )
}}

SELECT
    invoice_line_id,
    invoice_id,
    track_id,
    unit_price,
    quantity
FROM {{ source('chinook', 'invoice_line') }}
WHERE invoice_line_id IS NOT NULL
