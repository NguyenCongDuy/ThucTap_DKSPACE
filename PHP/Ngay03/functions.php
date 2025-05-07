<?php
// hàm tính ngày công thực của nhân viên
function tinhNgayCong($timesheet)
{
    return array_map('count', $timesheet);
}

// hàm tính lương lĩnh của mỗi nhân viên
function tinhLuongLinh($employees, $timesheet, $adjustments)
{
    // duyệt qua từng nhân viên trong emloyees mỗi nhân viên được sử lý bằng 1 hàm ẩn danh
    return array_map(function ($employees) use ($timesheet, $adjustments) {
        // lấy id của nhân viên của timesheet để lấy ngày đi làm cũng như tính số ngày công 
        $ngayCong = count($timesheet[$employees['id']]);
        // phụ cấp và khấu trừ từ bảng adjusments với từng nhân viên
        $phuCap   = $adjustments[$employees['id']]['allowance'];
        $khauTru  = $adjustments[$employees['id']]['deduction'];
        // tính lương thực lĩnh
        $luongThuLinh = round(($employees['base_salary'] / 22) * $ngayCong + $phuCap - $khauTru);
        // trả mảng chứa cho mỗi phần tử nhân viên
        return [
            'id' => $employees['id'],
            'name' => $employees['name'],
            'base_salary' => $employees['base_salary'],
            'allowance' => $phuCap,
            'deduction' => $khauTru,
            'salary' => $luongThuLinh
        ];
    }, $employees);
}
// tạo báo cáo tổng hợp bảng lương
function taoBaoCaoLuong($employees, $timesheet, $adjustments)
{
    // duyệt qua từng nhân viên và xử lý, use cho phép sử dụng biến ngoài trong hàm ẩn danh
    return array_map(function ($employees) use ($timesheet, $adjustments) {
        // đếm số ngày đi làm bảng timesheet
        $ngayCong = count($timesheet[$employees['id']]);
        // lấy phụ cấp và khấu trừ
        $phuCap = $adjustments[$employees['id']]['allowance'];
        $khauTru = $adjustments[$employees['id']]['deduction'];
        // gọi hàm tính lương lĩnh , lấy phần tử đầu tiên [0] key salary
        $luongThucLinh = tinhLuongLinh([$employees], $timesheet, $adjustments)[0]['salary'];
        // gói 3 biến thành 1 kết quả
        return compact('employees', 'ngayCong','phuCap', 'khauTru', 'luongThucLinh');
    }, $employees);
}

// tìm nhân viên có ngày công cao nhất và thấp nhất
function tinNhanVienMaxMin($timesheet)
{
    // gọi hàm tinhNgayCong để đếm số công cho nhân viên
    $ngayCong = tinhNgayCong($timesheet);
    // lấy ra số công lớn nhất và nhỏ nhất của $ngayCong
    $maxNgayCong = max($ngayCong);
    $minNgayCong = min($ngayCong);
    // tìm tất cả các key (id nhân viên) trong ngayCong mà có giá trị max, min 
    $maxNhanVien = array_keys($ngayCong, $maxNgayCong);
    $minNhanVien = array_keys($ngayCong, $minNgayCong);
    return [
        'max' => $maxNhanVien,
        'min' => $minNhanVien
    ];
}

// cập nhật dữ liệu nhân viên và chấm công
function capNhatNhanVienTimesheet(&$timesheet, $id, $action, $date = null){
    switch ($action) {
        case 'add':
            // Thêm ngày công mới cho nhân viên
            if ($date) {
                // Kiểm tra nếu ngày công chưa tồn tại trong danh sách
                if (!in_array($date, $timesheet[$id])) {
                    // Thêm ngày công vào cuối danh sách
                    array_push($timesheet[$id], $date);
                }
            }
            break;
        case 'remove':
            // Loại bỏ ngày công khỏi danh sách nhân viên
            if ($date && ($key = array_search($date, $timesheet[$id])) !== false) {
                // Loại bỏ ngày công khỏi danh sách
                unset($timesheet[$id][$key]);
                // Đảm bảo không còn giá trị null trong mảng
                $timesheet[$id] = array_values($timesheet[$id]);
            }
            break;
        case 'merge':
            // Gộp danh sách nhân viên mới vào danh sách hiện tại
            // Nếu không có dữ liệu ngày công mới, bỏ qua
            if ($date && is_array($date)) {
                // Kết hợp mảng hiện tại với danh sách ngày công mới
                $timesheet[$id] = array_merge($timesheet[$id], $date);
                // Loại bỏ các giá trị trùng lặp
                $timesheet[$id] = array_unique($timesheet[$id]);
            }
            break;
        case 'add_first':
            // Thêm ngày công mới vào đầu danh sách
            if ($date) {
                // Kiểm tra nếu ngày công chưa tồn tại trong danh sách
                if (!in_array($date, $timesheet[$id])) {
                    // Thêm ngày công vào đầu danh sách
                    array_unshift($timesheet[$id], $date);
                }
            }
            break;
        case 'remove_last':
            // Loại bỏ ngày công cuối cùng trong danh sách
            array_pop($timesheet[$id]);
            break;
        case 'remove_first':
            // Loại bỏ ngày công đầu tiên trong danh sách
            array_shift($timesheet[$id]);
            break;
        default:
            break;
    }
}
// lọc dữ liệu nhân viên theo số ngày công >= 4
function locNhanVienTheoNgayCong($timesheet){
    return array_filter($timesheet, function($days){
        return count($days) >= 4;
    });
}
// kiểm tra nhân viên có đi làm ngày hôm nào đó hay không
function kiemTraNgayLam($timesheet, $id, $date){
    return in_array($date, $timesheet[$id]) ? "Có đi làm" : "Không đi làm";
}
// kiểm tra dữ liệu phụ cấp nhân viên
function kiemTraPhuCap($adjustments, $id){
    return array_key_exists($id, $adjustments) ? "Có phụ cấp" : "Không phụ cấp";
}

// hàm loại bỏ trùng lặp
function loaiBoTrungDuLieu(&$timesheet){
    foreach ($timesheet as $id => $date){
        // sử dụng array_unique
        $date = array_unique($date);
    }
}
