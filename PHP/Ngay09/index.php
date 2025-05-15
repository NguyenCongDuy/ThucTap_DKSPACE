<?php
require_once 'Funtions.php';
    // Thêm 5 sản phẩm mẫu và in ID
    // InsertDataProducts($pdo);

    // Thêm 3 đơn hàng mẫu
    // InsertOrders($pdo);  

    // thêm sản phẩm
    //  $SaPhamMoi = insertProducts($pdo, 'Quần', 60000, 40);

    // hiển thị toàn bộ sản phẩm
    $products = getAllDataProducts($pdo);
     echo "Hiển thị toàn bộ sản phẩm:<br>";

    // xem sản phẩm > 400k
    // $products = getProduct($pdo, 400.00);
    //  echo "Các sản phẩm > 400k:<br>";
    // print_r($products);

    // xem giá sản phẩm theo thứ tự giảm dần
    // $products = getProductByPricedesc($pdo);
    //  echo "Xem giá sản phẩm theo thứ tự giảm dần:<br>";

    // xóa sản phẩm theo id
    // deleteProductById($pdo, 6 );

    // cập nhật giá và tồn kho sản phẩm
    // updateProductById($pdo, 2, 46000, 75);
    // lấy 5 sản phẩm mới nhất 
    $products = getLatestProducts($pdo, 5);
    echo "5 sản phẩm mới nhất:<br>";
    // print_r($products);


    foreach ($products as $product) {
    echo 
        "ID: " . $product['id'] .
        " | Tên sản phẩm: " . $product['product_name'] .
        " | Giá: " . $product['unit_price'] .
        " | Số lượng: " . $product['stock_quantity'] .
        " | Ngày tạo: " . $product['created_at'] .
        "<br>";
    }
?>