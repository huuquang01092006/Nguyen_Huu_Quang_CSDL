DROP DATABASE IF EXISTS session5;
CREATE DATABASE session5;
USE session5;

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name   VARCHAR(255) NOT NULL,
    email       VARCHAR(255) UNIQUE NOT NULL,
    city        VARCHAR(255) NOT NULL,
    status      ENUM('active','inactive') NOT NULL
);

INSERT INTO customers (full_name, email, city, status) VALUES
('Nguyễn Văn An', 'an@gmail.com', 'TP.HCM', 'active'),
('Trần Thị Bình', 'binh@gmail.com', 'Hà Nội', 'active'),
('Lê Văn Cường', 'cuong@gmail.com', 'Đà Nẵng', 'inactive'),
('Phạm Thị Dung', 'dung@gmail.com', 'TP.HCM', 'active'),
('Hoàng Văn Em', 'em@gmail.com', 'Hà Nội', 'inactive'),
('Võ Thị Hạnh', 'hanh@gmail.com', 'Hà Nội', 'active');

SELECT *
FROM customers;

SELECT *
FROM customers
WHERE city = 'TP.HCM';

SELECT *
FROM customers
WHERE status = 'active'
  AND city = 'Hà Nội';

SELECT *
FROM customers
ORDER BY full_name ASC;
