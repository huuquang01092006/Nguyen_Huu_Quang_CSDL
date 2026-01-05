USE session6;

SELECT
  p.product_name                                   AS product_name,
  SUM(oi.quantity)                                 AS total_quantity_sold,
  SUM(oi.quantity * p.price)                       AS total_revenue,
  ROUND(SUM(oi.quantity * p.price) / SUM(oi.quantity), 2) AS avg_unit_price
FROM products p
JOIN order_items oi ON oi.product_id = p.product_id
JOIN orders o ON o.order_id = oi.order_id
WHERE o.status = 'completed'
GROUP BY p.product_id, p.product_name
HAVING SUM(oi.quantity) >= 10
ORDER BY total_revenue DESC
LIMIT 5;
