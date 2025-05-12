<?php
// cookies
// setcookie(name, value, expire, path, domain, secure, httponly);
// setcookie("ten_nguoi_dung", "Duy", time() + 3600); // Lưu cookie 1 tiếng

// khởi tạo session
// session_start();

// Gán session
// session_start();
// $_SESSION['ten'] = 'Duy';
// $_SESSION['vai_tro'] = 'admin';

// Hiển thị session
// session_start();
// echo $_SESSION['ten']; // Duy

// xóa 1 biến session 
// unset($_SESSION['ten']);
// xóa toàn bộ session 
// session_destroy();

// try - catch - finally
try {
    // Đoạn code có thể gây lỗi
} catch (Exception $e) {
    // Bắt và xử lý lỗi
} finally {
    // Luôn thực thi (dù có lỗi hay không)
}
