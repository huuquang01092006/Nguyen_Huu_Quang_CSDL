create database bai2;
use bai2;

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
