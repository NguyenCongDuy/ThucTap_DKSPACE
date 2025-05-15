<?php
    $host = 'localhost';  
    $user = 'root';
    $password = ''; 
    $dbName = 'tech_factory';


    try {
        $pdo = new PDO("mysql:host=$host", $user, $password);
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

        // tạo database nếu chưa tồn tại
        $pdo->exec("CREATE DATABASE IF NOT EXISTS `$dbName` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
        // kết nối đến database
        $pdo = new PDO("mysql:host=$host;dbname=$dbName; charset=utf8mb4", $user, $password);
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

        // echo "Kết nối thành công đến database $dbName";
    } catch (PDOException $e) {
        die("Lỗi kết nối hoặc tạo database: " . $e->getMessage());
    }


?>