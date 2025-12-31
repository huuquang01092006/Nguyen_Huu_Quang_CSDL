CREATE DATABASE session5;
USE session5;

CREATE TABLE products (
    product_id    INT AUTO_INCREMENT PRIMARY KEY,
    product_name  VARCHAR(255) NOT NULL,
    price         DECIMAL(10,2) NOT NULL,
    status        ENUM('active','inactive') NOT NULL
);

INSERT INTO products (product_name, price, status) VALUES
('Tai nghe Bluetooth', 800000, 'active'),
('Chuột không dây', 350000, 'active'),
('Bàn phím cơ', 1200000, 'active'),
('Loa Bluetooth', 2500000, 'active'),
('Pin sạc dự phòng', 600000, 'active'),
('Cáp sạc Type-C', 150000, 'active'),
('Webcam Full HD', 1900000, 'active'),
('USB 32GB', 250000, 'active'),
('Ổ cứng SSD 256GB', 2300000, 'active'),
('Thẻ nhớ 64GB', 450000, 'inactive'),
('Tai nghe Gaming', 1800000, 'active'),
('Chuột Gaming', 950000, 'active'),
('Bàn phím Bluetooth', 2700000, 'active'),
('Loa mini', 1100000, 'active'),
('Webcam HD', 1600000, 'active'),
('Ổ cứng HDD 1TB', 2900000, 'active'),
('Chuột văn phòng', 400000, 'inactive'),
('Tai nghe chụp tai', 2100000, 'active'),
('Bàn phím văn phòng', 1300000, 'active'),
('Loa để bàn', 3000000, 'active'),
('Pin sạc nhanh', 1700000, 'active'),
('Cáp HDMI', 500000, 'active');

SELECT *
FROM products
WHERE status = 'active'
  AND price BETWEEN 1000000 AND 3000000
ORDER BY price ASC
LIMIT 10 OFFSET 0;

SELECT *
FROM products
WHERE status = 'active'
  AND price BETWEEN 1000000 AND 3000000
ORDER BY price ASC
LIMIT 10 OFFSET 10;
