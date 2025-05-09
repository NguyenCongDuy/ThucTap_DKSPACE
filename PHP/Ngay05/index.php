<?php 
    require_once __DIR__ . '/includes/logger.php';
    require_once __DIR__ . '/includes/upload.php';
    require_once __DIR__ . '/includes/header.php';
    $thongBao = '';

    if($_SERVER['REQUEST_METHOD'] === 'POST'){
        $mo_ta = $_POST['mo_ta'];
        $file_minh_chung = xuLyUploadFile();
        if($file_minh_chung){
            ghiNhatKy($mo_ta, $file_minh_chung);
            $thongBao = 'Ghi nhật ký thành công!';
        } else {
            ghiNhatKy($mo_ta);
            $thongBao = 'Ghi nhật ký thành công nhưng không có file minh chứng!';
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
    <h2>Ghi nhật ký người dùng</h2>
    <form action="" method="POST" enctype="multipart/form-data">
        <label>Mô tả hành động</label>
        <input type="text" name="mo_ta" placeholder="Mô tả hành động"><br>
        <label>file minh chứng (tùy chọn):</label>
        <input type="file" name="file_minh_chung" accept=".jpg, .png, .pdf"> <br><hr>
        <button type="submit">Gửi</button>
    </form>
    <p style="color: red;"><?php echo $thongBao; ?></p>
    <a href="view_log.php">Xem nhật ký theo ngày</a>
</body>
</html>