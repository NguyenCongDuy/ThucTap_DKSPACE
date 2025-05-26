-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: May 26, 2025 at 03:28 AM
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
-- Database: `mysql_recruitment-management`
--

-- --------------------------------------------------------

--
-- Table structure for table `applications`
--

CREATE TABLE `applications` (
  `app_id` int NOT NULL,
  `candidate_id` int DEFAULT NULL,
  `job_id` int DEFAULT NULL,
  `apply_date` date DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `applications`
--

INSERT INTO `applications` (`app_id`, `candidate_id`, `job_id`, `apply_date`, `status`) VALUES
(1, 1, 1, '2025-05-01', 'Pending'),
(2, 2, 2, '2025-05-03', 'Accepted'),
(3, 3, 3, '2025-05-05', 'Rejected'),
(4, 4, 4, '2025-05-07', 'Accepted');

-- --------------------------------------------------------

--
-- Table structure for table `candidates`
--

CREATE TABLE `candidates` (
  `candidate_id` int NOT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `years_exp` int DEFAULT NULL,
  `expected_salary` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `candidates`
--

INSERT INTO `candidates` (`candidate_id`, `full_name`, `email`, `phone`, `years_exp`, `expected_salary`) VALUES
(1, 'Nguyen Van A', 'a@gmail.com', '0909000001', 0, 800),
(2, 'Le Thi B', 'b@gmail.com', NULL, 2, 1200),
(3, 'Tran Van C', 'c@gmail.com', '0909000003', 4, 1500),
(4, 'Pham Thi D', 'd@gmail.com', '0909000004', 7, 2000);

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `job_id` int NOT NULL,
  `title` varchar(100) DEFAULT NULL,
  `department` varchar(50) DEFAULT NULL,
  `min_salary` int DEFAULT NULL,
  `max_salary` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `jobs`
--

INSERT INTO `jobs` (`job_id`, `title`, `department`, `min_salary`, `max_salary`) VALUES
(1, 'Backend Developer', 'IT', 1000, 2000),
(2, 'Data Analyst', 'IT', 1200, 1800),
(3, 'Sales Executive', 'Sales', 800, 1600),
(4, 'HR Manager', 'HR', 1100, 1700),
(5, 'Software engineer', 'IT', 100000, 500000);

-- --------------------------------------------------------

--
-- Table structure for table `shortlistedcandidates`
--

CREATE TABLE `shortlistedcandidates` (
  `candidate_id` int DEFAULT NULL,
  `job_id` int DEFAULT NULL,
  `selection_date` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `shortlistedcandidates`
--

INSERT INTO `shortlistedcandidates` (`candidate_id`, `job_id`, `selection_date`) VALUES
(2, 2, '2025-05-21'),
(4, 4, '2025-05-21');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `applications`
--
ALTER TABLE `applications`
  ADD PRIMARY KEY (`app_id`),
  ADD KEY `candidate_id` (`candidate_id`),
  ADD KEY `job_id` (`job_id`);

--
-- Indexes for table `candidates`
--
ALTER TABLE `candidates`
  ADD PRIMARY KEY (`candidate_id`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`job_id`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `applications`
--
ALTER TABLE `applications`
  ADD CONSTRAINT `applications_ibfk_1` FOREIGN KEY (`candidate_id`) REFERENCES `candidates` (`candidate_id`),
  ADD CONSTRAINT `applications_ibfk_2` FOREIGN KEY (`job_id`) REFERENCES `jobs` (`job_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
