<?php
require_once __DIR__ . '/includes/header.php';
if($_SERVER['REQUEST_METHOD'] === 'POST') {
    $ngay = $_POST['date'] ?? '';
    $tenFile = __DIR__ . '/logs/log_' . $ngay . '.txt';
    if (file_exists($tenFile)) {
        $noiDung = file_get_contents($tenFile);
        echo "<h3>Nội dung nhật ký ngày {$ngay}:</h3>";
        echo "<pre>{$noiDung}</pre>";
    } else {
        echo "<p style='color: red;'>Không tìm thấy nhật ký cho ngày {$ngay}.</p>";
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <h2>Xem nhật ký theo ngày</h2>
    <form action="" method="POST">
        <label>Chọn Ngày</label>
        <input type="date" name="date" placeholder="YYYY-MM-DD">
        <input type="submit" value="Xem nhật ký">
    </form>
    <hr>
    <a href="index.php">← Quay lại ghi nhật ký</a>
</body>
</html>