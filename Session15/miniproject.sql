CREATE DATABASE social_network;
USE social_network;

CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Posts (
    post_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

CREATE TABLE Comments (
    comment_id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT,
    user_id INT,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

CREATE TABLE Likes (
    user_id INT,
    post_id INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(user_id, post_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id) ON DELETE CASCADE
);

CREATE TABLE Friends (
    user_id INT,
    friend_id INT,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'accepted')),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(user_id, friend_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (friend_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

CREATE TABLE user_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    action VARCHAR(50),
    log_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE PROCEDURE sp_register_user(
    IN p_username VARCHAR(50),
    IN p_password VARCHAR(255),
    IN p_email VARCHAR(100)
)
BEGIN
    IF EXISTS (SELECT 1 FROM Users WHERE username = p_username) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Username đã tồn tại';
    END IF;
    IF EXISTS (SELECT 1 FROM Users WHERE email = p_email) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Email đã tồn tại';
    END IF;
    INSERT INTO Users(username, password, email)
    VALUES(p_username, p_password, p_email);
END //
DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_user_register
AFTER INSERT ON Users
FOR EACH ROW
BEGIN
    INSERT INTO user_log(user_id, action)
    VALUES (NEW.user_id, 'register');
END$$

DELIMITER ;


CREATE TABLE post_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT,
    user_id INT,
    action VARCHAR(50),
    log_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE PROCEDURE sp_create_post(
    IN p_user_id INT,
    IN p_content TEXT
)
BEGIN
    IF p_content IS NULL OR p_content = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nội dung không được rỗng';
    END IF;
    INSERT INTO Posts(user_id, content)
    VALUES(p_user_id, p_content);
END //
DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_post_create
AFTER INSERT ON Posts
FOR EACH ROW
BEGIN
    INSERT INTO post_log(post_id, user_id, action)
    VALUES(NEW.post_id, NEW.user_id, 'create_post');
END$$

DELIMITER ;

ALTER TABLE Posts ADD like_count INT DEFAULT 0;

DELIMITER $$

CREATE TRIGGER trg_like_insert
AFTER INSERT ON Likes
FOR EACH ROW
BEGIN
    UPDATE Posts SET like_count = like_count + 1
    WHERE post_id = NEW.post_id;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_like_delete
AFTER DELETE ON Likes
FOR EACH ROW
BEGIN
    UPDATE Posts SET like_count = like_count - 1
    WHERE post_id = OLD.post_id;
END$$

DELIMITER ;

CREATE TABLE friend_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    friend_id INT,
    action VARCHAR(50),
    log_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE PROCEDURE sp_send_friend_request(
    IN p_sender_id INT,
    IN p_receiver_id INT
)
BEGIN
    IF p_sender_id = p_receiver_id THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Không thể tự gửi lời mời';
    END IF;
    IF EXISTS (SELECT 1 FROM Friends 
               WHERE user_id = p_sender_id AND friend_id = p_receiver_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lời mời đã tồn tại';
    END IF;
    INSERT INTO Friends(user_id, friend_id, status)
    VALUES(p_sender_id, p_receiver_id, 'pending');
END //
DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_friend_request
AFTER INSERT ON Friends
FOR EACH ROW
BEGIN
    INSERT INTO friend_log(user_id, friend_id, action)
    VALUES(NEW.user_id, NEW.friend_id, 'send_request');
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER trg_friend_accept
AFTER UPDATE ON Friends
FOR EACH ROW
BEGIN
    IF NEW.status = 'accepted' THEN
        INSERT IGNORE INTO Friends(user_id, friend_id, status)
        VALUES(NEW.friend_id, NEW.user_id, 'accepted');
    END IF;
END $$

DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_update_friendship(
    IN p_user_id INT,
    IN p_friend_id INT,
    IN p_action VARCHAR(20)
)
BEGIN
    START TRANSACTION;
    IF p_action = 'delete' THEN
        DELETE FROM Friends WHERE user_id = p_user_id AND friend_id = p_friend_id;
        DELETE FROM Friends WHERE user_id = p_friend_id AND friend_id = p_user_id;
    ELSE
        UPDATE Friends SET status = p_action
        WHERE user_id = p_user_id AND friend_id = p_friend_id;
        UPDATE Friends SET status = p_action
        WHERE user_id = p_friend_id AND friend_id = p_user_id;
    END IF;
    COMMIT;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_delete_post(
    IN p_post_id INT,
    IN p_user_id INT
)
BEGIN
    DECLARE v_owner INT;
    SELECT user_id INTO v_owner FROM Posts WHERE post_id = p_post_id;
    IF v_owner <> p_user_id THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Không có quyền xóa bài viết';
    END IF;
    START TRANSACTION;
        DELETE FROM Likes WHERE post_id = p_post_id;
        DELETE FROM Comments WHERE post_id = p_post_id;
        DELETE FROM Posts WHERE post_id = p_post_id;
    COMMIT;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_delete_user(
    IN p_user_id INT
)
BEGIN
    START TRANSACTION;
        DELETE FROM Likes WHERE user_id = p_user_id;
        DELETE FROM Comments WHERE user_id = p_user_id;
        DELETE FROM Friends WHERE user_id = p_user_id OR friend_id = p_user_id;
        DELETE FROM Posts WHERE user_id = p_user_id;
        DELETE FROM Users WHERE user_id = p_user_id;
    COMMIT;
END //
DELIMITER ;
