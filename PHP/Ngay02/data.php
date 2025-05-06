<?php 
    // danh sách người dùng 
    $users = [
        1 => ['name' => 'Duy', 'referrer_id' => null],
        2 => ['name' => 'Anh', 'referrer_id' => 1],
        3 => ['name' => 'Ly', 'referrer_id' => 2],
        4 => ['name' => 'Hon', 'referrer_id' => 3],
        5 => ['name' => 'Kong', 'referrer_id' => 1],
    ];
    // dữ liệu đơn hàng
    $orders = [
        ['order_id' => 101, 'user_id' => 4, 'amount' => 200.0],  
        ['order_id' => 102, 'user_id' => 3, 'amount' => 150.0],  
        ['order_id' => 103, 'user_id' => 5, 'amount' => 300.0], 
    ];

    // Tỷ lệ hoa hồng theo cấp 
    $commissionRates = [
        1 => 0.10,  // Cấp 1: 10%
        2 => 0.05,  // Cấp 2: 5%
        3 => 0.02,  // Cấp 3: 2%
    ];
    

?>