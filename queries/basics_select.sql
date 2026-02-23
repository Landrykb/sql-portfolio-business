-- Basics Select
-- Domain: Business
-- BleepxQuery SwiftLink Training Program

-- TODO: write query for basics_select
SELECT * FROM business_retail
  WHERE  business_retail.branch = "A"
  ORDER BY  business_retail.gross_income DESC
  LIMIT 5;
