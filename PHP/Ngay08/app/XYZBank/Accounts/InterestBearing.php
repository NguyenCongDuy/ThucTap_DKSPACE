<?php
namespace App\XYZBank\Accounts;

//  Interface InterestBearing
//  Dành cho các tài khoản có sinh lãi
    interface InterestBearing{
        
        public function calculateAnnualInterest():float;
    }