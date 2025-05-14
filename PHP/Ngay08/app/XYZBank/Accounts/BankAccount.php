<?php
namespace App\XYZBank\Accounts;
// lớp nền tảng cho tất cả các loại tài khoản.
// chứa các thuộc tính và phương thức chung cho tất cả các loại tài khoản ngân hàng.
abstract class BankAccount {
    protected $accountNumber;
    protected $ownerName;
    protected $balance; 
    // contructor
    // khởi tạo các thuộc tính của lớp  
    public function __construct(string $accountNumber, string $ownerName, float $balance)
    {
        $this->accountNumber = $accountNumber;
        $this->ownerName = $ownerName;
        $this->balance = $balance;
    }
    // phướng thức trả về số dư tài khoản
    public function getBalance():float {
        return $this->balance;
    }
    // phương thức trả về tên chủ tài khoản
    public function getOwnerName():string{
        return $this->ownerName;
    }
    // phương thức trả về số tài khoản
    public function accountNumber():string{
        return $this->accountNumber;
    }

    abstract public function deposit($amount):void;
    abstract public function withdraw($amount):void;
    abstract public function getAccountType():string;

    
}