USE social_network;

CREATE TABLE IF NOT EXISTS delete_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT,
    deleted_by INT,
    deleted_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$

CREATE PROCEDURE sp_delete_post (
    IN p_post_id INT,
    IN p_user_id INT
)
proc_block: BEGIN
    DECLARE post_owner INT DEFAULT NULL;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    SELECT user_id INTO post_owner
    FROM posts
    WHERE post_id = p_post_id;

    IF post_owner IS NULL OR post_owner <> p_user_id THEN
        ROLLBACK;
        LEAVE proc_block;
    END IF;

    DELETE FROM likes WHERE post_id = p_post_id;
    DELETE FROM comments WHERE post_id = p_post_id;
    DELETE FROM posts WHERE post_id = p_post_id;

    UPDATE users
    SET posts_count = posts_count - 1
    WHERE user_id = p_user_id;

    INSERT INTO delete_log (post_id, deleted_by)
    VALUES (p_post_id, p_user_id);

    COMMIT;
END$$

DELIMITER ;

CALL sp_delete_post(10, 1);

SELECT * FROM delete_log ORDER BY log_id DESC LIMIT 5;
SELECT * FROM posts WHERE post_id = 10;
SELECT user_id, posts_count FROM users WHERE user_id = 1;

CALL sp_delete_post(10, 2);

SELECT * FROM delete_log ORDER BY log_id DESC LIMIT 5;
SELECT * FROM posts WHERE post_id = 10;
