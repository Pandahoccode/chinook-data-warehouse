{% snapshot snapshot_chinook_customer %}

{{
    config(
        target_schema='dbt_snapshots_scd',
        unique_key='customer_id',
        strategy='timestamp',
        updated_at='updated_at',
        invalidate_hard_deletes=True
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
    updated_at
FROM {{ ref('ods_chinook_customer') }}

{% endsnapshot %}
