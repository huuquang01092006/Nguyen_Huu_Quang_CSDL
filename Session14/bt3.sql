USE social_network;

CREATE TABLE IF NOT EXISTS followers (
    follower_id INT NOT NULL,
    followed_id INT NOT NULL,
    PRIMARY KEY (follower_id, followed_id),
    CONSTRAINT fk_follower FOREIGN KEY (follower_id) REFERENCES users(user_id),
    CONSTRAINT fk_followed FOREIGN KEY (followed_id) REFERENCES users(user_id)
);

ALTER TABLE users ADD COLUMN following_count INT DEFAULT 0;
ALTER TABLE users ADD COLUMN followers_count INT DEFAULT 0;

CREATE TABLE IF NOT EXISTS follow_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    follower_id INT,
    followed_id INT,
    error_message VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$

CREATE PROCEDURE sp_follow_user (
    IN p_follower_id INT,
    IN p_followed_id INT
)
proc_block: BEGIN
    DECLARE follower_exists INT;
    DECLARE followed_exists INT;
    DECLARE already_followed INT;

    START TRANSACTION;

    SELECT COUNT(*) INTO follower_exists FROM users WHERE user_id = p_follower_id;
    SELECT COUNT(*) INTO followed_exists FROM users WHERE user_id = p_followed_id;

    IF follower_exists = 0 OR followed_exists = 0 THEN
        INSERT INTO follow_log (follower_id, followed_id, error_message)
        VALUES (p_follower_id, p_followed_id, 'User không tồn tại');
        ROLLBACK;
        LEAVE proc_block;
    END IF;

    IF p_follower_id = p_followed_id THEN
        INSERT INTO follow_log (follower_id, followed_id, error_message)
        VALUES (p_follower_id, p_followed_id, 'Không thể tự follow chính mình');
        ROLLBACK;
        LEAVE proc_block;
    END IF;

    SELECT COUNT(*) INTO already_followed
    FROM followers
    WHERE follower_id = p_follower_id AND followed_id = p_followed_id;

    IF already_followed > 0 THEN
        INSERT INTO follow_log (follower_id, followed_id, error_message)
        VALUES (p_follower_id, p_followed_id, 'Đã follow trước đó');
        ROLLBACK;
        LEAVE proc_block;
    END IF;

    INSERT INTO followers (follower_id, followed_id)
    VALUES (p_follower_id, p_followed_id);

    UPDATE users
    SET following_count = following_count + 1
    WHERE user_id = p_follower_id;

    UPDATE users
    SET followers_count = followers_count + 1
    WHERE user_id = p_followed_id;

    COMMIT;
END$$

DELIMITER ;

CALL sp_follow_user(1, 2);
SELECT * FROM followers;
SELECT user_id, following_count, followers_count FROM users WHERE user_id IN (1,2);
