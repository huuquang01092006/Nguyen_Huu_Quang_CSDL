DELIMITER $$

CREATE PROCEDURE add_user(
    IN p_username VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_created_at DATE
)
BEGIN
    INSERT INTO users (username, email, created_at)
    VALUES (p_username, p_email, p_created_at);
END$$

DELIMITER ;
DELIMITER $$

CREATE TRIGGER validate_user_before_insert
BEFORE INSERT ON users
FOR EACH ROW
BEGIN
    IF NEW.email NOT LIKE '%@%' OR NEW.email NOT LIKE '%.%' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid email format. Must contain @ and .';
    END IF;

    IF NEW.username REGEXP '^[A-Za-z0-9_]+$' = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid username. Only letters, numbers, and underscore allowed';
    END IF;
END$$

DELIMITER ;
CALL add_user('alice_test', 'alice_test@example.com', '2026-01-14');
CALL add_user('bob_test', 'bobexamplecom', '2026-01-14');
CALL add_user('charlie!@#', 'charlie@example.com', '2026-01-14');
SELECT * FROM users;
