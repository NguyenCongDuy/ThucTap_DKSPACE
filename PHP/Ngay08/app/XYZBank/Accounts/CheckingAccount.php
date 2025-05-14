<?php
    namespace App\XYZBank\Accounts;

    use App\XYZBank\Accounts\BankAccount;
    use App\XYZBank\Accounts\TransactionLogger;
    // tài khoản thanh toán, không giới hạn rút, không sinh lãi.
    class CheckingAccount extends BankAccount{
        // sử dụng trait TransactionLogger để ghi lại giao dịch
        use TransactionLogger;

        public function deposit($amount): void
        {
            $this->balance += $amount;
            $this->logTransaction('Gửi tiền', $amount, $this->balance);
        }

        public function withdraw($amount): void
        {
            if($amount <= $this->balance){
                $this->balance -= $amount;
                $this->logTransaction('Rút tiền', $amount, $this->balance);
            }else{
                echo "Khong du tien de rut";
            }
        }

        public function getAccountType(): string
        {
            return "Tai khoan thanh toan";
        }
    }


?>