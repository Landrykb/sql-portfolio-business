-- Agg Revenue
-- Domain: Business
-- My solution query

SELECT product_line, SUM(total) AS total_revenue
FROM business_retail
GROUP BY product_line
ORDER BY SUM(total);
