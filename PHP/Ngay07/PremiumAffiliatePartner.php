<?php
require_once 'AffiliatePartner.php';
// lớp đại diện cho cộng tác viên cao cấp
    class PremiumAffiliatePartner extends AffiliatePartner
    {
        private $bonusPerOrder;
        // gọi constructor của cha và khởi tạo thêm thuộc tính bonusPerOrder
        public function __construct($name, $email, $comissionRate, $bonusPerOrder, $isActive = true)
        {
            // gọi constructor của cha
            parent::__construct($name, $email, $comissionRate, $isActive);
            $this->bonusPerOrder = $bonusPerOrder;
        }
        // override phương thức tính hoa hồng
        public function calculateCommission($orderValue){
            // tính hoa hồng gốc từ cha 
            $baseComisson = parent::calculateComission($orderValue);
            // tính hoa hồng thêm từ bonusPerOrder
            return $baseComisson + $this->bonusPerOrder;
        }
        public function getSummary()
        {
            // gọi phương thức getSummary của cha
            $summary = parent::getSummary();
            // thêm thông tin bonusPerOrder vào
            $summary .= "Tiền thưởng mỗi đơn hàng: {$this->bonusPerOrder} VNĐ <br>";
            return $summary;
        }
        public function __destruct()
        {
            // gọi phương thức hủy của cha
            parent::__destruct();
            echo "Công tác viên cao cấp đã bị hủy. <br>";
        }
    }


?>