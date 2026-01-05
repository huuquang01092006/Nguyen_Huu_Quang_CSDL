
USE session6;

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS products;

CREATE TABLE products (
  product_id   INT PRIMARY KEY,
  product_name VARCHAR(255) NOT NULL,
  price        DECIMAL(10,2) NOT NULL CHECK (price >= 0)
);

CREATE TABLE order_items (
  order_id   INT NOT NULL,
  product_id INT NOT NULL,
  quantity   INT NOT NULL CHECK (quantity > 0),
  PRIMARY KEY (order_id, product_id),
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO products (product_id, product_name, price) VALUES
(1, 'iPhone 14',        18000000.00),
(2, 'Samsung A55',       9000000.00),
(3, 'Xiaomi Redmi 13',   4500000.00),
(4, 'AirPods 2',         2500000.00),
(5, 'Sac nhanh 20W',      350000.00);

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(101, 1, 1),
(101, 4, 2),
(102, 2, 1),
(104, 3, 2),
(104, 5, 3),
(105, 1, 1),
(105, 5, 2);


SELECT
  p.product_id,
  p.product_name,
  SUM(oi.quantity) AS total_quantity_sold
FROM products p
JOIN order_items oi ON oi.product_id = p.product_id
JOIN orders o ON o.order_id = oi.order_id
WHERE o.status = 'completed'
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity_sold DESC;


SELECT
  p.product_id,
  p.product_name,
  SUM(oi.quantity) AS total_quantity_sold,
  SUM(oi.quantity * p.price) AS total_revenue
FROM products p
JOIN order_items oi ON oi.product_id = p.product_id
JOIN orders o ON o.order_id = oi.order_id
WHERE o.status = 'completed'
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue DESC;



SELECT
  p.product_id,
  p.product_name,
  SUM(oi.quantity) AS total_quantity_sold,
  SUM(oi.quantity * p.price) AS total_revenue
FROM products p
JOIN order_items oi ON oi.product_id = p.product_id
JOIN orders o ON o.order_id = oi.order_id
WHERE o.status = 'completed'
GROUP BY p.product_id, p.product_name
HAVING SUM(oi.quantity * p.price) > 5000000
ORDER BY total_revenue DESC;
