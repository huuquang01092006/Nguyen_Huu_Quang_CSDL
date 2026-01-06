CREATE TABLE products (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    price DECIMAL(10,2)
);

CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    quantity INT
);
INSERT INTO products (id, name, price) VALUES
(1, 'Laptop Dell', 1500.00),
(2, 'iPhone 15', 1200.00),
(3, 'Samsung Galaxy S24', 1100.00),
(4, 'Tai nghe Sony', 200.00),
(5, 'Chuột Logitech', 50.00),
(6, 'Bàn phím cơ Keychron', 100.00),
(7, 'Màn hình LG 27 inch', 300.00);

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(101, 1, 2),
(102, 2, 1),
(103, 3, 3),
(104, 1, 1),
(105, 4, 5),
(106, 5, 2),
(107, 2, 1);

SELECT *
FROM products
WHERE id IN (
    SELECT product_id
    FROM order_items
);
