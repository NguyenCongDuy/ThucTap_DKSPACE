<?php
require_once 'db.php';

try {
    // Tạo bảng products
    $sql = "CREATE TABLE IF NOT EXISTS products (
            id INT PRIMARY KEY AUTO_INCREMENT,
            product_name VARCHAR(100) NOT NULL,
            unit_price DECIMAL(10,2) NOT NULL,
            stock_quantity INT NOT NULL,
            created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    ) ENGINE=InnoDB;";
    $pdo->exec($sql);

    // Tạo bảng orders
    $sql = "CREATE TABLE IF NOT EXISTS orders (
            id INT PRIMARY KEY AUTO_INCREMENT,
            order_date DATE NOT NULL,
            customer_name VARCHAR(100) NOT NULL,
            note TEXT NULL
    ) ENGINE=InnoDB;";
    $pdo->exec($sql);

    // Tạo bảng order_items
    $sql = "CREATE TABLE IF NOT EXISTS order_items (
            id INT PRIMARY KEY AUTO_INCREMENT,
            order_id INT NOT NULL,
            product_id INT NOT NULL,
            quantity INT NOT NULL,
            price_at_order_time DECIMAL(10,2) NOT NULL,
            FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
            FOREIGN KEY (product_id) REFERENCES products(id)
    ) ENGINE=InnoDB;";
    $pdo->exec($sql);

    echo "Tạo bảng thành công.";
} catch (PDOException $e) {
    die("Lỗi kết nối hoặc tạo database: " . $e->getMessage());
}
