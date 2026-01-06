CREATE TABLE orders (
    id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2)
);
INSERT INTO orders (id, customer_id, order_date, total_amount) VALUES
(1, 101, '2025-01-01', 500000),
(2, 102, '2025-01-02', 300000),
(3, 103, '2025-01-03', 450000),
(4, 104, '2025-01-04', 700000),
(5, 105, '2025-01-05', 250000),
(6, 101, '2025-01-06', 350000),
(7, 102, '2025-01-07', 400000);
SELECT customer_id, SUM(total_amount) AS total_spent
FROM orders
GROUP BY customer_id
HAVING SUM(total_amount) > (
    SELECT AVG(total_sum)
    FROM (
        SELECT SUM(total_amount) AS total_sum
        FROM orders
        GROUP BY customer_id
    ) AS sub
);
