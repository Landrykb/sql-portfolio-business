# Business SQL Analytics Portfolio

## About
SQL data analysis projects completed through the **BleepxQuery SwiftLink Training Program**.
Domain: **Business** | Challenges Solved: **9/9** | Completion: **100%**

## Skills Demonstrated
- SQL (SELECT, JOIN, GROUP BY, Window Functions, CTEs, Subqueries)
- Data Analysis & Aggregation
- Real-world problem solving with industry datasets

## Projects

### 1. Basics Select
- **Attempts:** 8


```sql
SELECT invoice_id, branch, total
  FROM business_retail WHERE branch = 'A'
  ORDER BY total DESC
  LIMIT 5; 
```

### 2. Agg Revenue
- **Attempts:** 2


```sql
SELECT product_line, SUM(total) AS total_revenue
FROM business_retail
GROUP BY product_line
ORDER BY SUM(total);
```

### 3. Joins Returns
- **Attempts:** 5


```sql
SELECT b.invoice_id, b.total, r.return_reason
FROM business_retail b
LEFT JOIN returns r ON b.invoice_id = r.invoice_id 
WHERE r.return_reason IS NOT NULL
ORDER BY b.total DESC
LIMIT 5 ;
```

### 4. Window Cumsum
- **Attempts:** 7


```sql
SELECT branch, date, total, 
SUM(total) OVER(PARTITION BY branch ORDER BY date) AS cumulative_sales
FROM business_retail 
ORDER BY branch, date;
```

### 5. Cte Profit
- **Attempts:** 7


```sql
WITH ReturnTotals AS 
  (SELECT b.branch, SUM(b.total) AS return_total 
  FROM business_retail b 
  JOIN returns r ON b.invoice_id = r.invoice_id 
  GROUP BY b.branch
  )
SELECT b.branch, SUM(b.total) - COALESCE(r.return_total, 0) AS net_profit 
FROM business_retail b 
LEFT JOIN ReturnTotals r ON b.branch = r.branch
GROUP BY b.branch
ORDER BY net_profit DESC;
```

### 6. Capstone Root
- **Attempts:** 17


```sql
WITH Sales AS (
  SELECT 
  product_line, 
  branch, 
  SUM(total) AS total_sales
  FROM business_retail
  GROUP BY product_line, branch
),
ReturnCounts AS (
  SELECT 
  b.branch, 
  b.product_line, 
  COUNT(*) AS return_count
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
  ON s.branch = rc.branch AND s.product_line = rc.product_line
ORDER BY total_sales DESC;
```

### 7. Hidden Sales Boost
- **Attempts:** 7


```sql
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



```

### 8. Hidden Credit Recommend
- **Attempts:** 4


```sql
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
```

### 9. Hidden Inventory Alert
- **Attempts:** 4


```sql

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



```

---
*Generated by [BleepxQuery](https://bleepxacademy.vercel.app) — SwiftLink Training Program*
