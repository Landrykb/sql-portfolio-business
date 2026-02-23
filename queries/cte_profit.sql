-- Cte Profit
-- Domain: Business
-- BleepxQuery SwiftLink Training Program

WITH ReturnTotals AS (
 SELECT b.branch, SUM(b.total) AS return_total
 FROM business_retail b
 JOIN returns r ON b.invoice_id = r.invoice_id
 GROUP BY b.branch
)
SELECT b.branch, SUM(b.total) - COALESCE(r.return_total, 0) AS net_profit
FROM business_retail b
LEFT JOIN ReturnTotals r ON b.branch = r.branch
GROUP BY b.branch
ORDER BY net_profit DESC;
