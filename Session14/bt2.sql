USE social_network;

CREATE TABLE IF NOT EXISTS likes (
    like_id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    CONSTRAINT fk_likes_post FOREIGN KEY (post_id) REFERENCES posts(post_id),
    CONSTRAINT fk_likes_user FOREIGN KEY (user_id) REFERENCES users(user_id),
    CONSTRAINT unique_like UNIQUE KEY (post_id, user_id)
);

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'social_network'
  AND TABLE_NAME = 'posts'
  AND COLUMN_NAME = 'likes_count';

ALTER TABLE posts ADD COLUMN likes_count INT DEFAULT 0;

INSERT INTO users (username) VALUES ('tester') ON DUPLICATE KEY UPDATE username = username;

INSERT INTO posts (user_id, content) VALUES (1, 'Bài viết để test like')
ON DUPLICATE KEY UPDATE content = content;

SELECT post_id FROM posts ORDER BY post_id DESC LIMIT 1;

SET autocommit = 0;
START TRANSACTION;

INSERT INTO likes (post_id, user_id) VALUES (1, 1);

UPDATE posts
SET likes_count = likes_count + 1
WHERE post_id = 1;

COMMIT;

SET autocommit = 0;
START TRANSACTION;

INSERT INTO likes (post_id, user_id) VALUES (1, 1);

ROLLBACK;

SELECT post_id, likes_count FROM posts WHERE post_id = 1;

SELECT * FROM likes WHERE post_id = 1 AND user_id = 1;
