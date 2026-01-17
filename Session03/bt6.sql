create database bai6;
use bai6;

create table student (
	student_id int auto_increment primary key,
    full_name varchar(255) not null,
    email varchar(255) not null unique,
    date_of_birth date not null
);

create table subject (
	subject_id int auto_increment primary key,
    subject_name varchar(255) not null,
    credit int not null check (credit > 0)
);

create table enrollment (
	student_id int not null,
    subject_id int not null,
    enroll_date date not null,
    unique (student_id, subject_id),
    foreign key (student_id) references student(student_id),
    foreign key (subject_id) references subject(subject_id)
);

create table score (
	student_id int not null,
    subject_id int not null,
    mid_score decimal(4,1) not null check (mid_score >= 0 and mid_score <= 10),
    final_score decimal(4,1) not null check (final_score >= 0 and final_score <= 10),
    unique (student_id, subject_id),
    foreign key (student_id) references student(student_id),
    foreign key (subject_id) references subject(subject_id)
);

insert into student (full_name, email, date_of_birth) values
("Nguyen Van A", "a@gmail.com", '2005-01-01'),
("Nguyen Van B", "b@gmail.com", '2005-02-02'),
("Nguyen Van C", "c@gmail.com", '2005-03-03');

insert into subject (subject_name, credit) values
("Database Systems", 3),
("Data Structures", 4),
("Operating Systems", 3);

insert into enrollment (student_id, subject_id, enroll_date) values
(1, 1, '2025-09-01'),
(1, 2, '2025-09-01'),
(2, 1, '2025-09-02'),
(2, 3, '2025-09-02');

insert into score (student_id, subject_id, mid_score, final_score) values
(1, 1, 7.0, 8.0),
(1, 2, 6.5, 7.0),
(2, 1, 8.0, 9.0),
(2, 3, 7.0, 8.0);

insert into student (full_name, email, date_of_birth) values
("Nguyen Van D", "d@gmail.com", '2005-04-04');

insert into enrollment (student_id, subject_id, enroll_date) values
(4, 1, '2025-09-05'),
(4, 2, '2025-09-05');

insert into score (student_id, subject_id, mid_score, final_score) values
(4, 1, 6.5, 7.5),
(4, 2, 7.0, 8.0);

update score
set final_score = 8.5
where student_id = 4 and subject_id = 1;

delete from enrollment
where student_id = 4 and subject_id = 2;

select
	s.student_id,
    s.full_name,
    sub.subject_name,
    sc.mid_score,
    sc.final_score
from student s
join score sc on s.student_id = sc.student_id
join subject sub on sc.subject_id = sub.subject_id;
