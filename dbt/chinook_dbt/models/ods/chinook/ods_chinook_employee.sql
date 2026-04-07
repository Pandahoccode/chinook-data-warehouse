{{
    config(
        materialized='table',
        schema='ods_chinook'
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
    email,
    CURRENT_TIMESTAMP AS updated_at
FROM {{ ref('dsa_chinook_employee') }}
