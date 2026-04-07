{{
    config(
        materialized='table',
        schema='dsa_chinook',
        post_hook=[
            "ALTER TABLE {{ this }} ADD PRIMARY KEY (invoice_id)"
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
    total
FROM {{ source('chinook', 'invoice') }}
WHERE invoice_id IS NOT NULL
