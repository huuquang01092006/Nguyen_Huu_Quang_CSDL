CREATE DATABASE IF NOT EXISTS social_network;
USE social_network;

CREATE TABLE IF NOT EXISTS users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    posts_count INT DEFAULT 0
);

CREATE TABLE IF NOT EXISTS posts (
    post_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

INSERT INTO users (username) VALUES ('nguyen'), ('linh'), ('anh');
START TRANSACTION;

INSERT INTO posts (user_id, content) VALUES (1, 'Bài viết đầu tiên của tôi');

UPDATE users
SET posts_count = posts_count + 1
WHERE user_id = 1;

COMMIT;

START TRANSACTION;

INSERT INTO posts (user_id, content) VALUES (999, 'Bài viết lỗi');

UPDATE users
SET posts_count = posts_count + 1
WHERE user_id = 999;

ROLLBACK;

SELECT * FROM users;
SELECT * FROM posts;
