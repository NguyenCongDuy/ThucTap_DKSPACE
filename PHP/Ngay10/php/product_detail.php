<?php
// product_detail.php
// nhận id sản phẩm từ Ajax -> Query DB -> Trả HTML

require_once '../db/db_connection.php';
// if (!isset($pdo)) {
//     die("Không kết nối được CSDL.");
// }

// nhận id từ GET, kiểm tra an toàn 
$id = isset($_GET['id']) ? intval($_GET['id']) : 0;

// kiểm tra id hợp lệ
if ($id > 0) {
    // 3. Thực hiện query bằng Prepared Statement để tránh SQL Injection
    $stmt = $pdo->prepare("SELECT name, description, price, stock FROM products WHERE id = ?");
    $stmt->execute([$id]);

    // lấy dữ liệu
    $sp = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($sp) {
        // trả về HTML fragment để frontend nhận và render
        echo "<strong>Tên:</strong> {$sp['name']}<br>";
        echo "<strong>Mô tả:</strong> {$sp['description']}<br>";
        echo "<strong>Giá:</strong> " . number_format($sp['price'], 0, ',', '.') . " VNĐ<br>";
        echo "<strong>Tồn kho:</strong> {$sp['stock']}<br>";
    } else {
        echo "Không tìm thấy sản phẩm.";
    }
} else {
    echo "ID sản phẩm không hợp lệ.";
}
?>