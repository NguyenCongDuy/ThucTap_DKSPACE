-- 1. Quản lý cơ sở dữ liệu:
-- Tạo database mới có tên banking_system
CREATE DATABASE banking_system;

-- Xóa database banking_system
DROP DATABASE IF EXISTS banking_system;

-- 2.Quản lý bảng:
--  Tạo bảng customers
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY, 
    full_name VARCHAR(100) NOT NULL, 
    email VARCHAR(100) UNIQUE NOT NULL, 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
--  Tạo bảng accounts   
CREATE TABLE accounts (
    account_id SERIAL PRIMARY KEY, 
    customer_id INT REFERENCES customers(customer_id), 
    balance DECIMAL(12, 2) CHECK (balance >= 0), 
    account_type VARCHAR(20) CHECK (account_type IN ('SAVINGS', 'CHECKING')),
    opened_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
);
--  Tạo bảng transactions
CREATE TABLE transactions (
    transaction_id SERIAL PRIMARY KEY, 
    account_id INT REFERENCES accounts(account_id), 
    amount DECIMAL(12, 2) CHECK (amount > 0), 
    description JSONB,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
);

-- Thêm cột phone vào customers
ALTER TABLE customers
ADD COLUMN phone VARCHAR(20);

-- Sửa kiểu dữ liệu account_type
ALTER TABLE accounts
ALTER COLUMN account_type TYPE VARCHAR(20);

-- Xóa cột description, thêm cột note
ALTER TABLE transactions
DROP COLUMN description;

ALTER TABLE transactions
ADD COLUMN note TEXT;


-- Xóa bảng transactions
DROP TABLE IF EXISTS transactions;

 -- 3. Áp dụng Constraints:
 -- 4.Sử dụng DEFAULT và SERIAL:
 -- 5 Quản lý Index:

-- Tạo index trên email để tìm kiếm nhanh
CREATE INDEX idx_customers_email ON customers(email);

-- Tạo index trên transaction_date để tối ưu truy vấn theo thời gian
CREATE INDEX idx_transactions_date ON transactions(transaction_date);

-- Xóa index trên email
DROP INDEX IF EXISTS idx_customers_email;

-- 6. Kiểu dữ liệu
-- truy vấn để chèn một bản ghi vào transactions với dữ liệu description dạng JSONB.
INSERT INTO transactions (account_id, amount, description)
VALUES (
    1,
    2500,
    '{"type": "TRANSFER", "recipient": "John Doe"}'::jsonb
);

-- 7. Tạo và quản lý Views:

--  Tạo view customer_account_summary
CREATE VIEW customer_account_summary AS
SELECT
    c.full_name,
    c.email,
    a.account_id,
    a.balance
FROM
    customers c
JOIN
    accounts a ON c.customer_id = a.customer_id;

-- Truy vấn từ view (lọc theo balance > 1000)

SELECT *
FROM customer_account_summary
WHERE balance > 1000;

-- Xóa view 
DROP VIEW IF EXISTS customer_account_summary;


-- thêm dữ liệu 
INSERT INTO customers (full_name, email)
VALUES 
('Nguyễn Văn A', 'a@example.com'),
('Trần Thị B', 'b@example.com'),
('Lê Văn C', 'c@example.com');

INSERT INTO accounts (customer_id, balance, account_type)
VALUES 
(1, 5000000.00, 'SAVINGS'),
(1, 2000000.00, 'CHECKING'),
(2, 10000000.00, 'SAVINGS'),
(3, 1500000.00, 'CHECKING');

INSERT INTO transactions (account_id, amount, description)
VALUES 
(1, 1000000.00, '{"type": "deposit", "note": "Nạp tiền ATM"}'),
(1, 500000.00, '{"type": "withdrawal", "note": "Rút tiền quầy giao dịch"}'),
(2, 200000.00, '{"type": "transfer", "note": "Chuyển khoản tới người thân"}'),
(3, 3000000.00, '{"type": "deposit", "note": "Lương tháng 6"}'),
(4, 100000.00, '{"type": "withdrawal", "note": "Rút tiền ATM"}');


