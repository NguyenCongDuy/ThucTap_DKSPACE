<?php
// kết nối database
$host = 'localhost';
$dbname = 'e_commerce';
$username = 'root';
$password = '';

try {
    // Khởi tạo PDO
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8mb4", $username, $password);
    // Thiết lập chế độ lỗi cho PDO (nên để ở chế độ Exception khi dev)
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    // echo "Kết nối database thành công!";
} catch (PDOException $e) {
    die("Lỗi kết nối database: " . $e->getMessage());
}
