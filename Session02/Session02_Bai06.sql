create database bai6;
use bai6;

create table classes (
    class_id int primary key,
    class_name varchar(255) not null,
    academic_year varchar(9) not null
);

create table students (
    student_id int primary key,
    fullname varchar(255) not null,
    date_of_birth date not null,
    class_id int not null,
    foreign key (class_id) references classes(class_id)
);

create table teachers (
    teacher_id int primary key,
    fullname varchar(255) not null,
    email varchar(255)
);

create table subjects (
    subject_id int primary key,
    subject_name varchar(255) not null,
    credits int not null,
    teacher_id int not null,
    check (credits > 0),
    foreign key (teacher_id) references teachers(teacher_id)
);

create table enrollments (
    student_id int not null,
    subject_id int not null,
    enrollment_date date not null,
    foreign key (student_id) references students(student_id),
    foreign key (subject_id) references subjects(subject_id)
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