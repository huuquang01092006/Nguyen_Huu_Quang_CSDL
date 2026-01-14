CREATE TABLE post_history (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    post_id INT,
    old_content TEXT,
    new_content TEXT,
    changed_at DATETIME,
    changed_by_user_id INT,
    FOREIGN KEY (post_id) REFERENCES posts(post_id) ON DELETE CASCADE
);
DELIMITER $$

CREATE TRIGGER log_post_update
BEFORE UPDATE ON posts
FOR EACH ROW
BEGIN
    IF OLD.content <> NEW.content THEN
        INSERT INTO post_history (post_id, old_content, new_content, changed_at, changed_by_user_id)
        VALUES (OLD.post_id, OLD.content, NEW.content, NOW(), OLD.user_id);
    END IF;
END$$

DELIMITER ;
DELIMITER $$

CREATE TRIGGER log_post_delete
AFTER DELETE ON posts
FOR EACH ROW
BEGIN
    INSERT INTO post_history (post_id, old_content, new_content, changed_at, changed_by_user_id)
    VALUES (OLD.post_id, OLD.content, NULL, NOW(), OLD.user_id);
END$$

DELIMITER ;
UPDATE posts
SET content = 'Hello world from Alice! (edited)'
WHERE post_id = 1;

SELECT * FROM post_history;
