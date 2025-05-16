<?php

// xử lý ajax trả về danh sách đánh giá Json
header('Content-Type: application/json'); // đặt headers trả về json
// ini_set('display_errors', 1);
// error_reporting(E_ALL);
// kiểm tra xem dữ liệu có được gửi lên hay không
if(!isset($_GET['product_id'])) {
    // nếu không có trả về lỗi json và dừng lại
    echo json_encode(['error' => 'Không có ID dữ liệu']);
    exit;
}
require_once '../db/db_connection.php';
// lấy product_id từ ajax & ép kiểu int
$productId = (int)$_GET['product_id'];
// câu truy vấn lấy danh sách đánh giá
$sql = "SELECT user_name, rating, content, created_at FROM reviews WHERE product_id = :product_id ORDER BY created_at DESC";
$stmt = $pdo->prepare($sql);
$stmt->execute(['product_id' => $productId]);
$reviews = $stmt->fetchAll(PDO::FETCH_ASSOC);
// dùng array_map để xử lý dữ liệu
$reviews = array_map(function($r) {
    return [
        'user' => htmlspecialchars($r['user_name']),      
        'rating' => (int)$r['rating'],                   
        'content' => htmlspecialchars($r['content']),    
        'time' => date('d/m/Y H:i', strtotime($r['created_at'])) 
    ];
}, $reviews);
// trả về JSON chứa danh sách đánh giá cho client
echo json_encode($reviews);
?>