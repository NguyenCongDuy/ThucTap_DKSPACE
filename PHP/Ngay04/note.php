<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
<!-- 
// cấu trúc của form cơ bản -->
<form method="POST" action="xu_ly.php">
    Họ tên: <input type="text" name="ho_ten">
    <button type="submit">Gửi</button>
</form>
<?php
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $hoTen = $_POST['ho_ten'];
    echo "Xin chào, $hoTen!";
}
?>
</body>
</html>