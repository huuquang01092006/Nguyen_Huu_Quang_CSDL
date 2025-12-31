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
(1, 1200000, '2025-01-01', 'pending'),
(2, 5200000, '2025-01-02', 'completed'),
(3, 800000,  '2025-01-03', 'cancelled'),
(4, 2400000, '2025-01-04', 'pending'),
(5, 15000000,'2025-01-05', 'completed'),
(1, 3200000, '2025-01-06', 'pending'),
(2, 7800000, '2025-01-07', 'completed'),
(3, 4100000, '2025-01-08', 'pending'),
(4, 9900000, '2025-01-09', 'completed'),
(5, 2100000, '2025-01-10', 'cancelled'),
(1, 6700000, '2025-01-11', 'completed'),
(2, 1300000, '2025-01-12', 'pending'),
(3, 5600000, '2025-01-13', 'completed'),
(4, 1900000, '2025-01-14', 'pending'),
(5, 2500000, '2025-01-15', 'completed'),
(1, 8800000, '2025-01-16', 'pending'),
(2, 3400000, '2025-01-17', 'completed'),
(3, 920000,  '2025-01-18', 'pending');

SELECT *
FROM orders
WHERE status <> 'cancelled'
ORDER BY order_date DESC
LIMIT 5 OFFSET 0;

SELECT *
FROM orders
WHERE status <> 'cancelled'
ORDER BY order_date DESC
LIMIT 5 OFFSET 5;

SELECT *
FROM orders
WHERE status <> 'cancelled'
ORDER BY order_date DESC
LIMIT 5 OFFSET 10;
