    -- tạo databse 
    CREATE DATABASE bank_customer_profiles;
    -- 1 tạo bảng 
    -- bảng customers
    CREATE TABLE customers (
        customer_id SERIAL PRIMARY KEY,
        full_name VARCHAR(100),
        email VARCHAR(100),
        phone VARCHAR(20),
        status VARCHAR(10) CHECK (status IN ('ACTIVE', 'INACTIVE'))
    );
    -- bảng accounts
    CREATE TABLE accounts (
        account_id SERIAL PRIMARY KEY,
        customer_id INTEGER REFERENCES customers(customer_id),
        balance DECIMAL(12, 2),
        account_type VARCHAR(10) CHECK (account_type IN ('SAVINGS', 'CHECKING'))
    );  
    -- bảng transactions
    CREATE TABLE transactions (
        transaction_id SERIAL PRIMARY KEY,
        account_id INTEGER REFERENCES accounts(account_id),
        amount DECIMAL(12, 2),
        description VARCHAR(255),
        transaction_date TIMESTAMP
    );
    -- tạo inndex 
    CREATE INDEX idx_customers_customer_id ON customers(customer_id);
    CREATE INDEX idx_accounts_account_id ON accounts(account_id);
    CREATE INDEX idx_transactions_transaction_date ON transactions(transaction_date)
-------------------------------------------------------------------------------------------------------------
    -- 2 Sử dụng EXISTS, ANY, ALL:
    -- EXISTS – Khách hàng có ít nhất một giao dịch
    SELECT *
    FROM customers c
    WHERE EXISTS (
        SELECT 1
        FROM accounts a
        JOIN transactions t ON a.account_id = t.account_id
        WHERE a.customer_id = c.customer_id
    );
    -- ANY – Tài khoản có balance lớn hơn bất kỳ giao dịch nào
    SELECT *
    FROM accounts
    WHERE balance > ANY (
        SELECT amount FROM transactions
    );
    -- ALL – Khách hàng ACTIVE và tất cả tài khoản đều balance > 1000
    SELECT *
    FROM customers c
    WHERE status = 'ACTIVE'
    AND 1000 < ALL (
        SELECT a.balance
        FROM accounts a
        WHERE a.customer_id = c.customer_id
    );
    -- 3 Sử dụng CASE:
    -- Phân loại tài khoản dựa trên balance
    SELECT account_id, balance,
    CASE
        WHEN balance < 1000 THEN 'LOW'
        WHEN balance <= 5000 THEN 'MEDIUM'
        ELSE 'HIGH'
    END AS balance_category
    FROM accounts;
    -- CASE (phân loại trạng thái giao dịch)
    SELECT transaction_id, amount,
    CASE
        WHEN amount < 500 THEN 'Small'
        ELSE 'Large'
    END AS transaction_size
    FROM transactions;
    -- 4 Sử dụng COALESCE và NULLIF:
    -- Hiển thị số điện thoại hoặc 'No Phone' nếu NULL
    SELECT full_name, COALESCE(phone, 'No Phone') AS phone_display
    FROM customers;
    -- NULLIF – Biến chuỗi rỗng thành NULL
    SELECT transaction_id, NULLIF(description, '') AS cleaned_description
    FROM transactions;
    -- 5 Sử dụng Comments:

    /* 
   Truy vấn kết hợp bảng customers và accounts
   Mục tiêu: Lấy thông tin khách hàng và số lượng tài khoản
    */
    SELECT 
    c.customer_id, 
    c.full_name, 
    COUNT(a.account_id) AS total_accounts -- Đếm số tài khoản của mỗi khách
    FROM customers c
    LEFT JOIN accounts a ON c.customer_id = a.customer_id -- LEFT JOIN để giữ cả khách chưa có tài khoản
    WHERE c.status = 'ACTIVE' -- Chỉ lấy khách đang hoạt động
    GROUP BY c.customer_id, c.full_name;

    -- 6 Sử dụng Operators (Arithmetic, Comparison, Logical):
    -- Tính balance sau khi trừ phí 10% cho tài khoản CHECKING
    SELECT account_id, balance, 
       balance * 0.9 AS balance_after_fee
    FROM accounts
    WHERE account_type = 'CHECKING';
    -- Giao dịch lớn hơn 1000, gần đây, không chứa 'error'
    SELECT *
    FROM transactions
    WHERE amount > 1000
    AND transaction_date >= CURRENT_DATE - INTERVAL '30 days'
    AND description NOT ILIKE '%error%'; -- Phân biệt không hoa thường
    -- 7 Sử dụng INSERT ... ON CONFLICT (Upsert):
    -- Thêm hoặc cập nhật khách hàng nếu đã tồn tại
    INSERT INTO customers (customer_id, full_name, email, phone, status)
    VALUES (1, 'Nguyen Van A', 'new_email@gmail.com', '0912345678', 'ACTIVE')
    ON CONFLICT (customer_id) DO UPDATE
    SET email = EXCLUDED.email,
    phone = EXCLUDED.phone;
    -- -- Thêm giao dịch mới, bỏ qua nếu trùng transaction_id
    INSERT INTO transactions (transaction_id, account_id, amount, description, transaction_date)
    VALUES (1001, 1, 1500, 'Giao dịch mới', NOW())
    ON CONFLICT (transaction_id) DO NOTHING;
    -- 8 Sử dụng String Functions (CONCAT, SUBSTRING, UPPER, LOWER):
    -- Tạo chuỗi: FULL_NAME (EMAIL) với full_name in hoa
    SELECT CONCAT(UPPER(full_name), ' (', email, ')') AS formatted_info
    FROM customers;
    -- -- Lấy 5 ký tự đầu của email (chữ thường)
    SELECT SUBSTRING(LOWER(email), 1, 5) AS email_prefix
    FROM customers;

