<?php
// bắt đầu làm việc để dùng session
session_start();
// khởi tạo session lưu giao dịch nếu chưa có
if (!isset($_SESSION['giao_dich'])) {
    $_SESSION['giao_dich'] = [];
}
// khởi tạo biến toàn cục để tính 
$GLOBALS['tong_thu'] = 0;
$GLOBALS['tong_chi'] = 0;
// nếu có dữ liệu được gửi từ form
// xử lý dữ form nếu phương thức gửi là POST 
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // lấy dữ liệu từ form 
    $tenGiaoDich = $_POST['transaction_name'] ?? '';
    $soTien = $_POST['amount'] ?? '';
    $loai = $_POST['transaction_type'] ?? '';
    $ghiChu = $_POST['note'] ?? '';
    $ngay = $_POST['date'] ?? '';

    $loi = [];
    // regex để kiểm tra tên giao dịch không có kí tự đặc biệt
    if (!preg_match('/^[\p{L}\d\s]+$/u', $tenGiaoDich)) {
        $loi[] = "Tên giao dịch không được chứa ký tự đặc biệt.";
    }
    // regex để kiểm tra số tiền là số dương
    if (!preg_match('/^\d+(\.\d{1,2})?$/', $soTien) || floatval($soTien) <= 0) {
        $loi[] = "Số tiền phải là số dương và hợp lệ.";
    }
    // regex kiểm tra ngày định dạng 
    if (!preg_match('/^(0[1-9]|[12][0-9]|3[01])\/(0[1-9]|1[012])\/\d{4}$/', $ngay)) {
        $loi[] = "Ngày phải đúng định dạng dd/mm/yyyy.";
    }
    // Kiểm tra loại giao dịch
    if (!in_array($loai, ['thu', 'chi'])) {
        $loi[] = "Loại giao dịch phải là thu hoặc chi.";
    }
    // kiểm tra từ khóa nhạy cảm ở ghi chú
    $canhBao = '';
    $tuNhayCam = ['nợ xấu', 'vay nóng'];
    foreach ($tuNhayCam as $tu)
        if (stripos($ghiChu, $tu) !== false) {
            $canhBao = "Cảnh báo : ghi chú này chứ từ khóa nhạy cảm";
            break;
        }
    // nếu không có lỗi lưu vào session
    if (empty($loi)) {
        $giaoDich = [
            'ten' => $tenGiaoDich,
            'soTien' => floatval($soTien),
            'loai' => $loai,
            'ghiChu' => $ghiChu,
            'ngay' => $ngay,
            'canhBao' => $canhBao
        ];
        $_SESSION['giao_dich'][] = $giaoDich;
    }
}
// tính tổng thu chi từ session
foreach ($_SESSION['giao_dich'] as $gd) {
    if (isset($gd['loai']) && $gd['loai'] === 'thu') {
        $GLOBALS['tong_thu'] += $gd['soTien'] ?? 0;
    } elseif (isset($gd['loai']) && $gd['loai'] === 'chi') {
        $GLOBALS['tong_chi'] += $gd['soTien'] ?? 0;
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
    <!-- Hiển thị lỗi -->
    <?php if (!empty($loi)): ?>
        <div class="error">
            <ul>
                <?php foreach ($loi as $err): ?>
                    <li><?= htmlspecialchars($err) ?></li>
                <?php endforeach; ?>
            </ul>
        </div>
    <?php endif; ?>

    <!-- // form người dùng nhập giao dịch tài chính -->
    <h2>Nhập giao dịch tài chính</h2>
    <form action="<?= htmlspecialchars($_SERVER['PHP_SELF']) ?>" method="POST">
        <label>Tên Giao Dịch: <input type="text" name="transaction_name" require></label><br>
        <label>Số tiền: <input type="text" name="amount" require></label><br>
        <label>Loại giao dịch:</label>
        <input type="radio" name="transaction_type" value="thu" require> Thu
        <input type="radio" name="transaction_type" value="chi"> Chi
        <br>
        <label>Ghi chú: <textarea name="note" rows="3" id="" cols="30"></textarea></label><br>
        <label>Ngày thực hiện (dd/mm/yyyy): <input type="text" name="date" required></label>
        <button type="submit">Lưu Giao Dịch</button>


        <!-- Hiển thị bảng giao dịch -->
        <?php if (!empty($_SESSION['giao_dich'])): ?>
            <h3>Danh sách giao dịch đã nhập</h3>
            <table>
                <tr>
                    <th>STT</th>
                    <th>Tên giao dịch</th>
                    <th>Số tiền</th>
                    <th>Loại</th>
                    <th>Ngày</th>
                    <th>Ghi chú</th>
                    <th>Cảnh báo</th>
                </tr>
                <?php foreach ($_SESSION['giao_dich'] as $index => $gd): ?>
                    <tr>
                        <td><?= $index + 1 ?></td>
                        <td><?= htmlspecialchars($gd['ten'] ?? '') ?></td>
                        <td><?= number_format($gd['soTien'] ?? 0, 2) ?></td>
                        <td><?= ucfirst($gd['loai'] ?? '') ?></td>
                        <td><?= htmlspecialchars($gd['ngay'] ?? '') ?></td>
                        <td><?= htmlspecialchars($gd['ghiChu'] ?? '') ?></td>
                        <td class="warning"><?= htmlspecialchars($gd['canhBao'] ?? '') ?></td>
                    </tr>
                <?php endforeach; ?>
            </table>
            <h4>Thống kê:</h4>
            <ul>
                <li>Tổng thu: <strong><?= number_format($GLOBALS['tong_thu'], 2) ?></strong></li>
                <li>Tổng chi: <strong><?= number_format($GLOBALS['tong_chi'], 2) ?></strong></li>
                <li>Số dư: <strong><?= number_format($GLOBALS['tong_thu'] - $GLOBALS['tong_chi'], 2) ?></strong></li>
            </ul>
        <?php endif; ?>
    </form>
</body>

</html>