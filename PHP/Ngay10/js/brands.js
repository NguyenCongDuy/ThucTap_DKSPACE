// hàm loadBrands nhận tên category
function loadBrands(category) {
    // gọi fetch đến brands.php, truyền category qua url
    fetch(`php/brands.php?category=${encodeURIComponent(category)}`)
        .then(res => res.text())  // Nhận phản hồi dạng text (HTML)
        .then(html => {
            // đổ danh sách option vào select có id brandsSelect
            document.getElementById('brandsSelect').innerHTML = html;
        })
        .catch(err => {
            // nếu lỗi, hiển thị option lỗi
            document.getElementById('brandsSelect').innerHTML = '<option>Lỗi tải thương hiệu</option>';
            console.error(err);
        });
}