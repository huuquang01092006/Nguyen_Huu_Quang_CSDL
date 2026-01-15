USE social_network;

CREATE TABLE IF NOT EXISTS comments (
    comment_id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_comments_post FOREIGN KEY (post_id) REFERENCES posts(post_id),
    CONSTRAINT fk_comments_user FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE IF NOT EXISTS comment_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT,
    user_id INT,
    error_message VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$

CREATE PROCEDURE sp_post_comment (
    IN p_post_id INT,
    IN p_user_id INT,
    IN p_content TEXT
)
proc_block: BEGIN
    DECLARE post_exists INT DEFAULT 0;
    DECLARE user_exists INT DEFAULT 0;

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        INSERT INTO comment_log (post_id, user_id, error_message)
        VALUES (p_post_id, p_user_id, 'Lỗi khi cập nhật comments_count, rollback về SAVEPOINT');
        ROLLBACK TO after_insert;
        COMMIT;
    END;

    START TRANSACTION;

    SELECT COUNT(*) INTO post_exists FROM posts WHERE post_id = p_post_id;
    SELECT COUNT(*) INTO user_exists FROM users WHERE user_id = p_user_id;

    IF post_exists = 0 OR user_exists = 0 THEN
        INSERT INTO comment_log (post_id, user_id, error_message)
        VALUES (p_post_id, p_user_id, 'Post hoặc User không tồn tại');
        ROLLBACK;
        LEAVE proc_block;
    END IF;

    INSERT INTO comments (post_id, user_id, content)
    VALUES (p_post_id, p_user_id, p_content);

    SAVEPOINT after_insert;

    IF p_content = 'CAUSE_UPDATE_ERROR' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Forced update error for testing';
    END IF;

    UPDATE posts
    SET comments_count = comments_count + 1
    WHERE post_id = p_post_id;

    COMMIT;
END$$

DELIMITER ;

INSERT INTO users (username) VALUES ('cmt_user') ON DUPLICATE KEY UPDATE username = username;

INSERT INTO posts (user_id, content) VALUES (1, 'Post để test comment')
ON DUPLICATE KEY UPDATE content = content;

CALL sp_post_comment(1, 1, 'Bình luận hợp lệ');

SELECT post_id, comments_count FROM posts WHERE post_id = 1;
SELECT * FROM comments WHERE post_id = 1 ORDER BY comment_id DESC LIMIT 5;
SELECT * FROM comment_log ORDER BY log_id DESC LIMIT 5;

CALL sp_post_comment(1, 1, 'CAUSE_UPDATE_ERROR');

SELECT post_id, comments_count FROM posts WHERE post_id = 1;
SELECT * FROM comments WHERE post_id = 1 ORDER BY comment_id DESC LIMIT 5;
SELECT * FROM comment_log ORDER BY log_id DESC LIMIT 5;
