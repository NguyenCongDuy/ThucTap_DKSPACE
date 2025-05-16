// hàm tìm kiếm sản phẩm khi người dùng gõ từ khóa
function liveSearch(keyword) {
    // Gọi fetch tới search.php truyền keyword
    fetch(`php/search.php?keyword=${encodeURIComponent(keyword)}`)
    .then(res => res.text())  // Nhận HTML fragment
    .then(html => {
        // Hiển thị kết quả vào div có id 'searchResult'
        document.getElementById('searchResult').innerHTML = html;
    })
    .catch(err => {
        // Nếu lỗi
        document.getElementById('searchResult').innerHTML = '<p>Lỗi tìm kiếm</p>';
        console.error(err);
    });
}

// optional debounce: giảm số lần gửi request khi người dùng gõ liên tục (giúp nhẹ server)
let debounceTimer;
function debounceSearch(keyword) {
    clearTimeout(debounceTimer);
    debounceTimer = setTimeout(() => {
        liveSearch(keyword);
    }, 300); // 300ms trễ
}