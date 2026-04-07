{% snapshot snapshot_chinook_track %}

{{
    config(
        target_schema='dbt_snapshots_scd',
        unique_key='track_id',
        strategy='timestamp',
        updated_at='updated_at',
        invalidate_hard_deletes=True
    )
}}

SELECT
    track_id,
    track_name,
    album_id,
    media_type_id,
    genre_id,
    composer,
    milliseconds,
    bytes,
    unit_price,
    updated_at
FROM {{ ref('ods_chinook_track') }}

{% endsnapshot %}
