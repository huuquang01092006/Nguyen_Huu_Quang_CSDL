USE session03;

DROP TABLE IF EXISTS Subject;

CREATE TABLE Subject (
    subject_id INT PRIMARY KEY,
    subject_name VARCHAR(100) NOT NULL,
    credit INT NOT NULL,
    CHECK (credit > 0)
);

INSERT INTO Subject (subject_id, subject_name, credit)
VALUES
(1, 'Cơ sở dữ liệu', 3),
(2, 'Lập trình C', 4),
(3, 'Mạng máy tính', 3),
(4, 'Hệ điều hành', 3);

SELECT *FROM Subject;
UPDATE Subject
SET credit = 5
WHERE subject_id = 2;

UPDATE Subject
SET subject_name = 'Mạng máy tính cơ bản'
WHERE subject_id = 3;

SELECT * FROM Subject;

SELECT subject_id, subject_name, credit
FROM Subject
WHERE credit >= 4;
