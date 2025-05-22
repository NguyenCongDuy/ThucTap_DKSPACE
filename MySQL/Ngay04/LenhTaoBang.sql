--1. **Câu Lệnh Tạo Bảng Và Thêm Dữ Liệu Vào Bảng Recruitment-Management**


-- tạo cơ sở dữ liệu 
CREATE DATABASE Mysql_OnlineLearning
-- sử dụng cơ sở dữ liệu
USE Mysql_OnlineLearning;

-- tạo bảng stutdent 

CREATE TABLE Students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    join_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- tạo bảng courses

CREATE TABLE Courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    price INT CHECK (price >= 0)
);

-- tạo bảng Enrollments

CREATE TABLE Enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    course_id INT,
    enroll_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

-- xóa cơ sở dữ liệu nếu như không cần dùng nữa
DROP DATABASE Mysql_OnlineLearning