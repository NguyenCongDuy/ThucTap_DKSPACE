--**Câu Truy Vấn Thực Hàng Với Bảng**

--1. Tìm các ứng viên đã từng ứng tuyển vào ít nhất một công việc thuộc phòng ban "IT"

-- lấy tất cả thông tin ứng viên
SELECT *
FROM candidates c -- từ bảng ứng viên bí danh c
WHERE EXISTS (
    -- kiểm tra có tồn tại một bản ghi ứng tuyển trong phòng ban IT
    SELECT 1 -- trả về 1 nếu có bản ghi
    FROM Applications a -- từ bảng Applications bí danh a
    JOIN Jobs j ON a.job_id = j.job_id -- Nối với bảng Jobs dựa trên job_id
    WHERE a.candidate_id = c.candidate_id -- Kiểm tra ứng viên này có nộp đơn hay không
      AND j.department = 'IT' -- Và công việc đó thuộc phòng ban IT
);

--2. Liệt kê các công việc mà mức lương tối đa lớn hơn mức lương mong đợi của bất kỳ ứng viên nào.

SELECT *
-- Lấy tất cả dữ liều từ jobs
FROM jobs
-- kiểm tra mức lương tối đa lớn hơn mức lương mong đợi
WHERE max_salary > ANY (
    -- lấy mức lương mong đợi của tất cả ứng viên
    SELECT expected_salary
    FROM Candidates
);

--3. Liệt kê các công việc mà mức lương tối thiểu lớn hơn mức lương mong đợi của tất cả ứng viên.

SELECT *
FROM Jobs
-- mức lương tối thiểu phải cao hơn tất cả mức mong đợi của ứng viên
WHERE min_salary > ALL (
    -- lấy mức lương mong đợi của tất cả ứng viên
    SELECT expected_salary
    FROM Candidates
);

--4. Chèn vào một bảng ShortlistedCandidates những ứng viên có trạng thái ứng tuyển là 'Accepted'.
INSERT INTO ShortlistedCandidates (candidate_id, job_id, selection_date)
SELECT candidate_id, job_id, CURRENT_DATE()
FROM Applications
WHERE status = 'Accepted';

--5. Hiển thị danh sách ứng viên, kèm theo đánh giá mức kinh nghiệm theo điều kiện 

SELECT 
    full_name,
    years_exp,
    CASE
        WHEN years_exp < 1 THEN 'Fresher' -- -- Dưới 1 năm: Fresher
        WHEN years_exp BETWEEN 1 AND 3 THEN 'Junior'  -- Từ 1 đến 3 năm: Junior
        WHEN years_exp BETWEEN 4 AND 6 THEN 'Mid-level' -- Từ 4 đến 6 năm: Mid-level
        ELSE 'Senior'
    END AS Cap_Do_Kinh_Nghiem -- đặt tên cho cột mới
FROM Candidates;

--6. Ứng viên với số điện thoại có thể NULL, thay bằng Chưa cung cấp (COALESCE)

-- 
SELECT 
    full_name,
    COALESCE(phone, 'Chưa cung cấp') AS phone
    -- nếu không có số điện thoại thì thay bằng 'Chưa cung cấp'
FROM Candidates;

--7. Tìm các công việc có mức lương tối đa không bằng mức lương tối thiểu và mức lương tối đa lớn hơn hoặc bằng 1000.

-- Lấy tất cả các công việc từ bảng Jobs
SELECT *
FROM Jobs
-- kiểm tra mức lương không bằng nhau
WHERE max_salary != min_salary 
-- kiểm tra mức lương tối đa lớn hơn hoặc bằng 1000
AND max_salary >= 1000;