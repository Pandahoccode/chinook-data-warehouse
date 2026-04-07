{% snapshot snapshot_chinook_employee %}

{{
    config(
        target_schema='dbt_snapshots_scd',
        unique_key='employee_id',
        strategy='timestamp',
        updated_at='updated_at',
        invalidate_hard_deletes=True
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
    updated_at
FROM {{ ref('ods_chinook_employee') }}

{% endsnapshot %}
