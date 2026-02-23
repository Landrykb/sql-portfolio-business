-- Agg Revenue
-- Domain: Business
-- BleepxQuery SwiftLink Training Program

SELECT product_line, SUM(total) AS total_revenue
FROM business_retail
GROUP BY product_line
ORDER BY total_revenue DESC;
