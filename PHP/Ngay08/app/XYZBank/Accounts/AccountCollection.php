<?php
namespace App\XYZBank\Accounts;

use InfiniteIterator;
use ArrayIterator;
use IteratorAggregate;

// quản lý danh sách tài khoản ngân hàng
class AccountCollection implements IteratorAggregate{
    private $account = [];

    public function addAccount(BankAccount $account): void
    {
        $this->account[] = $account;
    }
    public function getIterator(): ArrayIterator
    {
        return new ArrayIterator($this->account);
    }
    // lọc tài khoản có số dư lớn hơn 10 triệu
    public function filtterAccounts(): array
    {
        return array_filter($this->account, function( BankAccount $account){
            return $account->getBalance() > 10000000;
        });
    }

}
?>