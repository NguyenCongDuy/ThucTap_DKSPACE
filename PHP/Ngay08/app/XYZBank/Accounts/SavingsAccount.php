<?php
    namespace App\XYZBank\Accounts;
    use App\XYZBank\Accounts\BankAccount;
    use App\XYZBank\Accounts\InterestBearing;
    use App\XYZBank\Accounts\TransactionLogger;

    // tài khoản tiết kiệm có sinh lãi suất và hạn chế rút
    class SavingsAccount extends BankAccount implements InterestBearing {

        use TransactionLogger;

        private const LAI_XUAT_MAC_DINH = 0.05;
        private const SO_DU_TOI_THIEU = 1000000;
        
        // phương thức gửi tiền
        public function deposit($amount): void
        {
            $this->balance += $amount;
            $this->logTransaction('Gửi tiền', $amount, $this->balance);
        }
        // phương thức rút tiền
        public function withdraw($amount): void
        {
            if(($this->balance - $amount) >= self::SO_DU_TOI_THIEU){
                $this->balance -= $amount;
                $this->logTransaction("Rut tiền", $amount, $this->balance);
            }else  {
                echo "Khong du tien de rut";
            }
        }
        
        public function getAccountType(): string
        {
            return "Tiett kiem";
        }
        // phương thức tính lãi suất hàng năm
        public function calculateAnnualInterest(): float
        {
            return $this->balance * self::LAI_XUAT_MAC_DINH;
        }
    }


?>