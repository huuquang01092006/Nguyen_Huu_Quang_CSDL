DROP DATABASE IF EXISTS session5;
CREATE DATABASE session5;
USE session5;

CREATE TABLE products (
    product_id   INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    price        DECIMAL(10,2) NOT NULL,
    stock        INT NOT NULL,
    status       ENUM('active','inactive') NOT NULL
);

INSERT INTO products (product_name, price, stock, status) VALUES
('Điện thoại Samsung A15', 4500000, 20, 'active'),
('Laptop Dell Inspiron', 15000000, 10, 'active'),
('Tai nghe Bluetooth', 800000, 50, 'active'),
('Chuột không dây', 350000, 100, 'active'),
('Bàn phím cơ', 1200000, 30, 'inactive'),
('iPhone 13', 18000000, 5, 'active'),
('Loa Bluetooth JBL', 2500000, 15, 'inactive');

SELECT *
FROM products;

SELECT *
FROM products
WHERE status = 'active';

SELECT *
FROM products
WHERE price > 1000000;

SELECT *
FROM products
WHERE status = 'active'
ORDER BY price ASC;
