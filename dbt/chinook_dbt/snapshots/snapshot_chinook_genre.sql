{% snapshot snapshot_chinook_genre %}

{{
    config(
        target_schema='dbt_snapshots_scd',
        unique_key='genre_id',
        strategy='timestamp',
        updated_at='updated_at',
        invalidate_hard_deletes=True
    )
}}

SELECT
    genre_id,
    genre_name,
    updated_at
FROM {{ ref('ods_chinook_genre') }}

{% endsnapshot %}
