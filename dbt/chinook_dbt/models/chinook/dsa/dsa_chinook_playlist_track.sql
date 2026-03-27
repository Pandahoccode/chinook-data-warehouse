{{
    config(
        materialized='table',
        schema='dsa_chinook',
        post_hook=[
            "ALTER TABLE {{ this }} ADD PRIMARY KEY (playlist_id, track_id)",
            "ALTER TABLE {{ this }} ADD FOREIGN KEY (playlist_id) REFERENCES {{ source('dsa_chinook', 'dsa_chinook_playlist') }}(playlist_id)",
            "ALTER TABLE {{ this }} ADD FOREIGN KEY (track_id) REFERENCES {{ source('dsa_chinook', 'dsa_chinook_track') }}(track_id)"
        ]
    )
}}

SELECT
    playlist_id,
    track_id
FROM {{ source('chinook', 'playlist_track') }}
WHERE playlist_id IS NOT NULL AND track_id IS NOT NULL
