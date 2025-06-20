-- 1. Quản lý Views
-- Tạo view account_summary:
CREATE VIEW account_summary AS
SELECT
    c.full_name,
    c.email,
    a.account_id,
    a.balance,
    a.account_type
FROM
    customers c
JOIN
    accounts a ON c.customer_id = a.customer_id;
-- Đổi tên view account_summary → customer_account_summary:
ALTER VIEW account_summary RENAME TO customer_account_summary;
-- Truy vấn từ view với balance > 5000:
SELECT *
FROM customer_account_summary
WHERE balance > 5000;
-- Xoá view customer_account_summary:
DROP VIEW IF EXISTS customer_account_summary;

-- 2. Quản lý Materialized Views:
-- Tạo materialized view transaction_stats:
CREATE MATERIALIZED VIEW transaction_stats AS
SELECT 
    account_id,
    type,
    COUNT(*) AS total_transactions,
    SUM(amount) AS total_amount
FROM transactions
GROUP BY account_id, type;
-- Làm mới dữ liệu transaction_stats không khoá:
REFRESH MATERIALIZED VIEW CONCURRENTLY transaction_stats;
-- Truy vấn từ transaction_stats:
SELECT *
FROM transaction_stats
WHERE total_amount > 10000;
-- Xoá materialized view:
DROP MATERIALIZED VIEW IF EXISTS transaction_stats;

-- 3. Tạo Stored Procedures với PL/pgSQL:
-- Tạo Function transfer_funds
CREATE OR REPLACE FUNCTION transfer_funds(
    from_account_id INT,
    to_account_id INT,
    amount DECIMAL
) RETURNS VOID AS $$
DECLARE
    v_balance DECIMAL;
BEGIN
    -- Kiểm tra số dư tài khoản gửi
    SELECT balance INTO v_balance
    FROM accounts
    WHERE account_id = from_account_id;

    IF v_balance IS NULL THEN
        RAISE EXCEPTION 'Tài khoản gửi không tồn tại: %', from_account_id;
    ELSIF v_balance < amount THEN
        RAISE EXCEPTION 'Số dư không đủ trong tài khoản %', from_account_id;
    END IF;

    -- Trừ tiền tài khoản gửi
    UPDATE accounts
    SET balance = balance - amount,
        last_updated = NOW()
    WHERE account_id = from_account_id;

    -- Cộng tiền tài khoản nhận
    UPDATE accounts
    SET balance = balance + amount,
        last_updated = NOW()
    WHERE account_id = to_account_id;

    -- Ghi log vào bảng transactions
    INSERT INTO transactions(account_id, amount, type, transaction_date)
    VALUES 
        (from_account_id, -amount, 'TRANSFER', NOW()),
        (to_account_id, amount, 'TRANSFER', NOW());

    RAISE NOTICE 'Chuyển khoản thành công: từ % đến %, số tiền %', from_account_id, to_account_id, amount;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Lỗi xảy ra: %', SQLERRM;
        RAISE;
END;
$$ LANGUAGE plpgsql;

--  Tạo Stored Procedure: update_customer_email
CREATE OR REPLACE FUNCTION update_customer_email(
    p_customer_id INT,
    p_new_email VARCHAR
) RETURNS VOID AS $$
BEGIN
    -- Kiểm tra định dạng email
    IF POSITION('@' IN p_new_email) = 0 THEN
        RAISE EXCEPTION 'Email không hợp lệ: %', p_new_email;
    END IF;

    -- Cập nhật email
    UPDATE customers
    SET email = p_new_email
    WHERE customer_id = p_customer_id;

    RAISE NOTICE 'Email đã được cập nhật cho customer_id %', p_customer_id;
END;
$$ LANGUAGE plpgsql;

-- 4. Tạo Trigger ghi log thay đổi vào audit_log
-- Tạo hàm Trigger function log_account_changes()
CREATE OR REPLACE FUNCTION log_account_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO audit_log(table_name, operation, record_id, changed_at, old_data, new_data)
        VALUES (
            'accounts',
            'INSERT',
            NEW.account_id,
            NOW(),
            NULL,
            row_to_json(NEW)::jsonb
        );

    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO audit_log(table_name, operation, record_id, changed_at, old_data, new_data)
        VALUES (
            'accounts',
            'UPDATE',
            NEW.account_id,
            NOW(),
            row_to_json(OLD)::jsonb,
            row_to_json(NEW)::jsonb
        );

    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO audit_log(table_name, operation, record_id, changed_at, old_data, new_data)
        VALUES (
            'accounts',
            'DELETE',
            OLD.account_id,
            NOW(),
            row_to_json(OLD)::jsonb,
            NULL
        );
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;
-- Gắn Trigger vào bảng accounts
CREATE TRIGGER trigger_account_audit
AFTER INSERT OR UPDATE OR DELETE ON accounts
FOR EACH ROW
EXECUTE FUNCTION log_account_changes();

-- kiểm tra và bảo mật
CREATE OR REPLACE FUNCTION transfer_funds(
    from_account_id INT,
    to_account_id INT,
    amount DECIMAL
)
RETURNS VOID AS $$
DECLARE
    v_balance DECIMAL;
    v_exists_from BOOLEAN;
    v_exists_to BOOLEAN;
BEGIN
    -- Kiểm tra amount hợp lệ
    IF amount <= 0 THEN
        RAISE EXCEPTION 'Amount must be greater than 0';
    END IF;

    -- Kiểm tra tồn tại tài khoản gửi
    SELECT EXISTS(SELECT 1 FROM accounts WHERE account_id = from_account_id)
    INTO v_exists_from;

    IF NOT v_exists_from THEN
        RAISE EXCEPTION 'From account ID % does not exist', from_account_id;
    END IF;

    -- Kiểm tra tồn tại tài khoản nhận
    SELECT EXISTS(SELECT 1 FROM accounts WHERE account_id = to_account_id)
    INTO v_exists_to;

    IF NOT v_exists_to THEN
        RAISE EXCEPTION 'To account ID % does not exist', to_account_id;
    END IF;

    -- Lấy số dư tài khoản gửi
    SELECT balance INTO v_balance
    FROM accounts
    WHERE account_id = from_account_id;

    IF v_balance < amount THEN
        RAISE EXCEPTION 'Insufficient balance in account %', from_account_id;
    END IF;

    -- Trừ và cộng tiền
    UPDATE accounts SET balance = balance - amount, last_updated = NOW()
    WHERE account_id = from_account_id;

    UPDATE accounts SET balance = balance + amount, last_updated = NOW()
    WHERE account_id = to_account_id;

    -- Thêm 2 bản ghi giao dịch
    INSERT INTO transactions (account_id, amount, type, transaction_date)
    VALUES
        (from_account_id, amount, 'TRANSFER', NOW()),
        (to_account_id, amount, 'TRANSFER', NOW());

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Transfer failed: %', SQLERRM;
        ROLLBACK;
END;
