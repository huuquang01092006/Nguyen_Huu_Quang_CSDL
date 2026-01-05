
SELECT
  o.order_date,
  SUM(o.total_amount) AS total_revenue,
  COUNT(o.order_id)   AS total_orders
FROM orders o
WHERE o.status = 'completed'
GROUP BY o.order_date
HAVING SUM(o.total_amount) > 10000000
ORDER BY o.order_date;
