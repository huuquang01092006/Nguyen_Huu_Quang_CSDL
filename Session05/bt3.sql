CREATE DATABASE session5;
USE session5;

CREATE TABLE orders (
    order_id      INT AUTO_INCREMENT PRIMARY KEY,
    customer_id   INT NOT NULL,
    total_amount  DECIMAL(10,2) NOT NULL,
    order_date    DATE NOT NULL,
    status        ENUM('pending','completed','cancelled') NOT NULL
);

INSERT INTO orders (customer_id, total_amount, order_date, status) VALUES
(1, 3200000, '2025-01-05', 'completed'),
(2, 7500000, '2025-01-10', 'completed'),
(3, 1200000, '2025-01-12', 'pending'),
(1, 9800000, '2025-01-15', 'completed'),
(4, 4500000, '2025-01-18', 'cancelled'),
(2, 6100000, '2025-01-20', 'completed'),
(5, 2700000, '2025-01-22', 'pending'),
(3, 15000000, '2025-01-25', 'completed');

SELECT *
FROM orders
WHERE status = 'completed';

SELECT *
FROM orders
WHERE total_amount > 5000000;

SELECT *
FROM orders
ORDER BY order_date DESC
LIMIT 5;

SELECT *
FROM orders
WHERE status = 'completed'
ORDER BY total_amount DESC;
