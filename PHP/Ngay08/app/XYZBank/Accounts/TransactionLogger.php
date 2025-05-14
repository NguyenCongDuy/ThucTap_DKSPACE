<?php
namespace App\XYZBank\Accounts;
//Ghi log giao dịch
    trait TransactionLogger{
    // phương thức ghi lại giao dịch
    public function logTransaction(string $type, float $amount, float $newBalance):void{
        // lấy thời gian hiện tại
        $time = date('Y-m-d H:i:s');
         echo "[{$time}] Giao dịch: {$type} {$amount} VNĐ | Số dư mới: {$newBalance} VNĐ <br>";
    }
}

?>