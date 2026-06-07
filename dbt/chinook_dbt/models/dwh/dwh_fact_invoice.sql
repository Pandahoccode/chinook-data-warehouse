-- models/dwh/fact_invoice.sql
{{ config(schema='datawarehouse') }}

-- =========================
-- CHINOOK
-- =========================
SELECT
  ('chinook_' || il.invoice_line_id::text) AS fact_id,
  dc.customer_sk,
  de.employee_sk,
  dt.track_sk,
  dd.date_id,
  il.quantity,
  il.unit_price,
  il.quantity * il.unit_price AS total_price,
  i.billing_address,
  i.billing_city,
  i.billing_state,
  i.billing_country,
  i.billing_postal_code,
  'chinook' AS source_system
FROM {{ ref('snapshot_chinook_invoice_line') }} il
JOIN {{ ref('snapshot_chinook_invoice') }} i
  ON il.invoice_id = i.invoice_id

-- CUSTOMER SCD2
JOIN {{ ref('dwh_dim_customer') }} dc
  ON i.customer_id = dc.customer_id
 AND (
   i.invoice_date BETWEEN dc.valid_from AND COALESCE(dc.valid_to, '9999-12-31')
   OR (
     dc.valid_from = (
       SELECT MIN(sub.valid_from)
       FROM {{ ref('dwh_dim_customer') }} sub
       WHERE sub.customer_id = dc.customer_id
     )
     AND i.invoice_date < dc.valid_from
   )
 )

-- EMPLOYEE via CUSTOMER
JOIN {{ ref('snapshot_chinook_customer') }} c
  ON i.customer_id = c.customer_id
JOIN {{ ref('dwh_dim_employee') }} de
  ON c.support_rep_id = de.employee_id
 AND (
   i.invoice_date BETWEEN de.valid_from AND COALESCE(de.valid_to, '9999-12-31')
   OR (
     de.valid_from = (
       SELECT MIN(sub.valid_from)
       FROM {{ ref('dwh_dim_employee') }} sub
       WHERE sub.employee_id = de.employee_id
     )
     AND i.invoice_date < de.valid_from
   )
 )

-- PRODUCT
JOIN {{ ref('dwh_dim_track') }} dt
  ON il.track_id = dt.track_id

-- DATE
JOIN {{ ref('dwh_dim_date') }} dd
  ON DATE(i.invoice_date) = dd.date_id

UNION ALL

-- =========================
-- MAGASIN
-- =========================
SELECT
  ('magasin_' || il.invoice_line_id::text) AS fact_id,
  NULL AS customer_sk,
  NULL AS employee_sk,
  NULL AS track_sk,
  dd.date_id,
  il.quantity,
  il.unit_price,
  il.quantity * il.unit_price AS total_price,
  i.billing_address,
  i.billing_city,
  i.billing_state,
  i.billing_country,
  i.billing_postal_code,
  'magasin' AS source_system
FROM {{ ref('snapshot_magasin_invoice_line') }} il
JOIN {{ ref('snapshot_magasin_invoice') }} i
  ON il.invoice_id = i.invoice_id
JOIN {{ ref('dwh_dim_date') }} dd
  ON DATE(i.invoice_date) = dd.date_id
