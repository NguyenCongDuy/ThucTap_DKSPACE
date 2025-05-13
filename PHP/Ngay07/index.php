<?php
require_once 'AffiliatePartner.php';
require_once 'PremiumAffiliatePartner.php';     
require_once 'AffiliateManager.php';
// khởi tạo hệ thống quản lý cộng tác viên
$manager = new AffiliateManager();
// tạo cộng tác viên thường
$affiliate1 = new AffiliatePartner("Nguyễn Công Duy", "congduy130605@gmail.com", 5);
$affiliate2 = new AffiliatePartner("Cao Thế Anh", "anhct@gmail.com", 4);
// tạo cộng tác viên cao cấp
$premiumAffiliate1 = new PremiumAffiliatePartner("Thiều Thu Trang", "trangtt@gmail.com", 8, 150000);
// thêm cộng tác viên vào hệ thống
$manager->addPartner($affiliate1);  
$manager->addPartner($affiliate2);
$manager->addPartner($premiumAffiliate1);
// in ra danh sách cộng tác viên
echo "<h2>Danh sách cộng tác viên</h2>";
$manager->listPartners();
// giả sử mỗi cộng tác viên đều thực hiện thành công một đơn hàng trị giá 2.000.000 VNĐ
$orderValue = 2000000;  
echo " HOA HỒNG TỪ ĐƠN HÀNG GIÁ TRỊ " . number_format($orderValue) . " VNĐ <br>";
// tính tổng hoa hồng
$manager->totalCommission($orderValue);

?>