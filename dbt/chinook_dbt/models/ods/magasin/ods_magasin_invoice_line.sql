{{
    config(
        materialized='table',
        schema='ods_magasin'
    )
}}

SELECT
    invoice_line_id,
    invoice_id,
    track_id,
    unit_price,
    quantity,
    source_system,
    CURRENT_TIMESTAMP AS updated_at
FROM {{ ref('dsa_magasin_invoice_line') }}
