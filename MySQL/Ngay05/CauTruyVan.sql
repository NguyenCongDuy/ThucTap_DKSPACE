--1. Stored Procedure:

DELIMITER //
-- Tạo stored procedure MakeBooking để đặt phòng
CREATE PROCEDURE MakeBooking (
    IN p_guest_id INT,        
    IN p_room_id INT,         
    IN p_check_in DATE,      
    IN p_check_out DATE     
)
BEGIN
    -- khai báo biến để lưu trạng thái phòng và số lượng lịch trùng
    DECLARE room_status VARCHAR(20);
    DECLARE conflict_count INT;

    -- lấy trạng thái phòng hiện tại từ bảng Rooms
    SELECT status INTO room_status
    FROM Rooms
    WHERE room_id = p_room_id;

    -- Kiểm tra xem có lịch đặt nào trùng với khoảng thời gian yêu cầu không
    SELECT COUNT(*) INTO conflict_count
    FROM Bookings
    WHERE room_id = p_room_id
      AND status = 'Confirmed' -- chỉ xét các booking đã xác nhận
      AND (
            (p_check_in < check_out AND p_check_out > check_in) -- điều kiện trùng lịch
         );

    -- nếu có ít nhất 1 lịch trùng thì báo lỗi và dừng thủ tục
    IF conflict_count > 0 THEN
        SIGNAL SQLSTATE '45001'
        SET MESSAGE_TEXT = 'Phòng đã được đặt trong khoảng thời gian này.';
    END IF;

    -- nếu phòng không phải là 'Available' thì báo lỗi và dừng 
    IF room_status <> 'Available' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Phòng hiện không có sẵn.';
    END IF;


    -- nếu phòng hợp lệ và không trùng lịch, thêm booking mới vào bảng Bookings
    INSERT INTO Bookings (guest_id, room_id, check_in, check_out, status)
    VALUES (p_guest_id, p_room_id, p_check_in, p_check_out, 'Confirmed');

    -- cập nhật trạng thái phòng 
    UPDATE Rooms SET status = 'Occupied'
    WHERE room_id = p_room_id;

END //

-- Khôi phục dấu kết thúc lệnh mặc định là ;
DELIMITER ;

-- 2. Trigger:

BEGIN
  -- Kiểm tra nếu trạng thái cũ là 'Confirmed' và trạng thái mới là 'Cancelled'
  -- → Tức là booking vừa bị hủy
  IF OLD.status = 'Confirmed' AND NEW.status = 'Cancelled' THEN

    -- nếu không còn booking nào khác trong tương lai cho cùng phòng đó
    IF (
      SELECT COUNT(*) 
      FROM bookings 
      WHERE room_id = NEW.room_id              
        AND status = 'Confirmed'                
        AND check_in > CURDATE()               
    ) = 0 THEN

      -- cập nhật trạng thái phòng về 'Available' vì không còn ai đặt trong tương lai
      UPDATE rooms
      SET status = 'Available'
      WHERE room_id = NEW.room_id;

    END IF;

  END IF;
END

-- 3. Bonus (nâng cao hơn):

DELIMITER //

-- Tạo thủ tục (stored procedure) tên là GenerateInvoice, nhận vào 1 tham số booking_id
CREATE PROCEDURE GenerateInvoice (
    IN p_booking_id INT  
)
BEGIN
    -- Khai báo biến nội bộ để lưu tạm thông tin
    DECLARE stay_days INT;         
    DECLARE room_price INT;          
    DECLARE total INT;               
    DECLARE room_id_val INT;         
    DECLARE check_in_val DATE;       
    DECLARE check_out_val DATE;      -

    -- lấy thông tin từ bảng Bookings
    SELECT room_id, check_in, check_out
    INTO room_id_val, check_in_val, check_out_val
    FROM Bookings
    WHERE booking_id = p_booking_id;

    -- tính số ngày ở lại bằng hàm DATEDIFF
    SET stay_days = DATEDIFF(check_out_val, check_in_val);

    -- lấy giá phòng từ bảng Rooms theo room_id
    SELECT price INTO room_price
    FROM Rooms
    WHERE room_id = room_id_val;

    -- tính tổng tiền = số ngày ở * giá 1 đêm
    SET total = stay_days * room_price;

    -- thêm hóa đơn mới vào bảng Invoices
    INSERT INTO Invoices (booking_id, total_amount, generated_date)
    VALUES (p_booking_id, total, CURDATE());  
END //
DELIMITER ;