<?php
require 'vendor/autoload.php';


use App\XYZBank\Accounts\SavingsAccount;
use App\XYZBank\Accounts\CheckingAccount;
use App\XYZBank\Accounts\AccountCollection;
use App\XYZBank\Accounts\Bank;

// tạo danh sách tài khoản
$accountList = new AccountCollection(); 

// tạo tài khoản tiết kiệm
$acc1 = new SavingsAccount("01213A12","Nguyen Van A", 20000000);
Bank::$totalAccounts++;
$accountList->addAccount($acc1);

// tạo 2 tài khoản thanh toán
$acc2 = new CheckingAccount("20301123", "Lê Văn B", 8000000);
Bank::$totalAccounts++;
$accountList->addAccount($acc2);

$acc3 = new CheckingAccount("20401124", "Trần Minh C", 12000000);
Bank::$totalAccounts++;
$accountList->addAccount($acc3);


// tính lãi suất cho A
echo "Lãi xuất hàng năm cho {$acc1->getOwnerName()}: " . $acc1->calculateAnnualInterest() . "<br>";

// in ra danh sách tài khoản
echo "Danh sách tài khoản ngân hàng: <br>";
foreach ($accountList as $account) {
    echo "Tài khoản: {$account->accountNumber()} | ";
    echo "{$account->getOwnerName()} | ";
    echo "Loại: {$account->getAccountType()} | ";
    echo "Số dư: " . number_format($account->getBalance()) . " VNĐ <br>";
}
// in ra tổng tài khoản
echo "<br>Tổng số tài khoản ngân hàng: " . Bank::$totalAccounts . "<br>  <hr>";

//in ra tài khoản có số dư lớn hơn 10 triệu
echo "Danh sách tài khoản có số dư lớn hơn 10 triệu: <br>"; 

$filteredAccounts = $accountList->filtterAccounts();
foreach($filteredAccounts as $account){
    echo "Số tài khoản: " . $account->accountNumber() . "<br>";
    echo "Tên chủ tài khoản: " . $account->getOwnerName() . "<br>";
    echo "Số dư tài khoản: " . $account->getBalance() . "<br>";
    echo "Loại tài khoản: " . $account->getAccountType() . "<br>";
    echo "<hr>";
}

// in ra tên ngân hàng
echo "Tên ngân hàng: " . Bank::getBankName() . "<br>";


// gửi 5tr vào B 
$acc2->deposit(5000000);
// rút 2tr từ C
$acc3->withdraw(2000000);

?>