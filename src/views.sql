-- Views for the Coffee Shop database

-- 1) Staff locations (exclude owners/executives)
CREATE OR REPLACE VIEW public.staff_locations_view AS
SELECT s.staff_id,
       s.first_name,
       s.last_name,
       s.location
FROM public.staff AS s
WHERE s."position" NOT IN ('CEO', 'CFO');

-- 2) Product info materialized view (for cross-DB exports)
CREATE MATERIALIZED VIEW IF NOT EXISTS public.product_info_m_view AS
SELECT p.product_name,
       p.description,
       pt.product_category
FROM public.product AS p
JOIN public.product_type AS pt
  ON p.product_type_id = pt.product_type_id
WITH NO DATA;

-- First populate the MV
REFRESH MATERIALIZED VIEW public.product_info_m_view;
