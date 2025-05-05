<?php
require_once 'data.php';
require_once 'functions.php';
//debug
echo "File: " . __FILE__ . " - Dòng: " . __LINE__ . "<br>";
// tính dữ liệu
// Tính tổng doanh thu từ danh sách đơn hàng
$doanhthu = 0;
$order_values = array_values($danh_sach_don_hang);
for ($i = 0; $i < count($order_values); $i++) {
    $doanhthu += $order_values[$i];
}
// $doanhthu = tongDoanhThu($product_price, $order_count);
$phihoahong = phiHoaHong($doanhthu);
$vat = vat($doanhthu);
$loinhuan = loiNhuan($doanhthu, $phihoahong, $vat);

// hiển thị thông tin

echo "Tên chiến dịch: $ten_chien_dich <br>";
echo "Trạng thái: " . ($trang_thai_chien_dich ? "Kết thúc" : "Đang chạy") . "<br>";
echo "Tổng doanh thu: $doanhthu USD <br>";
echo "Chi phí hoa hồng: $phihoahong USD <br>";
echo "Thuế VAT: $vat USD <br>";
echo "Lợi nhuận: $loinhuan USD <br>";

echo "Đánh giá:" . danhGia($loinhuan) . "<br>";

// Hiển thị thông tin theo loại sản phẩm
echo thongTinSanPham($loai_san_pham) . "<br>";

// chi tiết đơn hàng
echo "==|Chi tiết đơn hàng|== <br>";
foreach($danh_sach_don_hang as $id => $price){
    echo "Mã đơn hàng: $id - Giá trị: $price USD <br>";
}
// tb tổng kết
echo "Chiến dịch: " . $ten_chien_dich . " Đã " . 
    ($trang_thai_chien_dich ? "Kết thúc" : "Đang chạy") . " với lợi nhuận: $loinhuan USD";

?>