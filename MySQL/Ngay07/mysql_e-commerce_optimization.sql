-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: May 27, 2025 at 10:22 AM
-- Server version: 8.0.30
-- PHP Version: 8.2.20

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `mysql_e-commerce_optimization`
--

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `category_id` int NOT NULL,
  `name` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`category_id`, `name`) VALUES
(1, 'Electronics'),
(2, 'Books'),
(3, 'Clothing');

-- --------------------------------------------------------

--
-- Table structure for table `orderitems`
--

CREATE TABLE `orderitems` (
  `order_item_id` int NOT NULL,
  `order_id` int DEFAULT NULL,
  `product_id` int DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `unit_price` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `orderitems`
--

INSERT INTO `orderitems` (`order_item_id`, `order_id`, `product_id`, `quantity`, `unit_price`) VALUES
(1, 1, 1, 2, '1500.00'),
(2, 1, 7, 3, '15.00'),
(3, 2, 2, 1, '2200.00'),
(4, 2, 8, 2, '18.00'),
(5, 3, 3, 1, '300.00'),
(6, 3, 9, 2, '22.00'),
(7, 4, 4, 2, '250.00'),
(8, 5, 6, 1, '1800.00'),
(9, 6, 11, 4, '30.00'),
(10, 7, 12, 2, '20.00'),
(11, 8, 5, 1, '800.00'),
(12, 9, 14, 2, '40.00'),
(13, 10, 1, 1, '1500.00'),
(14, 10, 3, 1, '300.00'),
(15, 10, 13, 1, '20.00');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `order_id` int NOT NULL,
  `user_id` int DEFAULT NULL,
  `order_date` datetime DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`order_id`, `user_id`, `order_date`, `status`) VALUES
(1, 1, '2025-05-01 00:00:00', 'Shipped'),
(2, 2, '2025-05-05 00:00:00', 'Shipped'),
(3, 3, '2025-05-10 00:00:00', 'Pending'),
(4, 4, '2025-05-12 00:00:00', 'Cancelled'),
(5, 5, '2025-05-15 00:00:00', 'Shipped'),
(6, 6, '2025-05-18 00:00:00', 'Pending'),
(7, 7, '2025-05-20 00:00:00', 'Shipped'),
(8, 8, '2025-05-22 00:00:00', 'Shipped'),
(9, 9, '2025-05-25 00:00:00', 'Pending'),
(10, 10, '2025-05-27 00:00:00', 'Shipped');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `product_id` int NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `category_id` int DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `stock_quantity` int DEFAULT NULL,
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`product_id`, `name`, `category_id`, `price`, `stock_quantity`, `created_at`) VALUES
(1, 'Smartphone X1', 1, '1500.00', 10, '2025-05-25 10:00:00'),
(2, 'Laptop Z5', 1, '2200.00', 5, '2025-05-20 12:00:00'),
(3, 'Headphones Pro', 1, '300.00', 15, '2025-05-18 09:00:00'),
(4, 'Smartwatch Lite', 1, '250.00', 20, '2025-05-17 08:30:00'),
(5, 'Tablet S3', 1, '800.00', 8, '2025-05-22 11:00:00'),
(6, 'Camera X100', 1, '1800.00', 3, '2025-05-15 14:00:00'),
(7, 'Book A', 2, '15.00', 100, '2025-05-10 13:00:00'),
(8, 'Book B', 2, '18.00', 90, '2025-05-12 15:00:00'),
(9, 'Book C', 2, '22.00', 70, '2025-05-05 09:30:00'),
(10, 'Book D', 2, '12.00', 120, '2025-05-03 10:00:00'),
(11, 'Book E', 2, '30.00', 60, '2025-05-01 11:00:00'),
(12, 'T-shirt M', 3, '20.00', 50, '2025-05-06 12:00:00'),
(13, 'T-shirt L', 3, '20.00', 60, '2024-05-07 14:00:00'),
(14, 'Jeans S', 3, '40.00', 40, '2024-05-08 15:00:00'),
(15, 'Jeans M', 3, '45.00', 35, '2024-05-09 16:00:00'),
(16, 'Jeans L', 3, '50.00', 25, '2024-05-11 17:00:00'),
(17, 'Dress A', 3, '70.00', 20, '2024-05-13 18:00:00'),
(18, 'Dress B', 3, '80.00', 15, '2024-05-14 19:00:00'),
(19, 'Jacket X', 3, '150.00', 12, '2024-05-16 20:00:00'),
(20, 'Shoes Y', 3, '90.00', 18, '2024-05-19 21:00:00');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`category_id`);

--
-- Indexes for table `orderitems`
--
ALTER TABLE `orderitems`
  ADD PRIMARY KEY (`order_item_id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `idx_orderitems_orderid_productid` (`order_id`,`product_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `idx_orders_status_orderdate` (`status`,`order_date`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`product_id`),
  ADD KEY `category_id` (`category_id`),
  ADD KEY `idx_covering_products` (`category_id`,`price`,`product_id`,`name`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `category_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `orderitems`
--
ALTER TABLE `orderitems`
  MODIFY `order_item_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `product_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `orderitems`
--
ALTER TABLE `orderitems`
  ADD CONSTRAINT `orderitems_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`),
  ADD CONSTRAINT `orderitems_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`);

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
