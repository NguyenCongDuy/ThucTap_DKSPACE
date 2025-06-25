-- 1 Tạo cấu trúc bảng
-- Bảng accounts
CREATE TABLE accounts (
    account_id SERIAL PRIMARY KEY,
    account_holder VARCHAR(100) NOT NULL,
    balance DECIMAL(12, 2) NOT NULL CHECK (balance >= 0)
);
-- Bảng transactions
CREATE TABLE transactions (
    transaction_id SERIAL PRIMARY KEY,
    from_account_id INT REFERENCES accounts(account_id),
    to_account_id INT REFERENCES accounts(account_id),
    amount DECIMAL(12, 2) NOT NULL CHECK (amount > 0),
    type VARCHAR(20) CHECK (type IN ('TRANSFER', 'DEPOSIT', 'WITHDRAW')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- tạo index 
CREATE INDEX idx_from_account ON transactions(from_account_id);
CREATE INDEX idx_created_at ON transactions(created_at);

-- Quản lý giao dịch chuyển khoản:
BEGIN;

DO $$
DECLARE
    v_balance DECIMAL;
BEGIN
    SELECT balance INTO v_balance
    FROM accounts
    WHERE account_id = 1
    FOR UPDATE;

    IF v_balance >= 500 THEN
        -- Trừ tiền người gửi
        UPDATE accounts
        SET balance = balance - 500
        WHERE account_id = 1;

        -- Cộng tiền người nhận
        UPDATE accounts
        SET balance = balance + 500
        WHERE account_id = 2;

        -- Ghi log giao dịch
        INSERT INTO transactions(from_account_id, to_account_id, amount, type, created_at)
        VALUES (1, 2, 500, 'TRANSFER', CURRENT_TIMESTAMP);

        COMMIT;
        RAISE NOTICE 'Giao dịch chuyển khoản thành công.';
    ELSE
        ROLLBACK;
        RAISE NOTICE 'Giao dịch thất bại: Không đủ số dư.';
    END IF;
END $$;

-- Áp dụng mức độ cô lập (Isolation Levels):

-- read committed
-- Kiểm tra khi tab1 đang thực hiện giao dịch thì tab2 có thể đọc được số dư cập nhật giữa chừng hay không.
-- Giả lập giao dịch tab1
BEGIN ISOLATION LEVEL READ COMMITTED;
-- Kiểm tra số dư 
SELECT balance FROM accounts WHERE account_id = 1;
-- Trừ tiền
UPDATE accounts SET balance = balance - 500 WHERE account_id = 1;
-- Tạm dừng để giả lập 

-- Giả lập giao dịch tab2
BEGIN ISOLATION LEVEL READ COMMITTED;
-- Thử kiểm tra số dư A1 khi giao dịch chưa COMMIT
SELECT balance FROM accounts WHERE account_id = 1;

-- REPEATABLE READ

-- tab2 đọc cùng một tài khoản 2 lần, giữa lúc tab1 thay đổi số dư, xem có bị thay đổi kết quả không.
BEGIN ISOLATION LEVEL REPEATABLE READ;
-- Lần 1 đọc số dư tab1
SELECT balance FROM accounts WHERE account_id = 1;
-- Tạm dừng 10s
-- Trong lúc này, Terminal 1 (tab1) thực hiện chuyển khoản + COMMIT
-- Lần 2 đọc lại số dư tab1
SELECT balance FROM accounts WHERE account_id = 1;

COMMIT;

-- Sử dụng MVCC:
-- Viết truy vấn để kiểm tra các phiên bản dữ liệu (xmin, xmax) trong bảng accounts sau một giao dịch
BEGIN;

UPDATE accounts
SET balance = balance - 500
WHERE account_id = 1;

COMMIT;
-- Kiểm tra xmin, xmax của dữ liệu
SELECT account_id, account_holder, balance, xmin::text, xmax::text
FROM accounts;

-- Sử dụng CTE và Recursive CTE:
-- CTE – Tổng số tiền giao dịch theo account_id trong khoảng thời gian
WITH total_transactions AS (
    SELECT 
        from_account_id AS account_id,
        SUM(amount) AS total_sent
    FROM transactions
    WHERE created_at BETWEEN '2024-01-01' AND '2024-12-31'
    GROUP BY from_account_id
)
SELECT 
    a.account_id,
    a.account_holder,
    COALESCE(t.total_sent, 0) AS total_amount_sent
FROM accounts a
LEFT JOIN total_transactions t ON a.account_id = t.account_id;

-- Recursive CTE – Xây dựng chuỗi lịch sử giao dịch của một account_id
WITH RECURSIVE transaction_chain AS (
    SELECT 
        t.transaction_id,
        t.from_account_id,
        t.to_account_id,
        t.amount,
        t.created_at,
        1 AS level
    FROM transactions t
    WHERE t.from_account_id = 1
    AND t.created_at = (
        SELECT MAX(created_at)
        FROM transactions
        WHERE from_account_id = 1
    )

    UNION ALL

    SELECT 
        t2.transaction_id,
        t2.from_account_id,
        t2.to_account_id,
        t2.amount,
        t2.created_at,
        tc.level + 1
    FROM transactions t2
    JOIN transaction_chain tc ON t2.from_account_id = tc.from_account_id
    WHERE t2.created_at < tc.created_at
)
SELECT * FROM transaction_chain
ORDER BY level;

-- Tránh Deadlock:
-- Giả lập 2 giao dịch có thể xảy ra deadlock
-- tab1
BEGIN;
UPDATE accounts
SET balance = balance - 100
WHERE account_id = 1;
-- tab2
BEGIN;
UPDATE accounts
SET balance = balance - 200
WHERE account_id = 2;
-- return to tab1
UPDATE accounts
SET balance = balance + 100
WHERE account_id = 2;
-- return to tab2
UPDATE accounts
SET balance = balance + 200
WHERE account_id = 1;
-- -> deadlock xảy ra nếu cả hai giao dịch đều đang chờ nhau để hoàn thành.
-- Đề xuất sử dụng advisory locks để tránh deadlock trong kịch bản
SELECT pg_advisory_xact_lock(LEAST(1, 2));
SELECT pg_advisory_xact_lock(GREATEST(1, 2));

-- Viết câu lệnh SQL sử dụng pg_advisory_xact_lock để khóa giao dịch an toàn.
--  Chuyển tiền từ account 1 → 2
BEGIN;

SELECT pg_advisory_xact_lock(LEAST(1, 2));
SELECT pg_advisory_xact_lock(GREATEST(1, 2));
DO $$
DECLARE
    v_balance NUMERIC;
BEGIN
    SELECT balance INTO v_balance FROM accounts WHERE account_id = 1;

    IF v_balance < 100 THEN
        RAISE EXCEPTION 'Insufficient balance in account %', 1;
    END IF;

    UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;
    UPDATE accounts SET balance = balance + 100 WHERE account_id = 2;

    INSERT INTO transactions(from_account_id, to_account_id, amount, type, created_at)
    VALUES (1, 2, 100, 'TRANSFER', NOW());
END $$;
COMMIT;
 -- Chuyển tiền lại từ account 2 → 1 (song song với giao dịch trên)

 BEGIN;

SELECT pg_advisory_xact_lock(LEAST(1, 2));
SELECT pg_advisory_xact_lock(GREATEST(1, 2));

DO $$
DECLARE
    v_balance NUMERIC;
BEGIN
    SELECT balance INTO v_balance FROM accounts WHERE account_id = 2;

    IF v_balance < 200 THEN
        RAISE EXCEPTION 'Insufficient balance in account %', 2;
    END IF;

    UPDATE accounts SET balance = balance - 200 WHERE account_id = 2;
    UPDATE accounts SET balance = balance + 200 WHERE account_id = 1;

    INSERT INTO transactions(from_account_id, to_account_id, amount, type, created_at)
    VALUES (2, 1, 200, 'TRANSFER', NOW());
END $$;

COMMIT;

-- -> Kết quả cuối cùng sẽ là số dư của tài khoản 1 và 2 được cập nhật chính xác mà không xảy ra deadlock.
