SELECT * 
FROM txn_data

-- Writing a query to check for structuring of multiple payments under $10k

SELECT 
  customer_id,
  COUNT(*) AS txn_count,
  SUM(amount) AS total_amount,
  MIN(timestamp) AS start_time,
  MAX(timestamp) AS end_time
FROM txn_data
WHERE customer_id = 'C123'
  AND CAST(timestamp AS DATE) = '2025-04-01'
  AND amount < 10000
GROUP BY customer_id
HAVING COUNT(*) >= 5 AND SUM (AMOUNT) > 45000