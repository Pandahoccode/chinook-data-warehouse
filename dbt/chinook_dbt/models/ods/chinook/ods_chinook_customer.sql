{{
    config(
        materialized='table',
        schema='ods_chinook'
    )
}}

SELECT
    customer_id,
    first_name,
    last_name,
    company,
    address,
    city,
    state,
    country,
    postal_code,
    phone,
    fax,
    email,
    support_rep_id,
    CURRENT_TIMESTAMP AS updated_at
FROM {{ ref('dsa_chinook_customer') }}
