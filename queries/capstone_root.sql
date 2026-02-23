-- Capstone Root
-- Domain: Business
-- BleepxQuery SwiftLink Training Program

WITH Sales AS (
  SELECT
    branch,
    product_line,
    SUM(total)          AS total_sales
  FROM business_retail
  GROUP BY branch, product_line
),
ReturnCounts AS (
  SELECT
    b.branch,
    b.product_line,
    COUNT(*)            AS return_count
  FROM returns r
  INNER JOIN business_retail b
    ON r.invoice_id = b.invoice_id
  GROUP BY b.branch, b.product_line
)
SELECT
  s.branch,
  s.product_line,
  s.total_sales,
  COALESCE(rc.return_count, 0) AS return_count
FROM Sales s
LEFT JOIN ReturnCounts rc
  ON s.branch       = rc.branch
AND s.product_line = rc.product_line
ORDER BY s.total_sales DESC;
