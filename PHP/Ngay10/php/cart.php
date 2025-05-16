    <?php
session_start();

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['id'])) {
    $id = (int)$_POST['id'];
    // kiểm ra nếu chưa có giỏ hàng thì khởi tạo mảng rỗng
    if (!isset($_SESSION['cart'])) {
        $_SESSION['cart'] = [];
    }
    // kiểm tra nếu sản phẩm đã có trong giỏ hàng thì tăng số lượng lên 1
    // nếu chưa có thì thêm vào giỏ hàng với số lượng là 1
    if (isset($_SESSION['cart'][$id])) {
        $_SESSION['cart'][$id]++;
    } else {
        $_SESSION['cart'][$id] = 1;
    }
    
    $tongSoLuong = array_sum($_SESSION['cart']);
// trả về JSON thông báo thành công và trả tổng số sản phẩm trong giỏ (cartCount).
    echo json_encode([
        'success' => true,
        'cartCount' => $tongSoLuong
    ]);
} else {
    echo json_encode([
        'success' => false
    ]);
}
?>