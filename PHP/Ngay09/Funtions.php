<?php
    require_once 'db.php';

    // hàm thêm 5 sản phẩm vào bảng products sau khi thêm in ra lastInsertId
    function InsertDataProducts($pdo) {
        // mảng chứa dữ liệu 5 sản phẩm
        $products = [
            ['product_name' => 'Sản phẩm A', 'unit_price' => 100.00, 'stock_quantity' => 10],
            ['product_name' => 'Sản phẩm B', 'unit_price' => 200.00, 'stock_quantity' => 20],
            ['product_name' => 'Sản phẩm C', 'unit_price' => 300.00, 'stock_quantity' => 30],
            ['product_name' => 'Sản phẩm D', 'unit_price' => 400.00, 'stock_quantity' => 40],
            ['product_name' => 'Sản phẩm E', 'unit_price' => 500.00, 'stock_quantity' => 50],
        ];

        foreach ($products as $product) {
            $stmt = $pdo->prepare("INSERT INTO products (product_name, unit_price, stock_quantity, created_at)
                                   VALUES (?,?,?, now())");
                                   
             $stmt->execute([ $product['product_name'],
                              $product['unit_price'],
                              $product['stock_quantity'],
        ]);

            echo "Thêm sản phẩm: " . $product['product_name'] . " với ID: " . $pdo->lastInsertId() . "<br>";
        }
    }

    // thêm 3 đơn hàng mỗi đơn 2 sản phẩm
    function InsertOrders(PDO $pdo){
        $orders = [
            ['order_date' => '2025-05-15',
            'customer_name' => 'Nguyen Van A',
            'note' => 'Giao hàng nhanh',
            'items' => [
                ['product_id' => 1, 'quantity' => 2, 'price' => 35000],
                ['product_id' => 3, 'quantity' => 1, 'price' => 50000],
            ],
        ],
            ['order_date' => '2025-05-15',
            'customer_name' => 'Nguyen Van C',
            'note' => 'Giao hàng',
            'items' => [
                ['product_id' => 2, 'quantity' => 3, 'price' => 45000],
                ['product_id' => 4, 'quantity' => 2, 'price' => 55000],
            ],
        ],

             ['order_date' => '2025-05-15',
            'customer_name' => 'Nguyen Thi D',
            'note' => 'Thanh toán khi nhận hàng',
            'items' => [
                ['product_id' => 3, 'quantity' => 2, 'price' => 50000],
                ['product_id' => 1, 'quantity' => 1, 'price' => 35000],
            ],
        ],
        
    ];
    foreach ($orders as $order){
        // thêm đơn hàng
        $stmt = $pdo->prepare("INSERT INTO orders (order_date, customer_name, note)
                                VALUES (?, ?, ?)");
        $stmt->execute([$order['order_date'], $order['customer_name'], $order['note']]);    
        $orderId = $pdo->lastInsertId();
        // thêm các sản phẩm vào đơn hàng
        $stmtItem = $pdo->prepare("INSERT INTO order_items (order_id, product_id, quantity, price_at_order_time)
                                VALUES (?, ?, ?, ?)");
        foreach ($order['items'] as $item) {
            $stmtItem->execute([$orderId, $item['product_id'], $item['quantity'], $item['price']]);
        }
         echo "Thêm đơn hàng ID $orderId của khách {$order['customer_name']}<br>";
    }
    }

    // thêm sản phẩm mới bằng Prepared Statement (sử dụng tham số).
    function InsertProducts(PDO $pdo, $name, $price, $stock) {

    $stmt = $pdo->prepare("INSERT INTO products (product_name, unit_price, stock_quantity, created_at) 
                           VALUES (:name, :price, :stock, NOW())");
                           
    $stmt->execute([ ':name' => $name,':price' => $price,':stock' => $stock ]);
        echo "Thêm sản phẩm thành công với id:" . $pdo->lastInsertId() . "<br>";
    }
    // hiển thị toàn bộ sản phẩm
    function getAllDataProducts($pdo){
        $stmt = $pdo->query("SELECT * FROM products");
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    // Lọc sản phẩm có giá > 400.000 VNĐ
     function getProduct($pdo, $price){
        $stmt = $pdo->prepare("SELECT * FROM products WHERE unit_price > ?");
        $stmt->execute([$price]);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
    // hiển thị sản phẩm theo giá giảm dần
     function getProductByPricedesc(PDO $pdo){
        $stmt = $pdo->query("SELECT * FROM products ORDER BY unit_price DESC");
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }
    // xóa sản phẩm theo id
    function deleteProductById(PDO $pdo, $id){
        $stmt = $pdo->prepare("DELETE FROM products WHERE id = ?");
        $stmt->execute([$id]);
    }
    // cập nhật giá và tồn kho sản phẩm
    function updateProductById(PDO $pdo, $id, $newPrice, $newStock){
         $stmt = $pdo->prepare("UPDATE products SET unit_price = ?, stock_quantity = ? WHERE id = ?");
        return $stmt->execute([$newPrice, $newStock, $id]);
    }
    function getLatestProducts(PDO $pdo, $limit = 5) {
    $stmt = $pdo->prepare("SELECT * FROM products ORDER BY created_at DESC LIMIT ?");
    $stmt->bindValue(1, (int)$limit, PDO::PARAM_INT);
    $stmt->execute();
    return $stmt->fetchAll(PDO::FETCH_ASSOC);
}




?>