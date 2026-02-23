-- Hidden Sales Boost
-- Domain: Business
-- BleepxQuery SwiftLink Training Program

WITH BranchProduct AS (
  SELECT
    branch,
    product_line,
    SUM(total) AS total_revenue,
    ROUND(AVG(rating), 2) AS avg_rating,
    COUNT(*) AS transaction_count
  FROM business_retail
  GROUP BY branch, product_line
)
SELECT
  branch,
  product_line,
  total_revenue,
  avg_rating,
  transaction_count,
  CASE
    WHEN total_revenue > 18000 AND avg_rating < 7.0 THEN 'High Priority'
    WHEN total_revenue > 15000 AND avg_rating < 7.0 THEN 'Medium Priority'
    ELSE 'Monitor'
  END AS growth_opportunity
FROM BranchProduct
ORDER BY total_revenue DESC;
