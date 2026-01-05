CREATE DATABASE session6;
USE session6;
INSERT INTO customers (customer_id, full_name, city) VALUES
(1, 'Nguyen Van An', 'Ho Chi Minh'),
(2, 'Tran Thi Bich', 'Ha Noi'),
(3, 'Le Minh Duc', 'Da Nang'),
(4, 'Pham Gia Huy', 'Can Tho'),
(5, 'Vo Thi Thu', 'Hai Phong');

INSERT INTO orders (order_id, customer_id, order_date, status) VALUES
(101, 1, '2026-01-01', 'completed'),
(102, 1, '2026-01-03', 'pending'),
(103, 2, '2026-01-02', 'cancelled'),
(104, 3, '2026-01-04', 'completed'),
(105, 4, '2026-01-05', 'pending');


SELECT
  o.order_id,
  o.order_date,
  o.status,
  c.full_name,
  c.city
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
ORDER BY o.order_date DESC;


SELECT
  c.customer_id,
  c.full_name,
  c.city,
  COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.full_name, c.city
ORDER BY total_orders DESC;


SELECT
  c.customer_id,
  c.full_name,
  c.city,
  COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.full_name, c.city
HAVING COUNT(o.order_id) >= 1
ORDER BY total_orders DESC;
