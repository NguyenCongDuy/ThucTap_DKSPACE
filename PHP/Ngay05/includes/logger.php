<?php
function ghiNhatKy($mo_ta, $file_minh_chung = null){
    // lấy ngày hiện tại
    $ngayHienTai = date('Y-m-d');
    $gioHienTai = date('H:i:s');
    $ip = $_SERVER['REMOTE_ADDR'];
    // tạo đường dẫn file log theo ngày
    $tenFile = __DIR__ . '/../logs/log_' . $ngayHienTai . '.txt';
    // chuỗi log cần ghi
    $dongLog = "[{$gioHienTai}] - IP: {$ip} - Mô tả hành động: {$mo_ta}";
    // nếu có file minh chứng thì thêm vào chuỗi log
    if ($file_minh_chung) {
        $tenFileMinhChung = __DIR__ . '/../uploads/' . $file_minh_chung;
        $dongLog .= " - File minh chứng: {$tenFileMinhChung}";
    }
    $dongLog .= PHP_EOL;
    // ghi log vào file
    file_put_contents($tenFile, $dongLog, FILE_APPEND);

}