USE session03;

DROP TABLE IF EXISTS Enrollment;

CREATE TABLE Enrollment (
    student_id INT NOT NULL,
    subject_id INT NOT NULL,
    enroll_date DATE NOT NULL,

    PRIMARY KEY (student_id, subject_id),

    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (subject_id) REFERENCES Subject(subject_id)
);

INSERT INTO Enrollment (student_id, subject_id, enroll_date)
VALUES
(1, 1, '2025-12-29'),
(1, 2, '2025-12-29'),
(2, 1, '2025-12-29'),
(2, 3, '2025-12-29');

SELECT *
FROM Enrollment;

SELECT *
FROM Enrollment
WHERE student_id = 1;
