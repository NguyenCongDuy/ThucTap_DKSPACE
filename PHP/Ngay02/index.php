<?php
require_once 'data.php';
require_once 'functions.php';

// tính hoa hồng từ đơn hàng
$danh_sach_hoa_hong  = tinhHoaHongTuDon(...$orders);
// in ra kết quả

foreach ($danh_sach_hoa_hong as $mucHH){
    echo "Người Nhận: {$mucHH['ten_nguoi_nhan']} -  ID: {$mucHH['nguoi_nhan']} <br>";
    echo "  - Nhận từ đơn hàng ID {$mucHH['tu_don']} của {$mucHH['nguoi_mua']} <br>";
    echo "  - Cấp {$mucHH['cap']}, Hoa hồng: {$mucHH['so_tien_hoa_hong']} VND <br>";
}

// hoa hồng theo từng người
$tong_hoa_theo_nguoi = tinhHoaHongTheoNguoi($danh_sach_hoa_hong);
foreach($tong_hoa_theo_nguoi as $user_id => $tongTien){
    echo "Người nhận: {$users[$user_id]['name']} (ID: $user_id) => Tổng tiền hoa hồng: $tongTien VND <br>";
}

ghiLog();



?>
