-- hệ thống Social Network Platform
-- Bảng người dùng
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng bài viết
CREATE TABLE Posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    content TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    likes INT DEFAULT 0,
    hashtags VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Bảng theo dõi
CREATE TABLE Follows (
    follower_id INT,
    followee_id INT,
    PRIMARY KEY (follower_id, followee_id),
    FOREIGN KEY (follower_id) REFERENCES Users(user_id),
    FOREIGN KEY (followee_id) REFERENCES Users(user_id)
);

-- Bảng lượt xem bài viết
CREATE TABLE PostViews (
    view_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    post_id INT,
    viewer_id INT,
    view_time DATETIME,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id),
    FOREIGN KEY (viewer_id) REFERENCES Users(user_id)
);
