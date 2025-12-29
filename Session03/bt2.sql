USE session03;

UPDATE Student
SET email = 'updated1@gmail.com'
WHERE student_id = 1;

UPDATE Student
SET email = 'updated3@gmail.com'
WHERE student_id = 3;

UPDATE Student
SET date_of_birth = '2002-12-31'
WHERE student_id = 4;

UPDATE Student
SET date_of_birth = '2001-09-15'
WHERE student_id = 2;

DELETE FROM Student
WHERE student_id = 6;

DELETE FROM Student
WHERE student_id = 5;

SELECT *
FROM Student;
