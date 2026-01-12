create database SocialLab;

create table posts(
	post_id INT Primary Key auto_increment,
	content TEXT,
	author VARCHAR(255),
	likes_count INT Default 0
)

delimiter //
create procedure sp_CreatePost (
	in pro_content TEXT,
    in pro_author varchar(255),
    OUT last_id int
)
begin
	insert into add_posts(content, author) values
	(pro_content, pro_author);
    
    set last_id = last_insert_id();
end //
delimiter ;

call sp_CreatePost('tung an healthy', 'nguyen thanh tung', @new_post_id);
select @new_post_id;

DELIMITER $$

CREATE PROCEDURE sp_SearchPost(
    IN p_keyword VARCHAR(255)
)
BEGIN
    SELECT post_id, content, author, likes_count
    FROM posts
    WHERE content LIKE CONCAT('%', p_keyword, '%');
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE sp_IncreaseLike(
    IN p_post_id INT,
    INOUT p_likes INT
)
BEGIN
    UPDATE posts
    SET likes_count = likes_count + 1
    WHERE post_id = p_post_id;

    -- Trả về số Like mới
    SELECT likes_count INTO p_likes
    FROM posts
    WHERE post_id = p_post_id;
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE sp_DeletePost(
    IN p_post_id INT
)
BEGIN
    DELETE FROM posts
    WHERE post_id = p_post_id;
END $$

DELIMITER ;

CALL sp_CreatePost('Hello world!', 'Alice', @id1);
SELECT @id1;

CALL sp_CreatePost('Another hello post', 'Bob', @id2);
SELECT @id2;

CALL sp_SearchPost('hello');

-- Giả sử tăng Like cho bài viết @id1
SET @likes = 0;
CALL sp_IncreaseLike(@id1, @likes);
SELECT @likes;  -- Xem số Like mới
