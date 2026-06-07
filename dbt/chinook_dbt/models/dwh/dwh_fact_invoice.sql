-- models/dwh/fact_invoice.sql
{{ config(schema='datawarehouse') }}

WITH customer_min AS (
  SELECT customer_id, MIN(valid_from) AS min_valid_from
  FROM {{ ref('dwh_dim_customer') }}
  GROUP BY customer_id
),

employee_min AS (
  SELECT employee_id, MIN(valid_from) AS min_valid_from
  FROM {{ ref('dwh_dim_employee') }}
  GROUP BY employee_id
),

track_min AS (
  SELECT track_id, MIN(valid_from) AS min_valid_from
  FROM {{ ref('dwh_dim_track') }}
  GROUP BY track_id
)

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
 AND il.dbt_valid_to IS NULL
 AND i.dbt_valid_to IS NULL

-- CUSTOMER SCD2
JOIN {{ ref('dwh_dim_customer') }} dc
  ON i.customer_id = dc.customer_id
JOIN customer_min cm
  ON dc.customer_id = cm.customer_id
 AND (
   i.invoice_date BETWEEN dc.valid_from AND COALESCE(dc.valid_to, '9999-12-31')
   OR (
     dc.valid_from = cm.min_valid_from
     AND i.invoice_date < dc.valid_from
   )
 )

-- EMPLOYEE via CUSTOMER
JOIN {{ ref('dwh_dim_employee') }} de
  ON dc.support_rep_id = de.employee_id
JOIN employee_min em
  ON de.employee_id = em.employee_id
 AND (
   i.invoice_date BETWEEN de.valid_from AND COALESCE(de.valid_to, '9999-12-31')
   OR (
     de.valid_from = em.min_valid_from
     AND i.invoice_date < de.valid_from
   )
 )

-- PRODUCT
JOIN {{ ref('dwh_dim_track') }} dt
  ON il.track_id = dt.track_id
JOIN track_min tm
  ON dt.track_id = tm.track_id
 AND (
   i.invoice_date BETWEEN dt.valid_from AND COALESCE(dt.valid_to, '9999-12-31')
   OR (
     dt.valid_from = tm.min_valid_from
     AND i.invoice_date < dt.valid_from
   )
 )

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
 AND il.dbt_valid_to IS NULL
 AND i.dbt_valid_to IS NULL
JOIN {{ ref('dwh_dim_date') }} dd
  ON DATE(i.invoice_date) = dd.date_id
