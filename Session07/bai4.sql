CREATE TABLE customers (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE orders (
    id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2)
);
INSERT INTO customers (id, name, email) VALUES
(1, 'Nguyen Van A', 'a@example.com'),
(2, 'Tran Thi B', 'b@example.com'),
(3, 'Le Van C', 'c@example.com'),
(4, 'Pham Thi D', 'd@example.com'),
(5, 'Hoang Van E', 'e@example.com');

INSERT INTO orders (id, customer_id, order_date, total_amount) VALUES
(101, 1, '2025-01-01', 500000),
(102, 2, '2025-01-02', 300000),
(103, 1, '2025-01-03', 450000),
(104, 3, '2025-01-04', 700000),
(105, 2, '2025-01-05', 250000);

SELECT 
    name,
    (SELECT COUNT(*) 
     FROM orders 
     WHERE orders.customer_id = customers.id) AS order_count
FROM customers;
