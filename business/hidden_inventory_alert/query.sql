-- Hidden Inventory Alert
-- Domain: Business
-- My solution query


WITH ProductSales AS (
  SELECT 
  product_line, 
  COUNT(DISTINCT b.invoice_id) AS total_sales,
  ROUND(SUM(b.total), 2) AS total_revenue, 
  ROUND(AVG(b.rating), 2) AS avg_rating
  FROM business_retail b
  GROUP BY product_line
),
ProductReturns AS (
  SELECT 
  b.product_line,
  COUNT(DISTINCT r.invoice_id) AS total_returns
  FROM returns r
  JOIN business_retail b ON r.invoice_id = b.invoice_id
  GROUP BY b.product_line
),
Combined AS (
  SELECT 
  ps.product_line,
  ps.total_sales,
  ps.total_revenue,
  ps.avg_rating,
  COALESCE(pr.total_returns, 0) AS total_returns,
  ROUND(COALESCE(pr.total_returns, 0) * 100.0 / ps.total_sales, 2) AS return_rate_pct
FROM ProductSales ps
  LEFT JOIN ProductReturns pr ON ps.product_line = pr.product_line
)
SELECT
  product_line,
  total_sales,
  total_revenue,
  avg_rating,
  total_returns,
  return_rate_pct,
CASE 
  WHEN return_rate_pct > (SELECT AVG(return_rate_pct) FROM Combined) * 1.2 
    THEN 'URGENT AUDIT'
  WHEN return_rate_pct > (SELECT AVG(return_rate_pct) FROM Combined) 
    THEN 'REVIEW'
  ELSE 'OK'
END AS quality_status
  FROM Combined
ORDER BY return_rate_pct DESC;



