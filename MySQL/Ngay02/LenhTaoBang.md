1. **Câu Lệnh Tạo Bảng User Và Thêm Dữ Liệu Vào Bảng**
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    city VARCHAR(50),
    referrer_id INT NULL,
    created_at DATE NOT NULL,
    FOREIGN KEY (referrer_id) REFERENCES Users(user_id)
);

INSERT INTO Users (user_id, full_name, city, referrer_id, created_at) VALUES
(1, 'Nguyen Van A', 'Hanoi', NULL, '2023-01-01'),
(2, 'Tran Thi B', 'HCM', 1, '2023-01-10'),
(3, 'Le Van C', 'Hanoi', 1, '2023-01-12'),
(4, 'Do Thi D', 'Da Nang', 2, '2023-02-05'),
(5, 'Hoang E', 'Can Tho', NULL, '2023-02-10');

2. **Câu Lệnh Tạo Bảng Products Và Thêm Dữ Liệu Vào Bảng**
CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price INT NOT NULL,
    is_active TINYINT(1) NOT NULL DEFAULT 1
);

INSERT INTO Products (product_id, product_name, category, price, is_active) VALUES
(1, 'iPhone 13', 'Electronics', 20000000, 1),
(2, 'MacBook Air', 'Electronics', 28000000, 1),
(3, 'Coffee Beans', 'Grocery', 250000, 1),
(4, 'Book: SQL Basics', 'Books', 150000, 1),
(5, 'Xbox Controller', 'Gaming', 1200000, 0);

3. **Câu Lệnh Tạo Bảng Orders Và Thêm Dữ Liệu Vào Bảng**
CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    order_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

INSERT INTO Orders (order_id, user_id, order_date, status) VALUES
(1001, 1, '2023-02-01', 'completed'),
(1002, 2, '2023-02-10', 'cancelled'),
(1003, 3, '2023-02-12', 'completed'),
(1004, 4, '2023-02-15', 'completed'),
(1005, 1, '2023-03-01', 'pending');
4. **Câu Lệnh Tạo Bảng OrderItems Và Thêm Dữ Liệu Vào Bảng**
CREATE TABLE OrderItems (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

INSERT INTO OrderItems (order_id, product_id, quantity) VALUES
(1001, 1, 1),
(1001, 3, 3),
(1003, 2, 1),
(1003, 4, 2),
(1004, 3, 5),
(1005, 2, 1);