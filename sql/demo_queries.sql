-- Demo queries for quick exploration

-- 1) Top products by revenue
SELECT p.product_name,
       SUM(d.quantity * d.price) AS revenue
FROM public.sales_detail d
JOIN public.product p ON p.product_id = d.product_id
GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 10;

-- 2) Sales by outlet
SELECT t.sales_outlet_id,
       COUNT(*)                    AS transactions,
       SUM(d.quantity * d.price)   AS revenue
FROM public.sales_transaction t
JOIN public.sales_detail d ON d.transaction_id = t.transaction_id
GROUP BY t.sales_outlet_id
ORDER BY revenue DESC;

-- 3) Staff count by location (excluding executives)
SELECT s.location,
       COUNT(*) AS staff_count
FROM public.staff s
WHERE s."position" NOT IN ('CEO', 'CFO')
GROUP BY s.location
ORDER BY staff_count DESC;

-- 4) Products by category
SELECT pt.product_category,
       COUNT(*) AS products
FROM public.product p
JOIN public.product_type pt ON pt.product_type_id = p.product_type_id
GROUP BY pt.product_category
ORDER BY products DESC;
