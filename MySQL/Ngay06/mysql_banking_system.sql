-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: May 26, 2025 at 10:11 AM
-- Server version: 8.0.30
-- PHP Version: 8.2.20

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `mysql_banking_system`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `TransferMoney` (IN `p_from_account` INT, IN `p_to_account` INT, IN `p_amount` DECIMAL(10,2))   proc_end:BEGIN
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

-- --------------------------------------------------------

--
-- Table structure for table `accounts`
--

CREATE TABLE `accounts` (
  `account_id` int NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `balance` decimal(15,2) NOT NULL DEFAULT '0.00',
  `status` varchar(20) NOT NULL
) ;

--
-- Dumping data for table `accounts`
--

INSERT INTO `accounts` (`account_id`, `full_name`, `balance`, `status`) VALUES
(1, 'Nguyễn Văn A', '10000.00', 'Active'),
(2, 'Trần Thị B', '6600.00', 'Active'),
(3, 'Lê Văn C', '2000.00', 'Frozen'),
(4, 'Phạm Thị D', '0.00', 'Closed');

-- --------------------------------------------------------

--
-- Table structure for table `referrals`
--

CREATE TABLE `referrals` (
  `referrer_id` int NOT NULL,
  `referee_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `referrals`
--

INSERT INTO `referrals` (`referrer_id`, `referee_id`) VALUES
(1, 2),
(1, 3),
(2, 4);

-- --------------------------------------------------------

--
-- Table structure for table `tmpsessiondata`
--

CREATE TABLE `tmpsessiondata` (
  `session_id` int NOT NULL,
  `user_id` int DEFAULT NULL,
  `last_access` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MEMORY DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--

CREATE TABLE `transactions` (
  `txn_id` int NOT NULL,
  `from_account` int NOT NULL,
  `to_account` int NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `txn_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(20) NOT NULL
) ;

--
-- Dumping data for table `transactions`
--

INSERT INTO `transactions` (`txn_id`, `from_account`, `to_account`, `amount`, `txn_date`, `status`) VALUES
(1, 1, 2, '1500.00', '2025-05-26 08:08:29', 'Success'),
(2, 2, 3, '500.00', '2025-05-26 08:08:29', 'Failed'),
(3, 1, 4, '2000.00', '2025-05-26 08:08:29', 'Pending'),
(4, 1, 2, '500.00', '2025-05-26 08:59:14', 'Success'),
(5, 1, 2, '1000.00', '2025-05-26 08:59:31', 'Success'),
(6, 1, 2, '500.00', '2025-05-26 09:00:57', 'Success'),
(7, 2, 1, '500.00', '2025-05-26 09:00:57', 'Success'),
(8, 1, 2, '100.00', '2025-05-26 09:51:56', 'Success');

-- --------------------------------------------------------

--
-- Table structure for table `txnauditlogs`
--

CREATE TABLE `txnauditlogs` (
  `log_id` int NOT NULL,
  `txn_id` int NOT NULL,
  `action` varchar(50) NOT NULL,
  `from_account` int DEFAULT NULL,
  `to_account` int DEFAULT NULL,
  `amount` decimal(15,2) NOT NULL,
  `action_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(20) NOT NULL,
  `description` text
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `txnauditlogs`
--

INSERT INTO `txnauditlogs` (`log_id`, `txn_id`, `action`, `from_account`, `to_account`, `amount`, `action_date`, `status`, `description`) VALUES
(1, 1, 'Create Transaction', 1, 2, '1500.00', '2025-05-26 08:08:34', 'Success', 'Chuyển tiền thành công từ A sang B'),
(2, 2, 'Create Transaction', 2, 3, '500.00', '2025-05-26 08:08:34', 'Failed', 'Chuyển tiền thất bại do tài khoản bị đóng băng'),
(3, 3, 'Create Transaction', 1, 4, '2000.00', '2025-05-26 08:08:34', 'Pending', 'Chuyển tiền đang chờ xử lý'),
(5, 4, 'Transfer', 1, 2, '500.00', '2025-05-26 08:59:14', 'Success', 'Money transferred'),
(6, 5, 'Transfer', 1, 2, '1000.00', '2025-05-26 08:59:31', 'Success', 'Money transferred'),
(7, 6, 'Transfer', 1, 2, '500.00', '2025-05-26 09:00:57', 'Success', 'Money transferred'),
(8, 7, 'Transfer', 2, 1, '500.00', '2025-05-26 09:00:57', 'Success', 'Money transferred'),
(10, 8, 'Transfer', 1, 2, '100.00', '2025-05-26 09:51:56', 'Success', 'Money transferred');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`account_id`);

--
-- Indexes for table `referrals`
--
ALTER TABLE `referrals`
  ADD PRIMARY KEY (`referrer_id`,`referee_id`),
  ADD KEY `referee_id` (`referee_id`);

--
-- Indexes for table `tmpsessiondata`
--
ALTER TABLE `tmpsessiondata`
  ADD PRIMARY KEY (`session_id`);

--
-- Indexes for table `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`txn_id`),
  ADD KEY `from_account` (`from_account`),
  ADD KEY `to_account` (`to_account`);

--
-- Indexes for table `txnauditlogs`
--
ALTER TABLE `txnauditlogs`
  ADD PRIMARY KEY (`log_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `accounts`
--
ALTER TABLE `accounts`
  MODIFY `account_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tmpsessiondata`
--
ALTER TABLE `tmpsessiondata`
  MODIFY `session_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `transactions`
--
ALTER TABLE `transactions`
  MODIFY `txn_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `txnauditlogs`
--
ALTER TABLE `txnauditlogs`
  MODIFY `log_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `referrals`
--
ALTER TABLE `referrals`
  ADD CONSTRAINT `referrals_ibfk_1` FOREIGN KEY (`referrer_id`) REFERENCES `accounts` (`account_id`),
  ADD CONSTRAINT `referrals_ibfk_2` FOREIGN KEY (`referee_id`) REFERENCES `accounts` (`account_id`);

--
-- Constraints for table `transactions`
--
ALTER TABLE `transactions`
  ADD CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`from_account`) REFERENCES `accounts` (`account_id`),
  ADD CONSTRAINT `transactions_ibfk_2` FOREIGN KEY (`to_account`) REFERENCES `accounts` (`account_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
