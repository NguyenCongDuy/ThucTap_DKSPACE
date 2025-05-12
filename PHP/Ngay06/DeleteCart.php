<?php
session_start();

try {
    // 1. Xóa session giỏ hàng nếu có
    if (isset($_SESSION['gio_hang'])) {
        unset($_SESSION['gio_hang']);
    }

    // 2. Xóa dữ liệu cart_data.json nếu tồn tại
    $duong_dan = 'CartData.json';
    if (file_exists($duong_dan)) {
        $du_lieu_trong = json_encode([], JSON_PRETTY_PRINT);
        if (file_put_contents($duong_dan, $du_lieu_trong) === false) {
            throw new Exception("Không thể ghi dữ liệu rỗng vào file giỏ hàng.");
        }
    }

    // 3. Chuyển về trang chính
    header("Location: index.php");
    exit;
} catch (Exception $e) {
    echo "<h3 style='color:red;'>Lỗi khi xóa giỏ hàng: " . htmlspecialchars($e->getMessage()) . "</h3>";
    echo "<a href='view_cart.php'>Quay lại giỏ hàng</a>";
}
