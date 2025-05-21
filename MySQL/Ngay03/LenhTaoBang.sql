--1. **Câu Lệnh Tạo Bảng Và Thêm Dữ Liệu Vào Bảng Recruitment-Management**
-- Tạo bảng Ứng viên
CREATE TABLE Candidates (
    candidate_id INT PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    years_exp INT,
    expected_salary INT
);

-- Tạo bảng Công việc
CREATE TABLE Jobs (
    job_id INT PRIMARY KEY,
    title VARCHAR(100),
    department VARCHAR(50),
    min_salary INT,
    max_salary INT
);

-- Tạo bảng Hồ sơ ứng tuyển
CREATE TABLE Applications (
    app_id INT PRIMARY KEY,
    candidate_id INT,
    job_id INT,
    apply_date DATE,
    status VARCHAR(20),
    FOREIGN KEY (candidate_id) REFERENCES Candidates(candidate_id),
    FOREIGN KEY (job_id) REFERENCES Jobs(job_id)
);

-- Bảng ShortlistedCandidates
CREATE TABLE ShortlistedCandidates (
    candidate_id INT,
    job_id INT,
    selection_date DATE
);

--**Chèn dữ liệu vào bảng**

INSERT INTO ShortlistedCandidates (candidate_id, job_id, selection_date)
SELECT candidate_id, job_id, CURRENT_DATE()
FROM Applications
WHERE status = 'Accepted';

-- Chèn dữ liệu vào bảng Candidates
INSERT INTO Candidates (candidate_id, full_name, email, phone, years_exp, expected_salary)
VALUES
(1, 'Nguyen Van A', 'a@gmail.com', '0909000001', 0, 800),
(2, 'Le Thi B', 'b@gmail.com', NULL, 2, 1200),
(3, 'Tran Van C', 'c@gmail.com', '0909000003', 4, 1500),
(4, 'Pham Thi D', 'd@gmail.com', '0909000004', 7, 2000);

-- Chèn dữ liệu vào bảng Jobs
INSERT INTO Jobs (job_id, title, department, min_salary, max_salary)
VALUES
(1, 'Backend Developer', 'IT', 1000, 2000),
(2, 'Data Analyst', 'IT', 1200, 1800),
(3, 'Sales Executive', 'Sales', 800, 1600),
(4, 'HR Manager', 'HR', 1100, 1700);

-- Chèn dữ liệu vào bảng Applications
INSERT INTO Applications (app_id, candidate_id, job_id, apply_date, status)
VALUES
(1, 1, 1, '2025-05-01', 'Pending'),
(2, 2, 2, '2025-05-03', 'Accepted'),
(3, 3, 3, '2025-05-05', 'Rejected'),
(4, 4, 4, '2025-05-07', 'Accepted');