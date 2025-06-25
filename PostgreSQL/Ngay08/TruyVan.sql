-- 1: Query Caching với Materialized Views:
-- Tạo Materialized View tổng hợp theo tháng
CREATE MATERIALIZED VIEW monthly_transaction_summary AS
SELECT
    account_id,
    date_trunc('month', transaction_date) AS month,
    COUNT(*) AS transaction_count,
    SUM(amount) AS total_amount
FROM transactions
GROUP BY account_id, date_trunc('month', transaction_date);

-- Làm mới dữ liệu một cách an toàn, không khóa truy vấn khác
-- cần có index CONCURRENTLY trên materialized view để hỗ trợ
CREATE UNIQUE INDEX CONCURRENTLY IF NOT EXISTS idx_mts ON monthly_transaction_summary(account_id, month);
-- Làm mới dữ liệu không gây khóa toàn bảng
REFRESH MATERIALIZED VIEW CONCURRENTLY monthly_transaction_summary;
-- Truy vấn danh sách tài khoản có tổng giao dịch trong tháng gần nhất > 100
SELECT *
FROM monthly_transaction_summary
WHERE month = (
    SELECT MAX(month) FROM monthly_transaction_summary
)
AND total_amount > 100;

-- 2: Phân vùng bảng (Table Partitioning)
-- Tạo bảng mẹ transactions có phân vùng
DROP TABLE IF EXISTS transactions CASCADE;

CREATE TABLE transactions (
    transaction_id UUID NOT NULL DEFAULT uuid_generate_v4(),
    account_id UUID REFERENCES accounts(account_id),
    amount DECIMAL(12, 2) NOT NULL CHECK (amount >= 0),
    type VARCHAR(20) CHECK (type IN ('DEPOSIT', 'WITHDRAW', 'TRANSFER')),
    transaction_date TIMESTAMP NOT NULL,
    metadata JSONB,
    PRIMARY KEY (transaction_id, transaction_date)
) PARTITION BY RANGE (transaction_date);

-- Tạo các phân vùng con cho từng năm
CREATE TABLE transactions_2023 PARTITION OF transactions
    FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

CREATE TABLE transactions_2024 PARTITION OF transactions
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

CREATE TABLE transactions_2025 PARTITION OF transactions
    FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');
-- Truy vấn chỉ trong phân vùng 2024 + EXPLAIN
EXPLAIN ANALYZE
SELECT *
FROM transactions
WHERE transaction_date >= '2024-01-01' AND transaction_date < '2025-01-01';

SELECT '2023' AS year, COUNT(*) FROM transactions_2023
UNION ALL
SELECT '2024', COUNT(*) FROM transactions_2024
UNION ALL
SELECT '2025', COUNT(*) FROM transactions_2025;
-- 3 Chọn kiểu dữ liệu tối ưu:

-- Truy vấn thêm mới transactions với JSONB
INSERT INTO transactions ( transaction_id,  account_id,  amount, type, transaction_date, metadata
) VALUES ( gen_random_uuid(),'c2fe347b-75a9-4a01-8343-56b5caab138f',  1500.00,  'DEPOSIT',   NOW(),
    '{"source": "ATM", "location": "HCM"}'::jsonb
);

-- 4
-- ROW_NUMBER – Đánh số thứ tự giao dịch của từng tài khoản
SELECT
    transaction_id,
    account_id,
    amount,
    transaction_date,
    ROW_NUMBER() OVER (
        PARTITION BY account_id
        ORDER BY transaction_date DESC
    ) AS transaction_order
FROM transactions;
-- RANK – Xếp hạng tài khoản theo tổng giao dịch trong tháng gần nhất (group theo account_type)
WITH monthly_summary AS (
    SELECT
        account_id,
        account_type,
        SUM(amount) AS total_amount
    FROM transactions t
    JOIN accounts a ON t.account_id = a.account_id
    WHERE transaction_date >= date_trunc('month', CURRENT_DATE)
    GROUP BY account_id, account_type
)
SELECT *,
    RANK() OVER (
        PARTITION BY account_type
        ORDER BY total_amount DESC
    ) AS rank_in_type
FROM monthly_summary;

-- LAG và LEAD – Lấy giao dịch trước và sau theo thời gian
SELECT
    transaction_id,
    account_id,
    amount,
    transaction_date,
    LAG(amount) OVER (
        PARTITION BY account_id
        ORDER BY transaction_date
    ) AS previous_amount,
    LEAD(amount) OVER (
        PARTITION BY account_id
        ORDER BY transaction_date
    ) AS next_amount
FROM transactions;
-- 5: Tối ưu Transaction:
BEGIN;

-- Khóa 2 tài khoản theo thứ tự tăng dần để tránh deadlock
SELECT * FROM accounts
WHERE account_id IN ('4fcdebed-c7c7-49bf-a066-2a0242c3ca03', 'ffa9610c-deef-484a-b77e-40b29d5ba4f7')
ORDER BY account_id
FOR UPDATE;

-- Kiểm tra số dư của người gửi
DO $$
DECLARE
    sender_balance DECIMAL;
BEGIN
    SELECT balance INTO sender_balance
    FROM accounts
    WHERE account_id = 'ffa9610c-deef-484a-b77e-40b29d5ba4f7';

    IF sender_balance >= 1000 THEN
        -- Trừ tiền người gửi
        UPDATE accounts
        SET balance = balance - 1000
        WHERE account_id = 'ffa9610c-deef-484a-b77e-40b29d5ba4f7';

        -- Cộng tiền người nhận
        UPDATE accounts
        SET balance = balance + 1000
        WHERE account_id = '4fcdebed-c7c7-49bf-a066-2a0242c3ca03';

        -- Ghi vào bảng transactions (2 chiều: gửi và nhận)
        INSERT INTO transactions (transaction_id, account_id, amount, type, transaction_date, metadata)
        VALUES
            (gen_random_uuid(), 'ffa9610c-deef-484a-b77e-40b29d5ba4f7', 1000, 'TRANSFER', NOW(), '{"direction": "out", "to": "4fcdebed-c7c7-49bf-a066-2a0242c3ca03"}'),
            (gen_random_uuid(), '4fcdebed-c7c7-49bf-a066-2a0242c3ca03', 1000, 'TRANSFER', NOW(), '{"direction": "in", "from": "ffa9610c-deef-484a-b77e-40b29d5ba4f7"}');

        COMMIT;
        RAISE NOTICE 'Chuyển khoản thành công.';
    ELSE
        RAISE NOTICE 'Không đủ số dư, huỷ giao dịch.';
        ROLLBACK;
    END IF;
END$$;


-- 6: Sử dụng Slow Query Log (pg_stat_statements):
-- chạy extension pg_stat_statements
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;
-- Truy vấn thống kê các truy vấn chậm
SELECT query,
       calls,
       total_exec_time,
       mean_exec_time,
       rows
FROM pg_stat_statements
ORDER BY total_exec_time DESC
LIMIT 10;
--  Xem những truy vấn được gọi nhiều nhất:
SELECT query,
       calls,
       total_exec_time,
       mean_exec_time
FROM pg_stat_statements
ORDER BY calls DESC
LIMIT 10;