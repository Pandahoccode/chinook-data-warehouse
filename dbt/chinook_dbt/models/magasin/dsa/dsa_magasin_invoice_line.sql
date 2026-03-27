{{
    config(
        materialized='table',
        schema='dsa_magasin',
        post_hook=[
            "ALTER TABLE {{ this }} ADD PRIMARY KEY (invoice_line_id)",
            "ALTER TABLE {{ this }} ADD FOREIGN KEY (invoice_id) REFERENCES {{ source('dsa_magasin', 'dsa_magasin_invoice') }}(invoice_id)"
        ]
    )
}}

SELECT
    invoice_line_id,
    invoice_id,
    track_id,
    unit_price,
    quantity,
    'magasin' AS source_system
FROM {{ source('magasin', 'invoice_line') }}
WHERE invoice_line_id IS NOT NULL
