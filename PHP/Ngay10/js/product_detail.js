// hàm sẽ được gọi khi người dùng ckick và sản phẩm
    function layChiTietSanPham(idSanPham){
        // tạo đối tưong XMLHttpRequest
        var xhr = new XMLHttpRequest();

        // thiết lập phương thức get và url gửi kèm id sản phẩm (query string)
        xhr.open('GET', 'php/product_detail.php?id=' + idSanPham, true);
        // gắn sự kiện onload để xử lý khi server trả kết quả về thành công
        xhr.onload = function(){
            if(xhr.status === 200){
                // lấy nội dụng trả về và chèn vào div chiTietSanPham
                document.getElementById('chiTietSanPham').innerHTML = xhr.responseText;
            }else{
                // nếu có lỗi thì thông báo
                alert('Có lỗi xảy ra khi lấy chi tiết sản phẩm');
            }
        }
        // gửi request đi 
        xhr.send();
    }