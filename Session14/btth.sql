CREATE DATABASE ss14;
USE ss14;

CREATE TABLE Users (
	user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    total_posts INT DEFAULT 0
);

CREATE TABLE posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    content TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

INSERT INTO users (username, total_posts) VALUES ('nguyen_van_a', 0);

INSERT INTO users (username, total_posts) VALUES ('le_thi_b', 0);

DELIMITER //
CREATE PROCEDURE sp_create_post (
	p_user_id INT,
    p_content TEXT
)
BEGIN
	
    START TRANSACTION;
    SET AUTOCOMMIT = 0;
    
    select username into @check_user from users where user_id =p_user_id;
    
	IF (@check_user IS NULL OR TRIM(@check_user) = '  ') THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nội dung không được để trống';
        ROLLBACK;
    END IF;
    
    if not EXISTS(
		SELECT 1 from users
        WHERE user_id =p_user_id
	) THEN
    SIGNAL SQLSTATE '45000' set MESSAGE_TEXT = 'người dùng không tồn tại';
    ROLLBACK;
    END IF;
    
	INSERT INTO posts (user_id, content) VALUES
	(p_user_id, p_content);
        
	UPDATE users
	SET total_posts = total_posts + 1
	WHERE user_id = p_post_id;
	COMMIT;
		
		
END //
DELIMITER ;

CALL sp_create_post (999, 'a tung code bang chatgpt');