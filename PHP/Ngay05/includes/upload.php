<?php
// hàm xử lý upload file
function xuLyUploadFile($input_name = 'file_minh_chung'){
    if(!isset($_FILES[$input_name]) || $_FILES[$input_name]['error'] !== UPLOAD_ERR_OK){
        return null; // không có file hoặc có lỗi
    };
    $file = $_FILES[$input_name];
    $tenGoc = $file['name'];
    $kichThuoc = $file['size'];
    
    $duoiFile = strtolower(pathinfo($tenGoc, PATHINFO_EXTENSION));
    // danh sách định dạng cho phép
    $dinhDangChoPhep = ['jpg', 'jpeg', 'png', 'pdf'];
    // kiểm tra định dạng file
    if(!in_array($duoiFile, $dinhDangChoPhep)){
        return null; 
    }
    // kiểm tra kích thước file (tối đa 2MB)
    if($kichThuoc > 2 * 1024 * 1024){
        return null; 
    }
    // đổi tên file để tránh trùng lặp
    $tenMoi = 'upload_' . time() . '.' . basename($tenGoc);
    $duongDan = __DIR__ . '/../uploads/' . $tenMoi;
    // di chuyển file từ thư mục tạm đến thư mục uploads
    if(move_uploaded_file($file['tmp_name'], $duongDan)){
        return $tenMoi; // trả về tên file đã upload
    } else {
        return null; // không thể di chuyển file
    }
}