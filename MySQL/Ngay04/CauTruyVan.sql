--1. Thêm cột status vào bảng Enrollments với giá trị mặc định là 'active'.
-- Sử dụng ALTER TABLE + DEFAULT.
ALTER TABLE Enrollments
ADD COLUMN status VARCHAR(20) DEFAULT 'active';

--2. Xóa bảng Enrollments nếu không còn cần nữa.
-- Sử dụng DROP TABLE.
DROP TABLE Enrollments;

--3. Tạo một VIEW tên là StudentCourseView hiển thị danh sách sinh viên và tên khóa học họ đã đăng ký.
-- Sử dụng CREATE VIEW.

CREATE VIEW StudentCourseView AS
SELECT s.student_id, s.full_name, c.course_id, c.title
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
JOIN Courses c ON e.course_id = c.course_id;

--4. Tạo một chỉ mục (INDEX) trên cột title của bảng Courses để tối ưu tìm kiếm.
--Sử dụng CREATE INDEX.

CREATE INDEX idx_course_title ON Courses(title);
