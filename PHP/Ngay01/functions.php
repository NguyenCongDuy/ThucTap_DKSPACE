<?php
    // tính tổng doanh thu 
    function tongDoanhThu($gia_san_pham, $so_luong_don_hang){
        return $gia_san_pham * $so_luong_don_hang;
    }
    // tính phí hoa hồng
    function phiHoaHong($doanhthu){
        return $doanhthu * COMMISSION_RATE;
    }
    function vat($doanhthu){
        return $doanhthu * VAT_RATE;
    }
    // tính lợi nhuận
    function loiNhuan($doanhthu, $phihoahong, $vat){
        return $doanhthu - $phihoahong - $vat;
    }
    // đánh giá chiến dịch 
    function danhGia($loinhuan){
        if($loinhuan > 0 ){
            return "Chiến dịch thành công";
        }else if($loinhuan = 0 ){
            return "Chiến dịch hòa vốn";
        }else{
            return "Chiến dịch thất bại";
        }
    }

    // hiển thị thong tin theo loại sản phẩm
    function thongTinSanPham($type){
        switch($type) {
            case "Điện tử":
                echo "Sản phẩm Điện tử có xu hướng cạnh tranh cao.\n ";
                break;
            case "Thời trang":
                echo "Sản phẩm Thời trang có doanh thu ổn định.\n ";
                break;
            case "Gia dụng":
                echo "Sản phẩm Gia dụng thường có doanh số theo mùa.\n";
                break;
            default:
            echo "Loại sản phẩm không xác định.\n";
        }
    }

?>