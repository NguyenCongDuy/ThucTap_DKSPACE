
 -- tạo bảng accounts dùng innoDB cũng như bảng  Transactions
 CREATE TABLE Accounts (
    account_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    balance DECIMAL(15,2) NOT NULL DEFAULT 0.00,
    status VARCHAR(20) NOT NULL CHECK (status IN ('Active', 'Frozen', 'Closed'))
) ENGINE=InnoDB;

CREATE TABLE Transactions (
    txn_id INT AUTO_INCREMENT PRIMARY KEY,
    from_account INT NOT NULL,
    to_account INT NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    txn_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL CHECK (status IN ('Success', 'Failed', 'Pending')),
    FOREIGN KEY (from_account) REFERENCES Accounts(account_id),
    FOREIGN KEY (to_account) REFERENCES Accounts(account_id)
) ENGINE=InnoDB;

-- Tạo bảng TxnAuditLogs dùng MyISAM

CREATE TABLE TxnAuditLogs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    txn_id INT NOT NULL,
    action VARCHAR(50) NOT NULL,
    from_account INT NULL,
    to_account INT NULL,
    amount DECIMAL(15,2) NOT NULL,
    action_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL,
    description TEXT
) ENGINE=MyISAM;

-- tạo 1 bảng mẫu TmpSessionData để có thể so sánh giữ innodb-myisam-memory
CREATE TABLE TmpSessionData (
    session_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    last_access TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=MEMORY;

-- bảng referrals
CREATE TABLE Referrals (
    referrer_id INT NOT NULL,
    referee_id INT NOT NULL,
    PRIMARY KEY (referrer_id, referee_id),
    FOREIGN KEY (referrer_id) REFERENCES Accounts(account_id),
    FOREIGN KEY (referee_id) REFERENCES Accounts(account_id)
);
