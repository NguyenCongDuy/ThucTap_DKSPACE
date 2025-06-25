-- Sử dụng EXPLAIN và EXPLAIN ANALYZE:
-- 1: Truy vấn gốc lấy  lấy danh sách giao dịch (transactions) trong 30 ngày qua, 
    --ghép với bảng accounts để hiển thị account_type và balance.
SELECT
    t.transaction_id,
    t.account_id,
    a.account_type,
    a.balance,
    t.amount,
    t.type,
    t.transaction_date
FROM
    transactions t
JOIN accounts a ON t.account_id = a.account_id
WHERE
    t.transaction_date >= CURRENT_DATE - INTERVAL '30 days'
ORDER BY
    t.transaction_date DESC;
-- sử dụng EXPLAIN và EXPLAIN ANALYZE để xem kế hoạch thực thi và hiệu suất của truy vấn
--  Đề xuất cải tiến hiệu năng:
CREATE INDEX idx_transaction_date ON transactions (transaction_date);
-- 2. Tạo và sử dụng Index:
-- B-tree Index trên transaction_date
CREATE INDEX idx_transaction_date ON transactions (transaction_date);
-- GIN Index trên cột details (kiểu jsonb)
CREATE INDEX idx_transaction_details_gin ON transactions USING GIN (details);
--  Composite Index trên (account_id, transaction_date)
CREATE INDEX idx_account_date ON transactions (account_id, transaction_date);
-- Truy vấn sử dụng GiST index
SELECT *
FROM transactions
WHERE details @> '{"recipient": "Bob"}'
   OR details->>'note' LIKE '%monthly%'

-- 3. Giải quyết Index Bloating:
-- Viết lệnh để tái tạo index trên bảng transactions
REINDEX INDEX idx_transaction_date;
-- Bật  extension pgstattuple
CREATE EXTENSION IF NOT EXISTS pgstattuple;

-- Kiểm tra bloating trên bảng transactions
SELECT * FROM pgstattuple('transactions');
-- Kiểm tra bloating trên index cụ thể
SELECT * FROM pgstattuple('idx_transaction_date');


-- 4 Phân vùng bảng (Table Partitioning):
-- Tạo bảng phân vùng cho transactions
CREATE TABLE transactions (
    transaction_id UUID,
    account_id UUID REFERENCES accounts(account_id),
    amount DECIMAL(12,2),
    type VARCHAR(20) CHECK (type IN ('DEPOSIT', 'WITHDRAW', 'TRANSFER')),
    transaction_date TIMESTAMP NOT NULL,
    details JSONB,
    PRIMARY KEY (transaction_id, transaction_date)
) PARTITION BY RANGE (transaction_date);
-- tạo phân vùng cho các tháng
-- Phân vùng cho năm 2023
CREATE TABLE transactions_2023 PARTITION OF transactions
    FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

-- Phân vùng cho năm 2024
CREATE TABLE transactions_2024 PARTITION OF transactions
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

-- Phân vùng cho năm 2025
CREATE TABLE transactions_2025 PARTITION OF transactions
    FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');
-- Viết truy vấn và sử dụng EXPLAIN  để kiểm tra hiệu suất truy vấn trên bảng phân vùng
EXPLAIN
SELECT *
FROM transactions
WHERE transaction_date >= '2024-01-01'
AND transaction_date < '2025-01-01';

-- 5 Chọn kiểu dữ liệu tối ưu:
-- Truy vấn chèn dữ liệu JSONB
INSERT INTO transactions (transaction_id, account_id, amount, type, transaction_date, details)
VALUES (
  gen_random_uuid(),
  'd7d00794-1ed9-4996-9118-cd139d24b4cb', 
  100000,
  'TRANSFER',
  NOW(),
  '{"recipient": "John Doe", "note": "Monthly transfer"}'::jsonb
);

-- 6 Sử dụng Window Functions:
-- Dùng ROW_NUMBER() để đánh số giao dịch theo từng tài khoản
SELECT
    transaction_id,
    account_id,
    amount,
    transaction_date,
    ROW_NUMBER() OVER (PARTITION BY account_id ORDER BY transaction_date DESC) AS transaction_rank
FROM transactions;
-- Dùng RANK() để xếp hạng tài khoản theo số dư trong từng loại tài khoản
SELECT
    account_id,
    account_type,
    balance,
    RANK() OVER (PARTITION BY account_type ORDER BY balance DESC) AS balance_rank
FROM accounts;
-- Dùng LAG() và LEAD() để xem giao dịch trước và sau
SELECT
    account_id,
    transaction_id,
    transaction_date,
    amount,
    LAG(amount) OVER (PARTITION BY account_id ORDER BY transaction_date) AS previous_amount,
    LEAD(amount) OVER (PARTITION BY account_id ORDER BY transaction_date) AS next_amount
FROM transactions;

-- 7: Tối ưu Transaction:
-- Kịch bản chuyển khoản với BEGIN / COMMIT / ROLLBACK

BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;

DO $$
DECLARE
    sender UUID := '8105edfe-4732-46d3-b955-7f7dc6e6e9b4';
    receiver UUID := 'd7d00794-1ed9-4996-9118-cd139d24b4cb';
    transfer_amount DECIMAL := 500;
    sender_balance DECIMAL;
BEGIN
    -- Khóa theo thứ tự để tránh deadlock
    PERFORM balance FROM accounts WHERE account_id = sender FOR UPDATE;
    PERFORM balance FROM accounts WHERE account_id = receiver FOR UPDATE;

    -- Kiểm tra số dư
    SELECT balance INTO sender_balance FROM accounts WHERE account_id = sender;
    IF sender_balance < transfer_amount THEN
        RAISE EXCEPTION 'Số dư không đủ để chuyển.';
    END IF;

    -- Thử chuyển khoản, nếu lỗi thì raise exception để rollback transaction ngoài
    BEGIN
        -- Trừ tiền người gửi
        UPDATE accounts
        SET balance = balance - transfer_amount
        WHERE account_id = sender;

        -- Cộng tiền người nhận
        UPDATE accounts
        SET balance = balance + transfer_amount
        WHERE account_id = receiver;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE EXCEPTION 'Lỗi khi chuyển khoản: %', SQLERRM;
    END;

    -- Ghi log giao dịch
    INSERT INTO transactions (transaction_id, account_id, amount, type, transaction_date, details)
    VALUES (
        gen_random_uuid(), 
        sender, 
        transfer_amount, 
        'TRANSFER', 
        NOW(), 
        jsonb_build_object(
            'recipient', receiver,
            'note', 'Chuyển khoản tháng 6'
        )
    );

END $$;

COMMIT;

-- 8. Sử dụng Slow Query Log (pg_stat_statements):


SELECT * FROM transactions WHERE details->>'recipient' = 'John Doe';
-- xem thống kê truy vấn chậm
SELECT query,
       calls,
       total_exec_time,
       mean_exec_time,
       rows
FROM pg_stat_statements
ORDER BY total_exec_time DESC
LIMIT 10;
