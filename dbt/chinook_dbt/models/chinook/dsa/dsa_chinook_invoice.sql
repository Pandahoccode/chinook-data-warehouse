{{
    config(
        materialized='table',
        schema='dsa_chinook',
        post_hook=[
            "ALTER TABLE {{ this }} ADD PRIMARY KEY (invoice_id)",
            "ALTER TABLE {{ this }} ADD FOREIGN KEY (customer_id) REFERENCES {{ source('dsa_chinook', 'dsa_chinook_customer') }}(customer_id)"
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
