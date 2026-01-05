
USE session6;

SELECT
  c.customer_id,
  c.full_name,
  c.city,
  COUNT(o.order_id)        AS total_orders,
  SUM(o.total_amount)      AS total_spent,
  AVG(o.total_amount)      AS avg_order_value
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
WHERE o.status = 'completed'
GROUP BY c.customer_id, c.full_name, c.city
HAVING COUNT(o.order_id) >= 3
   AND SUM(o.total_amount) > 10000000
ORDER BY total_spent DESC;
