{{
    config(
        materialized='table',
        schema='ods_magasin'
    )
}}

SELECT
    invoice_id,
    customer_id,
    invoice_date,
    billing_address,
    billing_city,
    billing_state,
    billing_country,
    billing_postal_code,
    total,
    source_system,
    CURRENT_TIMESTAMP AS updated_at
FROM {{ ref('dsa_magasin_invoice') }}
