// hàm loadReviews reviews nhận product id là tham số
function loadReviews(productId) {
    // gọi fetch đến file reviews.php, truyền product_id qua URL
    fetch(`./php/reviews.php?product_id=${encodeURIComponent(productId)}`)
        .then(res => res.json()) // chuyển đổi dữ liệu nhận được thành định dạng JSON
        .then(data => {
            // lấy phần chứa đánh giá trong DOM
            const reviewsContainer = document.getElementById('reviewsContainer');
            // nếu sever trả lỗi -> hiển thị lỗi    
            if (data.error) {
                reviewsContainer.innerHTML = `<p class="error">${data.error}</p>`;
                return;
            }
            // nếu không có đánh giá nào -> hiển thị thông báo
            if (data.length === 0) {
                reviewsContainer.innerHTML = `<p class="no-reviews">Sản phẩm chưa có đánh giá</p>`;
                return;
            }

            // tạo chuỗi html để hiển thị các đánh giá
            const html = data.map(r => `
            <div class="review">
                <p>${r.user}</p> - 
                <span>Điểm: ${r.rating}/5</span><br>
                <p>${r.content}</p>
                <small>${r.time}</small>
            </div>
            <hr>
            `).join(''); // nối thành chuỗi
            // hiển thị đánh giá
            reviewsContainer.innerHTML = html;
        })
        .catch(err => {
            // nếu có lỗi khi gọi fetch, hiển thị lỗi 
            document.getElementById('reviewsContainer').innerHTML = '<p>Lỗi tải đánh giá.</p>';
            console.error(err);
        });
}