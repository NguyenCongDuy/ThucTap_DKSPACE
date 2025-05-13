<?php
    class AffiliateManager
    {
        // mảng lưu danh sách cộng tác viên
        private $partners = [];
        // thêm một công tác viên vào danh sách
        public function addPartner($affiliate){
            $this->partners[] = $affiliate;
        }
        // in ra thông tin của tất cả cộng tác viên
        public function listPartners(){
            foreach($this->partners as $partner){
                echo $partner->getSummary();
            }
        }
        // Tính tổng hoa hồng nếu mỗi CTV đều thực hiện thành công một đơn hàng trị giá $orderValue
        public function totalCommission($orderValue){
            $total = 0;
            foreach($this->partners as $partner){
                $total += $partner->calculateComission($orderValue);
            }
            echo "Tổng hoa hồng toàn hệ thống là: " . number_format($total) . " VNĐ <br>";
        }
    }

?>