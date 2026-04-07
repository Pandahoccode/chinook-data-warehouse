{% snapshot snapshot_chinook_invoice_line %}

{{
    config(
        target_schema='dbt_snapshots_scd',
        unique_key='invoice_line_id',
        strategy='timestamp',
        updated_at='updated_at',
        invalidate_hard_deletes=True
    )
}}

SELECT
    invoice_line_id,
    invoice_id,
    track_id,
    unit_price,
    quantity,
    updated_at
FROM {{ ref('ods_chinook_invoice_line') }}

{% endsnapshot %}
