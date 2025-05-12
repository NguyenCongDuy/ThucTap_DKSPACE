<?php
// Đọc dữ liệu từ file JSON
$json_file = "CartData.json";
if (file_exists($json_file)) {
    $json_data = file_get_contents($json_file);
    $du_lieu_gio = json_decode($json_data, true);
} else {
    $du_lieu_gio = null;
}

// Kiểm tra dữ liệu
if (!$du_lieu_gio || !isset($du_lieu_gio['products'])) {
    echo "<h3 style='color: red;'>Không có dữ liệu giỏ hàng.</h3>";
    exit;
}

?>
<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>Xác nhận đơn hàng</title>
</head>

<body>
    <h3>Thông tin khách hàng</h3>
    <p>Email: <?= htmlspecialchars($du_lieu_gio['customer_email']) ?></p>
    <p>Thời gian đặt hàng: <?= htmlspecialchars($du_lieu_gio['created_at']) ?></p>

    <h3>Danh sách sách đã chọn:</h3>
    <table border="1" cellpadding="8" cellspacing="0">
        <thead>
            <tr>
                <th>Tên sách</th>
                <th>Đơn giá (VND)</th>
                <th>Số lượng</th>
                <th>Thành tiền (VND)</th>
            </tr>
        </thead>
        <tbody>
            <?php foreach ($du_lieu_gio['products'] as $sach): ?>
                <tr>
                    <td><?= htmlspecialchars($sach['title']) ?></td>
                    <td><?= number_format($sach['price']) ?></td>
                    <td><?= htmlspecialchars($sach['quantity']) ?></td>
                    <td><?= number_format($sach['price'] * $sach['quantity']) ?></td>
                </tr>
            <?php endforeach; ?>
        </tbody>
    </table>

    <h3>Tổng thanh toán: <?= number_format($du_lieu_gio['total_amount']) ?> VND</h3>

    <br>
    <form action="DeleteCart.php" method="post">
        <button type="submit" onclick="return confirm('Bạn có chắc muốn xóa giỏ hàng?')">🗑 Xóa giỏ hàng</button>
    </form>

    <br><a href="index.php">🔁 Tiếp tục mua</a>
</body>

</html>