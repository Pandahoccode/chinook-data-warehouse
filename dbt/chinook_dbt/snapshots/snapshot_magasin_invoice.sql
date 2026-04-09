{% snapshot snapshot_magasin_invoice %}

{{
    config(
        target_schema='csd_snapshot_magasin',
        unique_key='invoice_id',
        strategy='timestamp',
        updated_at='updated_at',
        invalidate_hard_deletes=True
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
    source_system,
    updated_at
FROM {{ ref('ods_magasin_invoice') }}

{% endsnapshot %}
