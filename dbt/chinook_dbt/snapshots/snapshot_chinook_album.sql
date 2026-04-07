{% snapshot snapshot_chinook_album %}

{{
    config(
        target_schema='dbt_snapshots_scd',
        unique_key='album_id',
        strategy='timestamp',
        updated_at='updated_at',
        invalidate_hard_deletes=True
    )
}}

SELECT
    album_id,
    album_title,
    artist_id,
    updated_at
FROM {{ ref('ods_chinook_album') }}

{% endsnapshot %}
