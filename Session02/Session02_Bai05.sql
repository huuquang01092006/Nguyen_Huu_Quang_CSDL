create database bai5;
use bai5;

create table students (
    student_id int primary key,
    fullname varchar(255) not null
);

create table subjects (
    subject_id int primary key,
    subject_name varchar(255) not null
);

create table scores (
    student_id int not null,
    subject_id int not null,
    process_score int not null,
    final_score int not null,

    check (process_score >= 0 and process_score <= 10),
    check (final_score >= 0 and final_score <= 10),

    foreign key (student_id) references students(student_id),
    foreign key (subject_id) references subjects(subject_id)
);
