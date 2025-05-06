<?php
// hàm lấy tỷ lệ hoa hồng tương ứng với cấp độ
function layTyLeHoaHong(int $cap, array $commissionRates = [ 1 => 0.10,  2 => 0.05, 3 => 0.02 ]): float{
    return $commissionRates[$cap] ?? 0.0;
}
// hàm tìm chuỗi người giới thiệu
function timNguoiGioiThieu(int $user_id, array $user, int $commissionRates = 3) : array {
    static $ket_qua = []; // sử dụng để lưu kết quả trong quá trình đệ quy
    $cap = count($ket_qua) + 1;
    // kiểm tra và dừng lại khi đã truy đủ cấp hoặc không còn chuỗi giới thiệu
    if ($cap > $commissionRates || !isset($user[$user_id]['referrer_id'])) {
        return $ket_qua;
    }
    // đệ quy để nếu người mua có người giới thiệu thì lưu id đó vào mảng 
    // theo cấp rồi gọi để quy tiếp tục
    $nguoi_gioi_thieu_id = $user[$user_id]['referrer_id'];

    if ($nguoi_gioi_thieu_id !== null) {
        $ket_qua[$cap] = $nguoi_gioi_thieu_id;
        timNguoiGioiThieu($nguoi_gioi_thieu_id, $user, $commissionRates);
    }

    return $ket_qua;

}
// hàm xử lý hoa hồng từ đơn hàng
// Hàm chính để tính hoa hồng
function tinhHoaHongTuDon(...$orders): array {
    global $users, $commissionRates;
    $danh_sach_hoa_hong = [];

    foreach ($orders as $don) {
        $nguoi_mua_id = $don['user_id'];
        $so_tien = $don['amount'];
        $nguoi_gioi_thieu_theo_cap = timNguoiGioiThieu($nguoi_mua_id, $users);

        foreach ($nguoi_gioi_thieu_theo_cap as $cap => $nguoi_gioi_thieu_id) {
            $ty_le = layTyLeHoaHong($cap, $commissionRates);
            $tien_hoa_hong = $so_tien * $ty_le;

            $danh_sach_hoa_hong[] = [
                'nguoi_nhan' => $nguoi_gioi_thieu_id,
                'ten_nguoi_nhan' => $users[$nguoi_gioi_thieu_id]['name'],
                'tu_don' => $don['order_id'],
                'nguoi_mua' => $users[$nguoi_mua_id]['name'],
                'cap' => $cap,
                'so_tien_hoa_hong' => round($tien_hoa_hong, 2)
            ];
        }
    }
    return $danh_sach_hoa_hong;
}

 // ham tính tổng hoa hồng cho người dùng
 function tinhHoaHongTheoNguoi(array $danh_sach_hoa_hong ): array { 
    return array_reduce($danh_sach_hoa_hong, function ($ket_qua, $muc_hoa_hong){
        $id = $muc_hoa_hong['nguoi_nhan'];
        if(!isset($ket_qua[$id])){
            $ket_qua[$id] = 0;
        }
        $ket_qua[$id] += $muc_hoa_hong['so_tien_hoa_hong'];
        return $ket_qua; 
    }, []);
 }

 // log mẫu - hàm khong co tham số
 function ghiLog() {
    echo "[LOG] Hệ thống sử lý thành công !!!!!";
 }
