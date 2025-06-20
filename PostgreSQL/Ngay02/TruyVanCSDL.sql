-- 1. Tạo cấu trúc bảng:

-- Bảng Khách hàng
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100),
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT NOW()
);

-- Bảng Tài khoản
CREATE TABLE accounts (
    account_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    balance DECIMAL(15,2),
    account_type VARCHAR(20) CHECK (account_type IN ('SAVINGS', 'CHECKING'))
);

-- Bảng Giao dịch
CREATE TABLE transactions (
    transaction_id SERIAL PRIMARY KEY,
    account_id INT REFERENCES accounts(account_id),
    amount DECIMAL(15,2),
    type VARCHAR(20) CHECK (type IN ('DEPOSIT', 'WITHDRAW', 'TRANSFER')),
    transaction_date TIMESTAMP DEFAULT NOW()
);

-- Tạo index để tối ưu

CREATE INDEX idx_customer_id ON accounts(customer_id);
CREATE INDEX idx_account_id ON transactions(account_id);
CREATE INDEX idx_transaction_date ON transactions(transaction_date);

-- 2. Sử dụng IN và BETWEEN 
-- 2.1 Giao dịch có type nằm trong ('DEPOSIT', 'TRANSFER') và amount trong khoảng 500–5000
SELECT * 
FROM transactions
WHERE type IN ('DEPOSIT', 'TRANSFER')
AND amount BETWEEN 500 AND 5000
-- 2.2 Khách hàng có created_at nằm trong khoảng từ 1/1/2024 đến 31/12/2024
SELECT * 
FROM customers
WHERE created_at BETWEEN '2024-01-01' AND '2024-12-31';
-- 3. Sử dụng Aliases (AS)
-- 3.1 Lấy full_name (biệt danh là customer_name) và balance (alias account_balance)
SELECT 
    c.full_name AS customer_name, 
    a.balance AS account_balance
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id;
-- 3.2 Tính tổng amount theo account_id (biệt danh total_transaction
SELECT 
    account_id, 
    SUM(amount) AS total_transaction
FROM transactions
GROUP BY account_id;
-- 4. Sử dụng các loại JOIN
-- 4.1  Lấy danh sách giao dịch kèm thông tin tài khoản và khách hàng
SELECT 
    t.transaction_id,
    t.amount,
    t.type,
    t.transaction_date,
    a.account_id,
    a.account_type,
    c.full_name
FROM transactions t
INNER JOIN accounts a ON t.account_id = a.account_id
INNER JOIN customers c ON a.customer_id = c.customer_id;
-- 4.2 Liệt kê tất cả khách hàng và thông tin tài khoản của họ (bao gồm cả người chưa có tài khoản)
SELECT 
    c.customer_id,
    c.full_name,
    a.account_id,
    a.account_type,
    a.balance
FROM customers c
LEFT JOIN accounts a ON c.customer_id = a.customer_id;
-- 4.3 Liệt kê tất cả tài khoản và thông tin khách hàng (bao gồm cả tài khoản không có chủ)
SELECT 
    c.customer_id,
    c.full_name,
    a.account_id,
    a.account_type,
    a.balance
FROM customers c
RIGHT JOIN accounts a ON c.customer_id = a.customer_id;
-- 4.4 Liệt kê tất cả khách hàng và tài khoản, kể cả không khớp
SELECT 
    c.customer_id,
    c.full_name,
    a.account_id,
    a.account_type,
    a.balance
FROM customers c
FULL OUTER JOIN accounts a ON c.customer_id = a.customer_id;
-- 5. Sử dụng CROSS JOIN và Self Join
-- 5.1 Tạo tất cả các cặp account_id và loại transaction type
SELECT 
    a.account_id,
    t.type AS transaction_type
FROM accounts a
CROSS JOIN (
    SELECT DISTINCT type FROM transactions
) t;
-- 5.2  Tìm các giao dịch cùng account_id, khác transaction_id và cùng một ngày
SELECT 
    t1.transaction_id AS transaction_1,
    t2.transaction_id AS transaction_2,
    t1.account_id,
    t1.transaction_date::date AS date
FROM transactions t1
JOIN transactions t2 
    ON t1.account_id = t2.account_id
    AND t1.transaction_id <> t2.transaction_id
    AND t1.transaction_date::date = t2.transaction_date::date
ORDER BY t1.account_id, t1.transaction_date;
-- 6. Sử dụng UNION và UNION ALL
-- 6.1 Kết hợp full_name và account_type
SELECT full_name AS info FROM customers
UNION
SELECT account_type FROM accounts;
-- 6.2 Kết hợp các giao dịch DEPOSIT và WITHDRAW
SELECT * FROM transactions WHERE type = 'DEPOSIT'
UNION ALL
SELECT * FROM transactions WHERE type = 'WITHDRAW';
-- 7. Sử dụng GROUP BY và HAVING
-- 7.1 Tính tổng amount giao dịch theo account_id và type, chỉ hiển thị nhóm có tổng amount > 10,000
SELECT 
    account_id, 
    type, 
    SUM(amount) AS total_amount
FROM 
    transactions
GROUP BY 
    account_id, type
HAVING 
    SUM(amount) > 10000;
-- 7.2 Đếm số giao dịch theo customer_id, chỉ hiển thị các khách hàng có từ 5 giao dịch trở lên
SELECT 
    a.customer_id, 
    COUNT(t.transaction_id) AS total_transactions
FROM 
    accounts a
JOIN 
    transactions t ON a.account_id = t.account_id
GROUP BY 
    a.customer_id
HAVING 
    COUNT(t.transaction_id) >= 5;
-- 8. Sử dụng Subqueries
-- 8.1 Lấy danh sách tài khoản có balance lớn hơn mức trung bình balance của tất cả tài khoản
SELECT 
    account_id, 
    customer_id, 
    balance
FROM 
    accounts
WHERE 
    balance > (
        SELECT 
            AVG(balance) 
        FROM 
            accounts
    );
-- 8.2 Hiển thị full_name và tổng amount giao dịch của mỗi khách hàng
SELECT 
    c.full_name,
    (
        SELECT 
            SUM(t.amount)
        FROM 
            accounts a
        JOIN 
            transactions t ON a.account_id = t.account_id
        WHERE 
            a.customer_id = c.customer_id
    ) AS total_transaction_amount
FROM 
    customers c;


