create database bai4;
use bai4;

create table teachers (
    teacher_id int primary key,
    fullname varchar(255) not null,
    email varchar(255)
);

create table subjects (
    subject_id int primary key,
    subject_name varchar(255) not null
);

alter table subjects
add teacher_id int;

alter table subjects
add foreign key (teacher_id) references teachers(teacher_id);
