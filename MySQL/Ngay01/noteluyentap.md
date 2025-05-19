- Câu lệnh truy vấn thực hành SQL tổng hợp

1. Danh sách khách hàng đến từ hà nội 
SELECT * FROM Customers WHERE city = 'Hanoi';

2. Những đơn hàng có giá trị trên 400.000 đồng và đặt sau ngày 31/01/2023
SELECT * FROM Orders
WHERE total_amount > 400000
AND order_date > '2023-01-31';

3. Khách hàng chưa có địa chỉ email:
SELECT * FROM Customers WHERE email IS NULL;

4. Xem toàn bộ đơn hàng, sắp xếp theo tổng tiền từ cao xuống thấp
SELECT * FROM Orders
ORDER BY total_amount DESC;

5. Thêm khách hàng "Pham Thanh", sống tại Cần Thơ (email để trống)
INSERT INTO Customers (customer_id, name, city, email)
VALUES (5, 'Pham Thanh', 'Can Tho', NULL);

6. Cập nhật email cho khách hàng có mã là 2
UPDATE Customers
SET email = 'binh.tran@email.com'
WHERE customer_id = 2;

7. Xóa đơn hàng có mã là 103:
DELETE FROM Orders
WHERE order_id = 103;

8. Lấy 2 khách hàng đầu tiên trong bảng:
SELECT * FROM Customers
LIMIT 2;

9. Đơn hàng có giá trị lớn nhất và nhỏ nhất:
SELECT 
  MAX(total_amount) AS max_order_value,
  MIN(total_amount) AS min_order_value
FROM Orders;

10. Tổng số lượng đơn hàng, tổng số tiền đã bán và trung bình giá trị đơn:
SELECT 
  COUNT(*) AS total_orders,
  SUM(total_amount) AS total_revenue,
  AVG(total_amount) AS avg_order_value
FROM Orders;

11. Sản phẩm có tên bắt đầu bằng chữ “Laptop”:
SELECT * FROM Products
WHERE name LIKE 'Laptop%';

