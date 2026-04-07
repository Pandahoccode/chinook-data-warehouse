{{
    config(
        materialized='table',
        schema='dsa_chinook',
        post_hook=[
            "ALTER TABLE {{ this }} ADD PRIMARY KEY (employee_id)"
        ]
    )
}}

SELECT
    employee_id,
    last_name,
    first_name,
    title,
    reports_to,
    birth_date,
    hire_date,
    address,
    city,
    state,
    country,
    postal_code,
    phone,
    fax,
    email
FROM {{ source('chinook', 'employee') }}
WHERE employee_id IS NOT NULL
