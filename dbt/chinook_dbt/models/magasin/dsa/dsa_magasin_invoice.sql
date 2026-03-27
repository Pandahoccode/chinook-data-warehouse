{{
    config(
        materialized='table',
        schema='dsa_magasin',
        post_hook=[
            "ALTER TABLE {{ this }} ADD PRIMARY KEY (invoice_id)",
            "ALTER TABLE {{ this }} ADD COLUMN IF NOT EXISTS created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP"
        ]
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
    'magasin' AS source_system
FROM {{ source('magasin', 'invoice') }}
WHERE invoice_id IS NOT NULL
