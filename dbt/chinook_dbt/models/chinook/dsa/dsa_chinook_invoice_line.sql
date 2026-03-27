{{
    config(
        materialized='table',
        schema='dsa_chinook',
        post_hook=[
            "ALTER TABLE {{ this }} ADD PRIMARY KEY (invoice_line_id)",
            "ALTER TABLE {{ this }} ADD FOREIGN KEY (invoice_id) REFERENCES {{ source('dsa_chinook', 'dsa_chinook_invoice') }}(invoice_id)",
            "ALTER TABLE {{ this }} ADD FOREIGN KEY (track_id) REFERENCES {{ source('dsa_chinook', 'dsa_chinook_track') }}(track_id)"
        ]
    )
}}

SELECT
    invoice_line_id,
    invoice_id,
    track_id,
    unit_price,
    quantity
FROM {{ source('chinook', 'invoice_line') }}
WHERE invoice_line_id IS NOT NULL
