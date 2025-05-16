<?php

// Xử lý AJAX lấy danh sách thương hiệu từ XML dựa theo ngành hàng

header('Content-Type: text/html; charset=utf-8'); // Trả về HTML

// Kiểm tra tham số category gửi lên (GET)
if (!isset($_GET['category'])) {
    echo '<option value="">Chọn thương hiệu</option>';
    exit;
}

// Lấy category và chuyển thành chữ thường để so sánh dễ hơn
$category = strtolower($_GET['category']);

// Đọc file XML brands.xml
$xml = simplexml_load_file('../data/brands.xml');

// Khởi tạo biến chứa HTML
$options = '';

// Lặp qua từng brand trong XML
foreach ($xml->brand as $brand) {
    // Lấy category trong XML và chuyển thành chữ thường
    $brand_category = strtolower((string)$brand->category);

    // So sánh category trong XML với category yêu cầu (không phân biệt hoa thường)
    if ($brand_category === $category) {
        // Thêm option vào danh sách
        $options .= '<option value="' . htmlspecialchars((string)$brand->name) . '">' . htmlspecialchars((string)$brand->name) . '</option>';
    }
}

// Nếu không có thương hiệu nào khớp, thêm thông báo
if ($options === '') {
    $options = '<option value="">Không có thương hiệu phù hợp</option>';
}

echo $options;

?>