{{
    config(
        materialized='table',
        schema='dsa_chinook',
        post_hook=[
            "ALTER TABLE {{ this }} ADD PRIMARY KEY (customer_id)",
            "ALTER TABLE {{ this }} ADD FOREIGN KEY (support_rep_id) REFERENCES {{ source('dsa_chinook', 'dsa_chinook_employee') }}(employee_id)"
        ]
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
    support_rep_id
FROM {{ source('chinook', 'customer') }}
WHERE customer_id IS NOT NULL
