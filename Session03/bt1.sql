CREATE DATABASE session03;
USE session03;

CREATE TABLE Student (
    student_id CHAR(10) PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    date_of_birth DATE,
    email VARCHAR(150) UNIQUE
);

INSERT INTO Student (student_id, full_name, date_of_birth, email)
VALUES
('SV001', 'Nguyễn Văn An', '2002-05-10', 'an.nguyen@gmail.com'),
('SV002', 'Trần Thị Bình', '2001-08-22', 'binh.tran@gmail.com'),
('SV003', 'Lê Văn Cường', '2003-01-15', 'cuong.le@gmail.com');

SELECT *
FROM Student;

SELECT student_id, full_name
FROM Student;
