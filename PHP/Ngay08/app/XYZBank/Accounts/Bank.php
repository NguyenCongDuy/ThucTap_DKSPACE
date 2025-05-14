<?php
namespace App\XYZBank\Accounts;
    // lưu thông tin toàn cục của ngân hàng

    class Bank{
        public static int $totalAccounts = 0;

        public static function getBankName():string{
            return "Ngân hàng XYZ";
        } 
    }

?>