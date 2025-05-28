-- 1. Tận dụng bộ nhớ đệm (Caching):

-- tạo bảng MEMORY TABLE để lưu cache vì dữ liệu không thay đổi liên tục
CREATE TABLE CachedTopPostsToday (
    post_id INT PRIMARY KEY,
    user_id INT,
    likes INT,
    created_at DATETIME
) ENGINE=MEMORY;
-- sau đó cập nhập bảng cache - dùng TRUNCATE
TRUNCATE TABLE CachedTopPostsToday;

INSERT INTO CachedTopPostsToday (post_id, user_id, likes, created_at)
SELECT post_id, user_id, likes, created_at
FROM Posts
WHERE DATE(created_at) = CURDATE()
ORDER BY likes DESC
LIMIT 10;
-- lấy ra 10 bài viết lượt thích cao nhất từ bảng cache
SELECT * FROM CachedTopPostsToday;

-- 2. Sử dụng EXPLAIN ANALYZE (MySQL 8.0+):
mysql -u root -p
--
USE mysql_social_network_platform;
EXPLAIN ANALYZE
SELECT * FROM Posts
WHERE hashtags LIKE '%fitness%'
ORDER BY created_at DESC
LIMIT 20;

-- 3.Phân vùng bảng PostViews:

-- tạo thêm bảng PostViews_partitioned
CREATE TABLE PostViews_partitioned  (
    view_id BIGINT NOT NULL,
    post_id INT NOT NULL,
    viewer_id INT NOT NULL,
    view_time DATETIME NOT NULL,
    PRIMARY KEY (view_id, view_time)
)
-- thiết lập partition theo tháng của bảng 
PARTITION BY RANGE (TO_DAYS(view_time)) (
    PARTITION p202412 VALUES LESS THAN (TO_DAYS('2025-01-01')), 
    PARTITION p202501 VALUES LESS THAN (TO_DAYS('2025-02-01')), 
    PARTITION p202502 VALUES LESS THAN (TO_DAYS('2025-03-01')), 
    PARTITION p202503 VALUES LESS THAN (TO_DAYS('2025-04-01')), 
    PARTITION p202504 VALUES LESS THAN (TO_DAYS('2025-05-01')), 
    PARTITION p202505 VALUES LESS THAN (TO_DAYS('2025-06-01')), 
    PARTITION pmax VALUES LESS THAN MAXVALUE 
);

-- di chuyển từ bảng cũ sang bảng phân vùng
INSERT INTO PostViews_partitioned (view_id, post_id, viewer_id, view_time)
SELECT view_id, post_id, viewer_id	, view_time FROM PostViews;
-- kiểm tra lại xem đã sử dụng partition chưa
EXPLAIN SELECT DATE_FORMAT(view_time, '%Y-%m') AS thang_nam, COUNT(*) AS tong_luot_xem 
FROM postviews_partitioned 
WHERE view_time >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH) 
GROUP BY thang_nam;
--truy vấn thống kê lượt xem theo tháng (6 tháng gần nhất)
SELECT
  DATE_FORMAT(view_time, '%Y-%m') AS thang_nam,
  COUNT(*) AS tong_luot_xem
FROM postviews_partitioned
WHERE view_time >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY thang_nam
ORDER BY thang_nam DESC;

-- 4. Chuẩn hóa & Phi chuẩn hóa:

-- 4.1 chuẩn hóa hashtags

-- tạo bảng hashtag chứa hashtag riêng
CREATE TABLE Hashtags (
    hashtag_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);
-- tạo bảng postHastags bảng trung gian liên kết post và hastags
CREATE TABLE PostHashtags (
    post_id INT NOT NULL,
    hashtag_id INT NOT NULL,
    PRIMARY KEY (post_id, hashtag_id),
    FOREIGN KEY (post_id) REFERENCES posts(post_id),
    FOREIGN KEY (hashtag_id) REFERENCES Hashtags(hashtag_id)
);
-- chuyển hastags từ post sang 2 bảng

INSERT IGNORE INTO Hashtags(name) VALUES ('fitness'), ('health');

INSERT INTO PostHashtags(post_id, hashtag_id)
SELECT 1, hashtag_id FROM Hashtags WHERE name IN ('fitness', 'health');
-- sau khi chuyển dữ liệu có thể xóa trường hastags bảng post
ALTER TABLE Posts DROP COLUMN hashtags;

-- 4.2 phi chuẩn hóa lượt xem theo ngày - PopularPostsDaily 
-- tạo bảng PopularPostsDaily để lưu sẵn thống kê mỗi ngày giúp truy vấn nhanh
CREATE TABLE PopularPostsDaily (
    post_id INT NOT NULL,
    view_date DATE NOT NULL,
    total_views INT DEFAULT 0,
    PRIMARY KEY (post_id, view_date),
    FOREIGN KEY (post_id) REFERENCES Posts(post_id)
);
-- chèn dữ liệu vào bảng mỗi ngày 
INSERT INTO PopularPostsDaily (post_id, view_date, total_views)
SELECT 
    post_id,
    DATE(view_time) AS view_date,
    COUNT(*) AS total_views
FROM PostViews
WHERE view_time >= CURDATE() - INTERVAL 1 DAY
GROUP BY post_id, view_date
ON DUPLICATE KEY UPDATE total_views = VALUES(total_views);

-- truy vấn test từ bảng chuẩn hóa - top 5 bài viết mỗi ngày trong 7 ngày
SELECT post_id, view_date, total_views
FROM PopularPostsDaily
WHERE view_date >= CURDATE() - INTERVAL 7 DAY
ORDER BY view_date DESC, total_views DESC
LIMIT 5;

--6 Sử dụng Window Functions thay vòng lặp thủ công:
-- Tính tổng số view mỗi bài viết và xếp hạng (RANK) theo số view mỗi ngày (view_time).
SELECT 
  post_id,
  DATE(view_time) AS ngay,
  COUNT(*) AS tong_luot_xem,
  RANK() OVER (PARTITION BY DATE(view_time) ORDER BY COUNT(*) DESC) AS xep_hang
FROM postviews
GROUP BY post_id, ngay;

-- Truy vấn top 3 bài viết mỗi ngày.
SELECT *
FROM (
  SELECT 
    post_id,
    DATE(view_time) AS ngay,
    COUNT(*) AS tong_luot_xem,
    RANK() OVER (PARTITION BY DATE(view_time) ORDER BY COUNT(*) DESC) AS xep_hang
  FROM postviews_partitioned
  GROUP BY post_id, ngay
) AS ranked
WHERE xep_hang <= 3;
-- 7. Tối ưu transaction ngắn gọn:
CREATE TABLE post_likes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  post_id INT NOT NULL,
  user_id INT NOT NULL,
  liked_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY unique_like (post_id, user_id),
  FOREIGN KEY (post_id) REFERENCES posts(post_id),
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);
-- transaction cập nhật like
DELIMITER //
CREATE PROCEDURE sp_like_post(
  IN p_post_id INT,
  IN p_user_id INT
)
BEGIN
  DECLARE already_liked INT DEFAULT 0;
  -- Kiểm tra user đã like chưa
  SELECT COUNT(*) INTO already_liked
  FROM post_likes
  WHERE post_id = p_post_id AND user_id = p_user_id;
  IF already_liked = 0 THEN
    -- chưa like, thực hiện cập nhật trong transaction
    START TRANSACTION
    -- thêm bản ghi like
    INSERT INTO post_likes(post_id, user_id) VALUES (p_post_id, p_user_id);
    -- cập nhật số likes trong bảng posts
    UPDATE posts SET likes = likes + 1 WHERE post_id = p_post_id;

    COMMIT;
  END IF;
END //
DELIMITER ;

-- 8. Kiểm tra Slow Query Log:
slow_query_log = 1 
slow_query_log_file = "C:/laragon/data/mysql/slow_queries.log"
long_query_time = 1
log_queries_not_using_indexes = 1

-- truy vấn test 
SELECT * FROM posts WHERE content LIKE '%suy ngẫm%';

--9. Sử dụng OPTIMIZER_TRACE để debug sâu:
USE mysql_social_network_platform;

SET optimizer_trace = 'enabled=on', optimizer_trace_limit = 1;


SELECT u.username, p.content 
FROM users u 
JOIN posts p ON u.user_id = p.user_id 
WHERE p.created_at >= '2025-01-01'
ORDER BY p.created_at DESC;

-- Lấy trace:
SELECT * FROM INFORMATION_SCHEMA.OPTIMIZER_TRACE;
