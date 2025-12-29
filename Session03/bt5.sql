USE session03;

DROP TABLE IF EXISTS Score;

CREATE TABLE Score (
    student_id INT NOT NULL,
    subject_id INT NOT NULL,
    mid_score DECIMAL(4,2) NOT NULL,
    final_score DECIMAL(4,2) NOT NULL,

    PRIMARY KEY (student_id, subject_id),

    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (subject_id) REFERENCES Subject(subject_id),

    CHECK (mid_score >= 0 AND mid_score <= 10),
    CHECK (final_score >= 0 AND final_score <= 10)
);

INSERT INTO Score (student_id, subject_id, mid_score, final_score)
VALUES
(1, 1, 7.50, 8.00),
(1, 2, 6.50, 7.00),
(2, 1, 8.00, 9.00),
(2, 3, 7.00, 8.50);

UPDATE Score
SET final_score = 8.75
WHERE student_id = 1 AND subject_id = 2;

SELECT *
FROM Score;

SELECT student_id, subject_id, mid_score, final_score
FROM Score
WHERE final_score >= 8;
