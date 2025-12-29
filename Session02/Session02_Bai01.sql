create database bai1;
use bai1;

create table classes(
	class_id int primary key,
    class_name varchar(255) not null,
    academic_year varchar(9) not null
);

create table students(
	student_id int primary key,
    fullname varchar(255) not null,
    date_of_birth date not null,
    class_id int not null,
    FOREIGN KEY (class_id) REFERENCES classes(class_id)
);