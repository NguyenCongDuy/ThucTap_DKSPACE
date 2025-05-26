-- 1. Storage Engine: sự khác nhau InnoDB, MyISAM và MEMORY.

-- câu lệnh test với bảng innoDB
START TRANSACTION;
UPDATE Accounts SET balance = balance - 1000 WHERE account_id = 1;
SELECT balance FROM Accounts WHERE account_id = 1;
ROLLBACK;
SELECT balance FROM Accounts WHERE account_id = 1;
-- khi thựch hiện câu lệnh trên thì sẽ không có gì thay đổi 
-- trong bảng Accounts vì chúng ta đã dùng lệnh ROLLBACK để hoàn tác lại giao dịch.

-- câu lệnh test với bảng MyISAM
INSERT INTO TxnAuditLogs (txn_id, action, from_account, to_account, amount, action_date, status, description) VALUES
(999, 'Test Insert', 1, 2, 100, NOW(), 'Success', 'Test log insert');
ROLLBACK;
-- với MyISAM, khi insert dữ liệu thì ngay lập tức ghi vào bảng, không thể rollback.

ALTER TABLE TxnAuditLogs
ADD CONSTRAINT fk_txn FOREIGN KEY (log_id) REFERENCES Accounts(account_id);
-- khi thực hiện câu lệnh này sẽ báo lỗi vì MyISAM không hỗ trợ khóa ngoại.


-- 2. Transactions & Chống Deadlock:
DELIMITER $$

CREATE PROCEDURE TransferMoney(
    IN p_from_account INT,
    IN p_to_account INT,
    IN p_amount DECIMAL(10,2)
)
 proc_end:BEGIN
    -- biến lưu số dư, trang thái của tk gửi và trạng thái của tk nhận
    DECLARE v_from_balance DECIMAL(10,2);
    DECLARE v_from_status VARCHAR(20);
    DECLARE v_to_status VARCHAR(20);
    -- xử lý ngoại lệ: nếu có lỗi SQL xảy ra thì rollback giao dịch
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    -- lock 2 tài khoản theo thứ tự ID tăng dần để tránh deadlock
    IF p_from_account < p_to_account THEN
        SELECT balance, status INTO v_from_balance, v_from_status
        FROM Accounts WHERE account_id = p_from_account FOR UPDATE;

        SELECT status INTO v_to_status
        FROM Accounts WHERE account_id = p_to_account FOR UPDATE;
    ELSE
        SELECT status INTO v_to_status
        FROM Accounts WHERE account_id = p_to_account FOR UPDATE;

        SELECT balance, status INTO v_from_balance, v_from_status
        FROM Accounts WHERE account_id = p_from_account FOR UPDATE;
    END IF;

    -- kiểm tra trạng thái Active
    IF v_from_status != 'Active' OR v_to_status != 'Active' THEN
        ROLLBACK;
        LEAVE proc_end;
    END IF;

    -- Kiểm tra đủ tiền
    IF v_from_balance < p_amount THEN
        ROLLBACK;
        LEAVE proc_end;
    END IF;

    -- trừ và cộng tiền
    UPDATE Accounts SET balance = balance - p_amount
    WHERE account_id = p_from_account;

    UPDATE Accounts SET balance = balance + p_amount
    WHERE account_id = p_to_account;

    -- ghi vào bảng Transactions
    INSERT INTO Transactions (from_account, to_account, amount, txn_date, status)
    VALUES (p_from_account, p_to_account, p_amount, NOW(), 'Success');

    -- ghi vào bảng TxnAuditLogs (MyISAM)
    INSERT INTO TxnAuditLogs (txn_id, action, from_account, to_account, amount, action_date, status, description)
    VALUES (LAST_INSERT_ID(), 'Transfer', p_from_account, p_to_account, p_amount, NOW(), 'Success', 'Money transferred');
    COMMIT;
END$$

DELIMITER ;

-- CTE Đệ Quy:
WITH RECURSIVE MultiLevelReferrals AS (
    -- cấp gốc: lấy trực tiếp người được giới thiệu của 1
    SELECT referee_id
    FROM Referrals
    WHERE referrer_id = 1

    UNION ALL

    -- đệ quy: lấy tiếp người được giới thiệu của cấp dưới
    SELECT r.referee_id
    FROM Referrals r
    INNER JOIN MultiLevelReferrals mlr ON r.referrer_id = mlr.referee_id
)
SELECT DISTINCT referee_id AS referred_account_id
FROM MultiLevelReferrals;

-- CTE Truy vấn phức tạp:

WITH AvgAmount AS (
    SELECT AVG(amount) AS avg_amount FROM Transactions
)
SELECT 
    txn_id,
    from_account,
    to_account,
    amount,
    txn_date,
    status,
    CASE
        WHEN amount > (SELECT avg_amount FROM AvgAmount) THEN 'High'
        WHEN amount = (SELECT avg_amount FROM AvgAmount) THEN 'Normal'
        ELSE 'Low'
    END AS amount_label
FROM Transactions;

