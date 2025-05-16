<?php

// xử lý AJAX tìm kiếm sản phẩm

header('Content-Type: text/html; charset=utf-8'); // Trả html fragment
require_once '../db/db_connection.php';
// Lấy từ khóa tìm kiếm từ GET 
$keyword = isset($_GET['keyword']) ? trim($_GET['keyword']) : '';

// Kiểm tra nếu rỗng thì dừng
if ($keyword === '') {
    echo '<p>Vui lòng nhập từ khóa...</p>';
    exit;
}

// lệnh SQL dùng like để tìm tên sản phẩm có chứa từ khóa
$sql = "SELECT id, name, description, price  FROM products WHERE name LIKE :kw LIMIT 10";
$stmt = $pdo->prepare($sql);
$stmt->execute(['kw' => '%' . $keyword . '%']);

// Kiểm tra có kết quả không
if ($stmt->rowCount() > 0) {
    // Lặp qua kết quả và tạo HTML
    foreach ($stmt as $row) {
        echo '<div class="search-item">';
        echo '<strong>' . htmlspecialchars($row['name']) . '</strong> - ' . number_format($row['price']) . ' VND';
        echo '</div>';
    }
} else {
    echo '<p>Không tìm thấy sản phẩm...</p>';
}
?>