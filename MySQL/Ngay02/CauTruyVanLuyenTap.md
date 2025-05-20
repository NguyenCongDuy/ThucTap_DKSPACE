 **Câu Truy Vấn Thực Hàng Với Bảng**

1. Phân tích doanh thu

SELECT p.category, SUM(p.price * oi.quantity) as Tong_tien 
FROM orders o 
JOIN orderitems oi ON o.order_id = oi.order_id 
JOIN products p ON oi.product_id = p.product_id 
WHERE o.status = 'completed' 
GROUP BY p.category;


2. Người dùng giới thiệu.

SELECT u.user_id, u.full_name, u.city, r.full_name as Nguoi_Gioi_Thieu
FROM users u
LEFT JOIN users r ON u.referrer_id = r.user_id;

3. Sản phẩm không còn bán

SELECT p.product_id, p.product_name
FROM products p
JOIN orderitems oi ON p.product_id = oi.product_id
WHERE is_active = 0;

4. Người dùng "chưa hoạt động"

SELECT u.user_id, u.full_name
FROM Users u
LEFT JOIN Orders o ON u.user_id = o.user_id
WHERE o.order_id IS NULL;

5. Đơn hàng đầu tiên của từng người dùng

SELECT o.user_id, o.order_date AS Ngay_Dat_Don_Dau_Tien, o.order_id 
FROM Orders o 
WHERE (o.user_id, o.order_date) IN ( SELECT user_id, MIN(order_date) 
FROM Orders GROUP BY user_id );

6. Tổng chi tiêu của mỗi người dùng

SELECT o.user_id, u.full_name, SUM(p.price * oi.quantity) AS Tong_Chi_Tieu
FROM Orders o
JOIN OrderItems oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id
JOIN Users u ON o.user_id = u.user_id
WHERE o.status = 'completed'
GROUP BY o.user_id;

7. Lọc người dùng tiêu nhiều

SELECT user_id, full_name, Tong_Chi_Tieu
FROM (
    SELECT o.user_id, u.full_name, SUM(p.price * oi.quantity) AS Tong_Chi_Tieu
    FROM Orders o
    JOIN OrderItems oi ON o.order_id = oi.order_id
    JOIN Products p ON oi.product_id = p.product_id
    JOIN Users u ON o.user_id = u.user_id
    WHERE o.status = 'completed'
    GROUP BY o.user_id
) AS spending
WHERE Tong_Chi_Tieu > 25000000;

8. So sánh các thành phố

SELECT u.city, COUNT(o.order_id) AS Tong_Don_Dat, 
      		   SUM(p.price * oi.quantity) AS Tong_Danh_Thu
FROM Users u
LEFT JOIN Orders o ON u.user_id = o.user_id AND o.status = 'completed'
LEFT JOIN OrderItems oi ON o.order_id = oi.order_id
LEFT JOIN Products p ON oi.product_id = p.product_id
GROUP BY u.city;

9. Người dùng có ít nhất 2 đơn hàng completed

SELECT o.user_id, u.full_name, COUNT(o.order_id) AS Don_Hang_Thanh_Cong
FROM Orders o
JOIN Users u ON o.user_id = u.user_id
WHERE o.status = 'completed'
GROUP BY o.user_id
HAVING COUNT(o.order_id) >= 2;

10. Tìm đơn hàng có sản phẩm thuộc nhiều hơn 1 danh mục:

SELECT oi.order_id
FROM OrderItems oi
JOIN Products p ON oi.product_id = p.product_id
GROUP BY oi.order_id
HAVING COUNT(DISTINCT p.category) > 1;

11. Kết hợp danh sách: Dùng UNION để kết hợp 2 danh sách:

SELECT DISTINCT u.user_id, u.full_name, 'placed_order' AS Nguon
FROM Users u
JOIN Orders o ON u.user_id = o.user_id

UNION

SELECT DISTINCT u.user_id, u.full_name, 'referred' AS Nguon
FROM Users u
WHERE u.referrer_id IS NOT NULL;

