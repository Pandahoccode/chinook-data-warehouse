{% snapshot snapshot_chinook_playlist %}

{{
    config(
        target_schema='csd_snapshot_chinook',
        unique_key='playlist_id',
        strategy='timestamp',
        updated_at='updated_at',
        invalidate_hard_deletes=True
    )
}}

SELECT
    playlist_id,
    playlist_name,
    updated_at
FROM {{ ref('ods_chinook_playlist') }}

{% endsnapshot %}
