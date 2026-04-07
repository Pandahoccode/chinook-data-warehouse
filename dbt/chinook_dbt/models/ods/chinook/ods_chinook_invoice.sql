{{
    config(
        materialized='table',
        schema='ods_chinook'
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
    CURRENT_TIMESTAMP AS updated_at
FROM {{ ref('dsa_chinook_invoice') }}
