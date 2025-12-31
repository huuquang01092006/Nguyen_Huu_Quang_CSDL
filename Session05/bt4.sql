CREATE DATABASE session5;
USE session5;

CREATE TABLE products (
    product_id     INT AUTO_INCREMENT PRIMARY KEY,
    product_name   VARCHAR(255) NOT NULL,
    price          DECIMAL(10,2) NOT NULL,
    stock          INT NOT NULL,
    sold_quantity  INT NOT NULL,
    status         ENUM('active','inactive') NOT NULL
);

INSERT INTO products (product_name, price, stock, sold_quantity, status) VALUES
('Samsung A15', 4500000, 50, 320, 'active'),
('iPhone 13', 18000000, 20, 500, 'active'),
('Xiaomi Redmi 13', 3900000, 60, 280, 'active'),
('Oppo A18', 3200000, 40, 260, 'active'),
('Tai nghe Bluetooth', 800000, 200, 410, 'active'),
('Chuột không dây', 350000, 300, 390, 'active'),
('Bàn phím cơ', 1200000, 150, 360, 'active'),
('Loa JBL', 2500000, 80, 310, 'active'),
('Pin sạc dự phòng', 600000, 180, 420, 'active'),
('Cáp sạc Type-C', 150000, 500, 450, 'active'),
('Ốp lưng điện thoại', 200000, 400, 340, 'active'),
('Thẻ nhớ 64GB', 450000, 250, 300, 'active'),
('Webcam Full HD', 1900000, 70, 210, 'active'),
('USB 32GB', 250000, 350, 290, 'active'),
('Chuột gaming', 950000, 120, 270, 'active');

SELECT *
FROM products
ORDER BY sold_quantity DESC
LIMIT 10;

SELECT *
FROM products
ORDER BY sold_quantity DESC
LIMIT 5 OFFSET 10;

SELECT *
FROM products
WHERE price < 2000000
ORDER BY sold_quantity DESC;
