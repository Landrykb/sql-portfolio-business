-- Joins Returns
-- Domain: Business
-- My solution query

SELECT b.invoice_id, b.total, r.return_reason
FROM business_retail b
LEFT JOIN returns r ON b.invoice_id = r.invoice_id 
WHERE r.return_reason IS NOT NULL
ORDER BY b.total DESC
LIMIT 5 ;
