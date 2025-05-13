<?php
// lớp đại diện cho cộng tác viên thường
class AffiliatePartner
{
    private $name;
    private $email;
    private $comissionRate;
    private $isActive;
    // hằng số platfrom name
    const PLATFROM_NAME = "VietLink Affiliate";
    // khởi tạo đối tượng đầy dủ thông tin
    public function __construct($name, $email, $comissionRate, $isActive = true)
    {
        $this->name = $name;
        $this->email = $email;
        $this->comissionRate = $comissionRate;
        $this->isActive = $isActive;
    }
    // phương thức tính hoa hồng
    public function calculateComission($orderValue)
    {
        return ($this->comissionRate / 100) * $orderValue;
    }
    // phương thức trả về thông tin của công tác viên 
    public function getSummary()
    {
        return  "Cộng tác viên: {$this->name} <br>" .
                "Email: {$this->email} <br>" .
                "Tỉ lệ hoa hồng: {$this->comissionRate}% <br>" .
                "Trạng thái: " . ($this->isActive ? "Đang hoạt động" : "Ngừng hoạt động") . "<br>" .
                "Nền tảng: " . self::PLATFROM_NAME . "<br>";
    }
    // destructor
    public function __destruct()
    {
        echo "Đối tượng " . $this->name . " đã bị hủy. <br>";
    }
}
