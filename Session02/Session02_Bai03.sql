create database bai3;
use bai3;

create table students (
    student_id int primary key,
    fullname varchar(255) not null
);

create table subjects (
    subject_id int primary key,
    subject_name varchar(255) not null,
    credits int not null,
    constraint chk_credits check (credits > 0)
);

create table enrollments (
    enrollment_id int primary key,
    student_id int not null,
    subject_id int not null,
    enrollment_date date not null,

    foreign key (student_id) references students(student_id),
    foreign key (subject_id) references subjects(subject_id),

    unique (student_id, subject_id)
);
