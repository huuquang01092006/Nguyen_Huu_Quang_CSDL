CREATE DATABASE OnlineLearning;
USE OnlineLearning;

CREATE TABLE Student (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    birth_date DATE,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone varchar (11) unique
);


CREATE TABLE Teacher (
    teacher_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(100) UNIQUE
);

CREATE TABLE Course (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(150) NOT NULL,
    description TEXT,
    sessions INT CHECK (sessions > 0),
    teacher_id INT,
    CONSTRAINT fk_course_teacher FOREIGN KEY (teacher_id) REFERENCES teacher(teacher_id)
);

CREATE TABLE Enrollment (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enroll_date DATE NOT NULL,
    CONSTRAINT fk_enroll_student FOREIGN KEY (student_id) REFERENCES Student(student_id),
    CONSTRAINT fk_enroll_course FOREIGN KEY (course_id) REFERENCES Course(course_id),
    CONSTRAINT uq_enrollment UNIQUE (student_id, course_id)
);

CREATE TABLE score (
    score_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    midterm DECIMAL(3,1) CHECK (midterm BETWEEN 0 AND 10),
    final DECIMAL(3,1) CHECK (final BETWEEN 0 AND 10),
    CONSTRAINT fk_score_student FOREIGN KEY (student_id) REFERENCES Student(student_id),
    CONSTRAINT fk_score_course FOREIGN KEY (course_id) REFERENCES Course(course_id),
    CONSTRAINT uq_score UNIQUE (student_id, course_id)
);
CREATE TABLE Result (
    student_id INT,
    course_id INT,
    midterm_score DECIMAL(4,2) CHECK (midterm_score BETWEEN 0 AND 10),
    final_score DECIMAL(4,2) CHECK (final_score BETWEEN 0 AND 10),
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES Student(student_id)
);

INSERT INTO Student (full_name, birth_date, email) VALUES
('Nguyen Van A', '2000-01-01', 'a@example.com'),
('Tran Thi B', '2001-02-02', 'b@example.com'),
('Le Van C', '2002-03-03', 'c@example.com'),
('Pham Thi D', '2003-04-04', 'd@example.com'),
('Hoang Van E', '2004-05-05', 'e@example.com');

INSERT INTO teacher (full_name, email) VALUES
('Thay Nguyen', 'nguyen@school.com'),
('Co Tran', 'tran@school.com'),
('Thay Le', 'le@school.com'),
('Co Pham', 'pham@school.com'),
('Thay Hoang', 'hoang@school.com');

INSERT INTO Course (course_name, description, sessions, teacher_id) VALUES
('Lập trình C', 'Khóa học cơ bản về C', 20, 1),
('Cơ sở dữ liệu', 'Khóa học SQL và thiết kế CSDL', 25, 2),
('Java cơ bản', 'Khóa học nhập môn Java', 30, 3),
('MySQL nâng cao', 'Khóa học quản trị MySQL', 15, 4),
('Python cơ bản', 'Khóa học nhập môn Python', 20, 5);

INSERT INTO Enrollment (student_id, course_id, enroll_date) VALUES
(1, 1, '2024-09-15'),
(2, 2, '2024-09-16'),
(3, 3, '2024-09-17'),
(4, 4, '2024-09-18'),
(5, 5, '2024-09-19');

INSERT INTO score (student_id, course_id, midterm, final) VALUES
(1, 1, 8.5, 9.0),
(2, 2, 7.0, 8.0),
(3, 3, 6.5, 7.5),
(4, 4, 9.0, 9.5),
(5, 5, 8.0, 8.5);

UPDATE Student SET email = 'new_a@example.com' WHERE student_id = 1;

UPDATE Course SET description = 'Khóa học C cơ bản cho người mới bắt đầu' WHERE course_id = 1;

UPDATE score SET final = 9.8 WHERE student_id = 1 AND course_id = 1;

DELETE FROM Enrollment WHERE student_id = 1 AND course_id = 1;

DELETE FROM score WHERE student_id = 1 AND course_id = 1;

SELECT * FROM Student;

SELECT * FROM teacher;

SELECT * FROM Course;

SELECT * FROM Enrollment;

SELECT * FROM score;
