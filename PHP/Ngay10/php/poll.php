<?php
// sử lý AJAX bình chọn poll
// lưu session bình chọn
session_start();
// trả về định kết quả json
header('Content-Type: application/json');

// các lựa chọn hợp lệ
$options = ['giao_dien', 'toc_do', 'dich_vu_khach_hang'];

// lấy lựa chọn người dùng gửi lên qua POST
$vote = isset($_POST['vote']) ? $_POST['vote'] : '';

// kiểm tra hợp lệ
if (!in_array($vote, $options)) {
    echo json_encode(['success' => false, 'message' => 'Lựa chọn không hợp lệ']);
    exit;
}

// kiểm tra, khởi tạo mảng poll trong session 
if (!isset($_SESSION['poll'])) {
    $_SESSION['poll'] = [
        'giao_dien' => 0,
        'toc_do' => 0,
        'dich_vu_khach_hang' => 0
    ];
}

// cộng thêm 1 cho lựa chọn người dùng chọn
$_SESSION['poll'][$vote]++;

// tính tổng phiếu bình chọn
$totalVotes = array_sum($_SESSION['poll']);

// tính phần trăm cho từng mục
$result = [];
foreach ($_SESSION['poll'] as $key => $count) {
    $percent = $totalVotes > 0 ? round(($count / $totalVotes) * 100, 1) : 0;
    $result[$key] = $percent;
}

// phản hồi JSON cho JS
echo json_encode([
    'success' => true,
    'result' => $result,
    'totalVotes' => $totalVotes
]);
