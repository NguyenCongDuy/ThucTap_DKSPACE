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

-- thêm dữ liệu vào bảng 

INSERT INTO Students (full_name, email)
VALUES 
('Nguyễn Văn A', 'nguyenvana@gmail.com'),
('Trần Thị B', 'tranthib@yahoo.com'),
('Lê Văn C', 'levanc@gmail.com');

INSERT INTO Courses (title, description, price)
VALUES 
('Lập trình PHP cơ bản', 'Khóa học dành cho người mới bắt đầu học PHP', 1000000),
('MySQL nâng cao', 'Khóa học giúp làm chủ MySQL với ví dụ thực tế', 1500000),
('HTML & CSS', 'Xây dựng giao diện website đẹp và chuẩn responsive', 500000);

INSERT INTO Enrollments (student_id, course_id)
VALUES 
(1, 1), -- Nguyễn Văn A học Lập trình PHP cơ bản
(2, 2), -- Trần Thị B học MySQL nâng cao
(1, 3), -- Nguyễn Văn A học thêm HTML & CSS
(3, 1); -- Lê Văn C học Lập trình PHP cơ bản