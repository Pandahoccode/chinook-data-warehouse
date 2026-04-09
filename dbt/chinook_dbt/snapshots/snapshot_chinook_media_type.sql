{% snapshot snapshot_chinook_media_type %}

{{
    config(
        target_schema='csd_snapshot_chinook',
        unique_key='media_type_id',
        strategy='timestamp',
        updated_at='updated_at',
        invalidate_hard_deletes=True
    )
}}

SELECT
    media_type_id,
    media_type_name,
    updated_at
FROM {{ ref('ods_chinook_media_type') }}

{% endsnapshot %}
