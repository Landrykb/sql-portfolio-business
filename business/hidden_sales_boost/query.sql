-- Hidden Sales Boost
-- Domain: Business
-- My solution query

WITH BranchProduct As (
  SELECT branch, product_line, SUM(total) As total_revenue,
  ROUND(AVG(rating), 2) AS avg_rating, 
  COUNT(*) AS transaction_count FROM business_retail
  GROUP BY branch, product_line
)
  
SELECT 
  bp.branch, 
  bp.product_line, 
  bp.total_revenue, 
  bp.avg_rating, 
  bp.transaction_count, 
  CASE WHEN total_revenue > 18000 AND avg_rating < 7
THEN 'High Priority'
WHEN total_revenue > 15000 AND avg_rating < 7 
THEN 'Medium Priority'
ELSE 'Monitor' END AS growth_opportunity
FROM BranchProduct bp
GROUP BY branch, product_line
ORDER BY total_revenue DESC;



