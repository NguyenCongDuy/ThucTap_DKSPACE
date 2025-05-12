<?php
session_start();

// danh sách giả lập 
$sach_mau = [
    ['title' => 'Books', 'price' => 20000],
    ['title' => 'Clean Code', 'price' => 10000],
    ['title' => 'Design Patterns', 'price' => 30000],
];

// lấy cookie khách hàng nếu có
$cookie_email = $_COOKIE['khach_hang_email'] ?? '';
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ hàng bán sách</title>
</head>

<body>
    <h2>Chọn sách</h2>
    <form action="AddToCart.php" method="POST">
          <select name="sach" id="sach">
            <?php foreach ($sach_mau as $sach): ?>
                <option value="<?= htmlspecialchars($sach['title']) ?>">
                    <?= $sach['title'] ?> - <?= number_format($sach['price']) ?> VND
                </option>
            <?php endforeach; ?>
        </select><br><br>
    <label>Số lượng</label>
    <input type="number" name="so_luong" value="1" min="1" require>
    <h2>Thông tin khách hàng</h2>
    <label>Email:</label>
    <input type="email" name="email" value="<?= htmlspecialchars($cookie_email) ?>">
    <label>Số điện thoại:</label>
    <input type="number" name="so_dien_thoai">
    <label>Địa chỉ giao hàng:</label>
    <textarea name="dia_chi" rows="4"></textarea>
    <button type="submit">Thêm vào giỏ</button>


    </form>
     <br>
    <a href="ViewCart.php">Xem giỏ hàng / Đặt hàng</a>
</body>

</html>