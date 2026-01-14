DELIMITER $$

CREATE TRIGGER prevent_self_like
BEFORE INSERT ON likes
FOR EACH ROW
BEGIN
    DECLARE post_owner INT;
    SELECT user_id INTO post_owner FROM posts WHERE post_id = NEW.post_id;
    
    IF NEW.user_id = post_owner THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'User cannot like their own post';
    END IF;
END$$

DELIMITER ;
DELIMITER $$

CREATE TRIGGER increase_like_count
AFTER INSERT ON likes
FOR EACH ROW
BEGIN
    UPDATE posts
    SET like_count = like_count + 1
    WHERE post_id = NEW.post_id;
END$$

DELIMITER ;
DELIMITER $$

CREATE TRIGGER decrease_like_count
AFTER DELETE ON likes
FOR EACH ROW
BEGIN
    UPDATE posts
    SET like_count = like_count - 1
    WHERE post_id = OLD.post_id;
END$$

DELIMITER ;
DELIMITER $$

CREATE TRIGGER update_like_count
AFTER UPDATE ON likes
FOR EACH ROW
BEGIN
    UPDATE posts
    SET like_count = like_count - 1
    WHERE post_id = OLD.post_id;

    UPDATE posts
    SET like_count = like_count + 1
    WHERE post_id = NEW.post_id;
END$$

DELIMITER ;
