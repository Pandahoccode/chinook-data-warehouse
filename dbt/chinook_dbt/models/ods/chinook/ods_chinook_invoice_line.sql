{{
    config(
        materialized='table',
        schema='ods_chinook'
    )
}}

SELECT
    invoice_line_id,
    invoice_id,
    track_id,
    unit_price,
    quantity,
    CURRENT_TIMESTAMP AS updated_at
FROM {{ ref('dsa_chinook_invoice_line') }}
