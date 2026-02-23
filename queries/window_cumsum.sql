-- Window Cumsum
-- Domain: Business
-- BleepxQuery SwiftLink Training Program

SELECT branch, date, total,
 SUM(total) OVER (PARTITION BY branch ORDER BY date) AS cumulative_sales
FROM business_retail
ORDER BY branch, date;
