create database Social_network;
use Social_network;

CREATE TABLE Posts (
    post_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Comments (
    comment_id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Friends (
    user_id INT NOT NULL,
    friend_id INT NOT NULL,
    status VARCHAR(20) CHECK (status IN ('pending','accepted')),
    PRIMARY KEY (user_id, friend_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (friend_id) REFERENCES Users(user_id)
);

CREATE TABLE Likes (
    user_id INT NOT NULL,
    post_id INT NOT NULL,
    PRIMARY KEY (user_id, post_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (post_id) REFERENCES Posts(post_id)
);


/* =====================================================
   BAI 1 – TAO BANG USERS + THEM & HIEN THI USER
===================================================== */
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Users(username, password, email)
VALUES ('an123', '123456', 'an@gmail.com');

SELECT * FROM Users;


/* =====================================================
   BAI 2 – VIEW THONG TIN CONG KHAI
===================================================== */
CREATE VIEW vw_public_users AS
SELECT user_id, username, created_at
FROM Users;

SELECT * FROM vw_public_users;


/* =====================================================
   BAI 3 – INDEX TIM KIEM USER
===================================================== */
CREATE INDEX idx_users_username ON Users(username);

SELECT * FROM Users WHERE username = 'an123';


/* =====================================================
   BAI 4 – PROCEDURE DANG BAI VIET
===================================================== */
CREATE TABLE Posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

DELIMITER //

CREATE PROCEDURE sp_create_post(
    IN p_user_id INT,
    IN p_content TEXT
)
BEGIN
    IF EXISTS (SELECT 1 FROM Users WHERE user_id = p_user_id) THEN
        INSERT INTO Posts(user_id, content)
        VALUES (p_user_id, p_content);
    ELSE
        SELECT 'User khong ton tai' AS message;
    END IF;
END//

DELIMITER ;

CALL sp_create_post(1, 'Hello SQL');


/* =====================================================
   BAI 5 – VIEW NEWS FEED
===================================================== */
CREATE VIEW vw_recent_posts AS
SELECT *
FROM Posts
WHERE created_at >= NOW() - INTERVAL 7 DAY;

SELECT * FROM vw_recent_posts;


/* =====================================================
   BAI 6 – TOI UU TRUY VAN BAI VIET
===================================================== */
CREATE INDEX idx_posts_user ON Posts(user_id);
CREATE INDEX idx_posts_user_date ON Posts(user_id, created_at);

SELECT *
FROM Posts
WHERE user_id = 1
ORDER BY created_at DESC;


/* =====================================================
   BAI 7 – THONG KE BAI VIET
===================================================== */
DELIMITER //

CREATE PROCEDURE sp_count_posts(
    IN p_user_id INT,
    OUT p_total INT
)
BEGIN
    SELECT COUNT(*) INTO p_total
    FROM Posts
    WHERE user_id = p_user_id;
END//

DELIMITER ;

CALL sp_count_posts(1, @total);
SELECT @total;


/* =====================================================
   BAI 8 – VIEW WITH CHECK OPTION
===================================================== */
CREATE VIEW vw_active_users AS
SELECT *
FROM Users
WHERE created_at IS NOT NULL
WITH CHECK OPTION;


/* =====================================================
   BAI 9 – KET BAN
===================================================== */
CREATE TABLE Friends (
    user_id INT,
    friend_id INT,
    status VARCHAR(20) CHECK (status IN ('pending','accepted')),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (friend_id) REFERENCES Users(user_id)
);

DELIMITER //

CREATE PROCEDURE sp_add_friend(
    IN p_user_id INT,
    IN p_friend_id INT
)
BEGIN
    IF p_user_id = p_friend_id THEN
        SELECT 'Khong the ket ban voi chinh minh' AS message;
    ELSE
        INSERT INTO Friends(user_id, friend_id, status)
        VALUES (p_user_id, p_friend_id, 'pending');
    END IF;
END//

DELIMITER ;


/* =====================================================
   BAI 10 – GOI Y BAN BE
===================================================== */
DELIMITER //

CREATE PROCEDURE sp_suggest_friends(
    IN p_user_id INT,
    INOUT p_limit INT
)
BEGIN
    SELECT user_id, username
    FROM Users
    WHERE user_id <> p_user_id
    LIMIT p_limit;
END//

DELIMITER ;


/* =====================================================
   BAI 11 – TOP BAI VIET
===================================================== */
CREATE TABLE Likes (
    user_id INT,
    post_id INT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (post_id) REFERENCES Posts(post_id)
);

CREATE INDEX idx_likes_post ON Likes(post_id);

CREATE VIEW vw_top_posts AS
SELECT post_id, COUNT(*) AS total_likes
FROM Likes
GROUP BY post_id
ORDER BY total_likes DESC
LIMIT 5;


/* =====================================================
   BAI 12 – BINH LUAN
===================================================== */
CREATE TABLE Comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT,
    user_id INT,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

DELIMITER //

CREATE PROCEDURE sp_add_comment(
    IN p_user_id INT,
    IN p_post_id INT,
    IN p_content TEXT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Users WHERE user_id = p_user_id) THEN
        SELECT 'User khong ton tai' AS message;
    ELSEIF NOT EXISTS (SELECT 1 FROM Posts WHERE post_id = p_post_id) THEN
        SELECT 'Post khong ton tai' AS message;
    ELSE
        INSERT INTO Comments(user_id, post_id, content)
        VALUES (p_user_id, p_post_id, p_content);
    END IF;
END//

DELIMITER ;

CREATE VIEW vw_post_comments AS
SELECT c.content, u.username, c.created_at
FROM Comments c
JOIN Users u ON c.user_id = u.user_id;


/* =====================================================
   BAI 13 – LUOT THICH
===================================================== */
DELIMITER //

CREATE PROCEDURE sp_like_post(
    IN p_user_id INT,
    IN p_post_id INT
)
BEGIN
    IF EXISTS (
        SELECT 1 FROM Likes
        WHERE user_id = p_user_id AND post_id = p_post_id
    ) THEN
        SELECT 'Da like truoc do' AS message;
    ELSE
        INSERT INTO Likes(user_id, post_id)
        VALUES (p_user_id, p_post_id);
    END IF;
END//

DELIMITER ;

CREATE VIEW vw_post_likes AS
SELECT post_id, COUNT(*) AS total_likes
FROM Likes
GROUP BY post_id;


/* =====================================================
   BAI 14 – TIM KIEM USER & BAI VIET
===================================================== */
DELIMITER //

CREATE PROCEDURE sp_search_social(
    IN p_option INT,
    IN p_keyword VARCHAR(100)
)
BEGIN
    IF p_option = 1 THEN
        SELECT user_id, username
        FROM Users
        WHERE username LIKE CONCAT('%', p_keyword, '%');

    ELSEIF p_option = 2 THEN
        SELECT post_id, content
        FROM Posts
        WHERE content LIKE CONCAT('%', p_keyword, '%');

    ELSE
        SELECT 'Lua chon khong hop le' AS message;
    END IF;
END//

DELIMITER ;

CALL sp_search_social(1, 'an');
CALL sp_search_social(2, 'database');