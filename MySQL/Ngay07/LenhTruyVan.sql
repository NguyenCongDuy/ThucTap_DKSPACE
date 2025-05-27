-- 1. Phân tích truy vấn sau bằng EXPLAIN và đề xuất cải tiến:
EXPLAIN SELECT * FROM Orders 
        JOIN OrderItems ON Orders.order_id = OrderItems.order_id
        WHERE status = 'Shipped'
        ORDER BY order_date DESC;

--2. tạo Index trên Orders(status, order_date)
CREATE INDEX idx_orders_status_orderdate ON Orders(status, order_date);
--3. tạo Composite Index trên OrderItems(order_id, product_id)
CREATE INDEX idx_orderitems_orderid_productid ON OrderItems(order_id, product_id);
--4. kiểm tra lại truy vấn với EXPLAIN
EXPLAIN SELECT 
  Orders.order_id, Orders.order_date, Orders.status,
  OrderItems.product_id, OrderItems.quantity, OrderItems.unit_price
FROM Orders
JOIN OrderItems ON Orders.order_id = OrderItems.order_id
WHERE Orders.status = 'Shipped'
ORDER BY Orders.order_date DESC;

-- 5. So sánh hiệu suất
--Truy vấn 1: JOIN giữa Products và Categories
SELECT p.product_id, p.name, c.name AS category_name
FROM Products p
JOIN Categories c ON p.category_id = c.category_id;
--Truy vấn 2: Subquery để lấy tên category từ Products
SELECT p.product_id, p.name,
(SELECT c.name FROM Categories c WHERE c.category_id = p.category_id) AS category_name
FROM Products p;

-- 6.Viết truy vấn để lấy 10 sản phẩm mới nhất trong danh mục “Electronics”, có stock_quantity > 0.
SELECT p.product_id, p.name, p.price, p.stock_quantity, p.created_at
FROM Products p
JOIN Categories c ON p.category_id = c.category_id
WHERE c.name = 'Electronics'
  AND p.stock_quantity > 0
ORDER BY p.created_at DESC
LIMIT 10;

-- 7. Tạo một Covering Index cho truy vấn thường xuyên:
CREATE INDEX idx_covering_products ON Products(category_id, price, product_id, name);
--sử dụng EXPLAIN để kiểm tra hiệu suất
EXPLAIN
SELECT product_id, name, price
FROM Products
WHERE category_id = 3
ORDER BY price ASC
LIMIT 20;

-- 8. Tối ưu truy vấn tính doanh thu theo tháng, dùng GROUP BY:
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM Orders o
JOIN OrderItems oi ON o.order_id = oi.order_id
WHERE o.order_date >= '2025-01-01 00:00:00'
AND o.order_date < '2026-01-01 00:00:00'
GROUP BY month
ORDER BY month;

--9.Tách truy vấn lớn thành nhiều bước nhỏ
--9.1
SELECT DISTINCT order_id
FROM OrderItems
WHERE unit_price > 1000000;
--9.2
SELECT SUM(quantity) AS total_quantity
FROM OrderItems
WHERE order_id IN (danh sách order_id);
--lệnh có subquery
SELECT SUM(quantity) AS total_quantity
FROM OrderItems
WHERE order_id IN (
    SELECT DISTINCT order_id
    FROM OrderItems
    WHERE unit_price > 1000000
);

--10. Viết truy vấn liệt kê top 5 sản phẩm bán chạy nhất trong 30 ngày gần nhất.
SELECT 
    p.product_id,
    p.name,
    SUM(oi.quantity) AS total_sold
FROM OrderItems oi
JOIN Orders o ON oi.order_id = o.order_id
JOIN Products p ON oi.product_id = p.product_id
WHERE o.order_date >= CURDATE() - INTERVAL 30 DAY
GROUP BY p.product_id, p.name
ORDER BY total_sold DESC
LIMIT 5;

