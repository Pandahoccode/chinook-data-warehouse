{% snapshot snapshot_chinook_playlist_track %}

{{
    config(
        target_schema='csd_snapshot_chinook',
        unique_key=['playlist_id', 'track_id'],
        strategy='timestamp',
        updated_at='updated_at',
        invalidate_hard_deletes=True
    )
}}

SELECT
    playlist_id,
    track_id,
    updated_at
FROM {{ ref('ods_chinook_playlist_track') }}

{% endsnapshot %}
