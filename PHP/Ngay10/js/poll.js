document.addEventListener('DOMContentLoaded', function() {
    const pollForm = document.getElementById('pollForm');
    if (pollForm) {
        // gắn sự kiện khi form được submit
        pollForm.addEventListener('submit', function(e) {
            // ngăn reload form
            e.preventDefault();
            const vote = pollForm.vote.value;
            // Dùng fetch gửi post request tới poll.php
            fetch('php/poll.php', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: 'vote=' + encodeURIComponent(vote)
            })
            // nhận json từ server trả về
            .then(res => res.text())
            .then(data => {
                document.getElementById('pollResult').innerHTML = data;
            })
            .catch(err => {
                document.getElementById('pollResult').innerHTML = 'Lỗi gửi bình chọn!';
            });
        });
    }
});
// hàm hiển thị kết quả poll
function hienThiKetQua(result, totalVotes) {
    let html = '<h3>Kết quả bình chọn</h3>';
    html += '<p>Tổng bình chọn: ' + totalVotes + '</p>';

    // lặp qua các mục và hiển thị phần trăm + bar chart đơn giản
    for (const key in result) {
        let label = '';
        if (key === 'giao_dien') label = 'Giao diện';
        if (key === 'toc_do') label = 'Tốc độ';
        if (key === 'dich_vu_khach_hang') label = 'Dịch vụ khách hàng';

        html += `<div>${label}: ${result[key]}%</div>`;
        html += `<div style="background: lightgray; width: 100%; height: 20px;">
                    <div style="background: green; width: ${result[key]}%; height: 100%;"></div>
                </div><br>`;
    }

    // cập nhật vào div pollResult
    document.getElementById('pollResult').innerHTML = html;
}
