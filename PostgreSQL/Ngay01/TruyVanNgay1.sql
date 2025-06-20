1. Tạo bảng: 

- Bảng khách hàng

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

- Bảng giao dịch

CREATE TABLE transactions (
    transaction_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id),
    amount DECIMAL(12,2),
    type VARCHAR(20) CHECK (type IN ('DEPOSIT', 'WITHDRAW')),
    transaction_date TIMESTAMP
);

1.2 Tạo index để tối ưu truy vấn

CREATE INDEX idx_customer_id ON transactions(customer_id);
CREATE INDEX idx_transaction_date ON transactions(transaction_date);

2. Truy vấn dữ liệu với SELECT, WHERE, AND, OR, NOT:
2.1. Lấy khách hàng Gmail, tạo sau 1/1/2024:

SELECT * FROM customers
WHERE email LIKE '%@gmail.com'
AND created_at > '2024-01-01';

2.2. Giao dịch > 1000 hoặc 'WITHDRAW' nhưng không trong tháng 3/2025:

SELECT * FROM transactions
WHERE (amount > 1000 OR type = 'WITHDRAW')
AND NOT (EXTRACT(MONTH FROM transaction_date) = 3 AND EXTRACT(YEAR FROM transaction_date) = 2025);

3. Sắp xếp và phân trang với ORDER BY, LIMIT, OFFSET:
3.1  Lấy 10 khách hàng đầu tiên, theo created_at giảm dần

SELECT * FROM customers
ORDER BY created_at DESC
LIMIT 10;

3.2  Lấy 10 giao dịch từ bản ghi thứ 21, theo amount tăng dần

SELECT * FROM transactions
ORDER BY amount ASC
LIMIT 10 OFFSET 20;

4. Thêm, sửa, xóa dữ liệu với INSERT INTO, UPDATE, DELETE:
4.1 Thêm khách hàng mới

INSERT INTO customers (full_name, email, phone, created_at)
VALUES ('Hoang Minh G', 'hoangg_test@gmail.com', '0938123456', NOW());

4.2 Cập nhật số điện thoại cho customer_id = 2

UPDATE customers
SET phone = '0988888888'
WHERE customer_id = 2;

4.3 Xoá các giao dịch có amount < 100 và loại là 'DEPOSIT'

DELETE FROM transactions
WHERE amount < 100 AND type = 'DEPOSIT';

5. Xử lý giá trị NULL:

5.1 Tìm khách hàng có phone là NULL hoặc email KHÔNG NULL

SELECT * FROM customers
WHERE phone IS NULL OR email IS NOT NULL;

5.2 Đếm số giao dịch có transaction_date là NULL

SELECT COUNT(*) FROM transactions
WHERE transaction_date IS NULL;

6. Hàm tổng hợp MIN, MAX, COUNT, AVG, SUM:
6.1 Tổng số giao dịch, trung bình tiền, và tiền lớn nhất

SELECT 
  COUNT(*) AS total_transactions,
  AVG(amount) AS avg_amount,
  MAX(amount) AS max_amount
FROM transactions;

6.2 Tìm MIN và MAX amount của mỗi khách hàng

SELECT 
  customer_id,
  MIN(amount) AS min_amount,
  MAX(amount) AS max_amount
FROM transactions
GROUP BY customer_id;


7. Tìm kiếm chuỗi với LIKE, ILIKE, Wildcards:
7.1  Tìm khách hàng có tên bắt đầu bằng 'Nguyen' (không phân biệt hoa thường)

SELECT * FROM customers
WHERE full_name ILIKE 'Nguyen%';

7.2  Tìm khách hàng có email chứa _test% 

SELECT * FROM customers
WHERE email LIKE '%\_test%%' ESCAPE '\';


8. Loại bỏ trùng lặp với DISTINCT:
8.1 Lấy các loại giao dịch duy nhất

SELECT DISTINCT type FROM transactions;

8.2 Lấy danh sách email khách hàng không trùng

SELECT DISTINCT email FROM customers;


