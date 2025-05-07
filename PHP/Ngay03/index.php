<?php
require_once 'data.php';
require_once 'functions.php';

// tính ngày công 
$ngayCong = tinhNgayCong($timesheet);
// tính lương lĩnh
$luongThucLinh = tinhLuongLinh($employees, $timesheet, $adjustments);
// tạo báo cáo lương
$baoCaoLuong = taoBaoCaoLuong($employees, $timesheet, $adjustments);
// tìm nhân viên ngày công max min
$maxMin = tinNhanVienMaxMin($timesheet);
// lọc nhân viên ngày công >=  4
$nhanVienLoc = locNhanVienTheoNgayCong($timesheet);
// Hiển thị kết quả
echo "<h2>Bảng lương của nhân viên:</h2>";
echo "<table border='1'>
<tr>
    <th>ID</th>
    <th>Họ Tên</th>
    <th>Lương Cơ Bản</th>
    <th>Phụ Cấp</th>
    <th>Khấu Trừ</th>
     <th>Ngày Công</th>
    <th>Lương Thực Lĩnh</th>
</tr>";
foreach ($baoCaoLuong as $record) {
    echo "<tr>
    <td>{$record['employees']['id']}</td>
    <td>{$record['employees']['name']}</td>
    <td>{$record['employees']['base_salary']}</td>
    <td>{$record['phuCap']}</td>
    <td>{$record['khauTru']}</td>
    <td>{$record['ngayCong']}</td>
    <td>{$record['luongThucLinh']}</td>
    </tr>";
}
echo "</table>";

// Hiển thị nhân viên có ngày công cao nhất và thấp nhất
echo "<h2>Nhân viên có ngày công cao nhất:</h2>";
foreach ($maxMin['max'] as $id) {
    // Tìm nhân viên có ID tương ứng trong mảng $employees
    $employee = null;
    foreach ($employees as $emp) {
        if ($emp['id'] == $id) {
            $employee = $emp;
            break;
        }
    }
    echo "Nhân viên ID: $id - " . ($employee ? $employee['name'] : 'Không tìm thấy') . "<br>";
}

echo "<h2>Nhân viên có ngày công thấp nhất:</h2>";
foreach ($maxMin['min'] as $id) {
    // Tìm nhân viên có ID tương ứng trong mảng $employees
    $employee = null;
    foreach ($employees as $emp) {
        if ($emp['id'] == $id) {
            $employee = $emp;
            break;
        }
    }
    echo "Nhân viên ID: $id - " . ($employee ? $employee['name'] : 'Không tìm thấy') . "<br>";
}

// hiển thị nhân viên có ngày công ≥ 4
echo "<h2>Nhân viên có ngày công ≥ 4:</h2>";
foreach ($nhanVienLoc as $id => $days) {
    // Tìm nhân viên có ID tương ứng trong mảng $employees
    $employee = null;
    foreach ($employees as $emp) {
        if ($emp['id'] == $id) {
            $employee = $emp;
            break;
        }
    }
    echo "Nhân viên ID: $id - " . ($employee ? $employee['name'] : 'Không tìm thấy') . "<br>";
}

// Kiểm tra nhân viên có đi làm vào một ngày cụ thể
$date = '2025-03-03';
echo "<h2>Kiểm tra nhân viên có đi làm vào ngày $date:</h2>";
foreach ($employees as $employee) {
    echo $employee['name'] . ": " . kiemTraNgayLam($timesheet, $employee['id'], $date) . "<br>";
}

// Kiểm tra phụ cấp của nhân viên
echo "<h2>Kiểm tra phụ cấp của nhân viên:</h2>";
foreach ($employees as $employee) {
    echo $employee['name'] . ": " . kiemTraPhuCap($adjustments, $employee['id']) . "<br>";
}

// thêm ngày công mới cho nhân viên 101
capNhatNhanVienTimesheet($timesheet, 101, 'add', '2025-05-06');
// print_r($timesheet) . "<br>";
// Gộp thêm danh sách ngày công mới cho nhân viên 103
capNhatNhanVienTimesheet($timesheet, 103, 'merge', ['2025-03-10', '2025-03-11']);
// print_r($timesheet) . "<br>";
// Thêm ngày công vào đầu danh sách cho nhân viên 101
capNhatNhanVienTimesheet($timesheet, 101, 'add_first', '2025-05-07');
// print_r($timesheet) . "<br>";
// Loại bỏ ngày công cuối cùng cho nhân viên 102
capNhatNhanVienTimesheet($timesheet, 102, 'remove_last');
// print_r($timesheet) . "<br>";
// Loại bỏ ngày công đầu tiên cho nhân viên 103
capNhatNhanVienTimesheet($timesheet, 103, 'remove_first');
// print_r($timesheet) . "<br>";

