{% snapshot snapshot_chinook_artist %}

{{
    config(
        target_schema='csd_snapshot_chinook',
        unique_key='artist_id',
        strategy='timestamp',
        updated_at='updated_at',
        invalidate_hard_deletes=True
    )
}}

SELECT
    artist_id,
    artist_name,
    updated_at
FROM {{ ref('ods_chinook_artist') }}

{% endsnapshot %}
