-- Hidden Credit Recommend
-- Domain: Business
-- My solution query

WITH CustomerMetrics AS (
  SELECT
    b.customer_type,
    b.gender,
    b.branch,
    COUNT(DISTINCT b.invoice_id) AS total_purchases,
    ROUND(SUM(b.total), 2) AS total_spent,
    ROUND(AVG(b.rating), 2) AS avg_rating,
    COUNT(DISTINCT r.invoice_id) AS return_count
  FROM business_retail b
  LEFT JOIN returns r ON b.invoice_id = r.invoice_id
  GROUP BY b.customer_type, b.gender, b.branch
),
Scored AS (
  SELECT *,
    CASE
      WHEN total_spent > 30000 AND avg_rating >= 7.0 AND return_count < 30 THEN 'Platinum Invite'
      WHEN total_spent > 20000 AND avg_rating >= 6.5 THEN 'Gold Invite'
      WHEN total_spent > 10000 THEN 'Silver Invite'
      ELSE 'Not Eligible'
    END AS program_tier,
    ROW_NUMBER() OVER (ORDER BY total_spent DESC) AS spend_rank
  FROM CustomerMetrics
)
SELECT
  branch,
  customer_type,
  gender,
  total_purchases,
  total_spent,
  avg_rating,
  return_count,
  program_tier,
  spend_rank
FROM Scored
ORDER BY spend_rank;
