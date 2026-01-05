
USE session6;

ALTER TABLE orders
ADD COLUMN total_amount DECIMAL(10,2);

UPDATE orders SET total_amount = 1250.50 WHERE order_id = 101;
UPDATE orders SET total_amount = 450.00  WHERE order_id = 102;
UPDATE orders SET total_amount = 0.00    WHERE order_id = 103; 
UPDATE orders SET total_amount = 980.25  WHERE order_id = 104;
UPDATE orders SET total_amount = 199.99  WHERE order_id = 105;


SELECT
  c.customer_id,
  c.full_name,
  c.city,
  SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
-- WHERE o.status = 'completed'
GROUP BY c.customer_id, c.full_name, c.city
ORDER BY total_spent DESC;


SELECT
  c.customer_id,
  c.full_name,
  c.city,
  MAX(o.total_amount) AS max_order_value
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
-- WHERE o.status = 'completed'
GROUP BY c.customer_id, c.full_name, c.city
ORDER BY max_order_value DESC;


SELECT
  c.customer_id,
  c.full_name,
  c.city,
  SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.full_name, c.city
ORDER BY total_spent DESC;
