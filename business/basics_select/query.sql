-- Basics Select
-- Domain: Business
-- My solution query

SELECT invoice_id, branch, total
  FROM business_retail WHERE branch = 'A'
  ORDER BY total DESC
  LIMIT 5; 
