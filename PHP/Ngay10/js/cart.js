
// hàm thêm sản phẩm vào giỏ hàng sử dụng AJAX POST (Fetch API)
function themVaoGio(idSanPham) {
    // Gửi POST request về cart.php (server xử lý thêm vào session)
    fetch('php/cart.php', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: 'id=' + encodeURIComponent(idSanPham)
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            // Cập nhật số lượng sản phẩm trong giỏ trên giao diện
            document.getElementById('cartCount').textContent = data.cartCount;
            alert('Đã thêm sản phẩm vào giỏ hàng');
        } else {
            alert('Thêm thất bại');
        }
    })
    .catch(error => console.error('Lỗi thêm vào giỏ hàng:', error));
}