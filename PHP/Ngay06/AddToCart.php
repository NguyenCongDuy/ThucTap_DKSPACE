<?php
session_start();
// var_dump($_POST);

// bật hiển thị lỗi khi debug
ini_set('display_errors', 1);
error_reporting(E_ALL);
try {
    // kiểm tra dữ liệu đầu vào
    $tieuDe = filter_input(INPUT_POST, 'sach', FILTER_SANITIZE_FULL_SPECIAL_CHARS);
    $soLuong = filter_input(INPUT_POST, 'so_luong', FILTER_VALIDATE_INT, ["options" => ["min_range" => 1]]);
    $email = filter_input(INPUT_POST, 'email', FILTER_VALIDATE_EMAIL);
    $soDienThoai = filter_input(INPUT_POST, 'so_dien_thoai', FILTER_VALIDATE_REGEXP, [
        "options" => ["regexp" => "/^[0-9]{9,11}$/"]
    ]);
    $diaChi = filter_input(INPUT_POST, 'dia_chi', FILTER_SANITIZE_FULL_SPECIAL_CHARS);
    if (!$tieuDe || !$soLuong || !$email || !$soDienThoai || !$diaChi) {
        throw new Exception("Dữ liệu đầu vào không hợp lệ ! Vui lòng kiểm tra lại.");
    }
    $bangGia = [
        'Books' => 20000,
        'Clean Code' => 10000,
        'Design Patterns' => 30000
    ];
    if (!array_key_exists($tieuDe, $bangGia)) {
        throw new Exception("Sách không hợp lệ.");
    }
    $gia = $bangGia[$tieuDe];
    // ghi cookie trong 7 ngày 
    setcookie('khach_hang_email', $email, time() + (86400 * 7), "/");
    // tạo giỏ hàng nếu chưa có
    if (!isset($_SESSION['gio_hang'])) {
        $_SESSION['gio_hang'] = [];
    }
    // công dồn sách nếu đã có
    $da_co = false;
    foreach ($_SESSION['gio_hang'] as &$sp) {
        if ($sp['title'] === $tieuDe) {
            $sp['quantity'] += $soLuong;
            $da_co = true;
            break;
        }
    }
    if (!$da_co) {
        $_SESSION['gio_hang'][] = [
            'title' => $tieuDe,
            'quantity' => $soLuong,
            'price' => $gia
        ];
    }
    // tổng tiền
    $tongTien = 0;
    foreach ($_SESSION['gio_hang'] as $sach) {
        $tongTien += $sach['price'] * $sach['quantity'];
    }
    // ghi vào file JSON
    $don_hang = [
        'customer_email' => $email,
        'products' => $_SESSION['gio_hang'],
        'total_amount' => $tongTien,
        'created_at' => date("Y-m-d H:i:s")
    ];
    //  ghi vào file JSON
    // Ghi vào file JSON
    $json_data = json_encode($don_hang, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
    if (file_put_contents("CartData.json", $json_data) === false) {
        throw new Exception("Lỗi khi ghi vào file CartData.json");
    }
    header("Location: ViewCart.php");
} catch (Exception $e) {
    echo "<h3 style='color: red;'>Đã xảy ra lỗi: " . htmlspecialchars($e->getMessage()) . "</h3>";
    echo "<a href='index.php'>Quay lại</a>";
}
