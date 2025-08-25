-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: labs-mysql-colossal-round-branch:3306
-- Generation Time: Aug 25, 2025 at 02:11 PM
-- Server version: 8.0.37
-- PHP Version: 8.2.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `CSV_DB 5`
--

-- --------------------------------------------------------

--
-- Table structure for table `staff_locations`
--

CREATE TABLE `staff_locations` (
  `staff_id` int DEFAULT NULL,
  `first_name` varchar(8) DEFAULT NULL,
  `last_name` varchar(8) DEFAULT NULL,
  `location` varchar(2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Dumping data for table `staff_locations`
--

INSERT INTO `staff_locations` (`staff_id`, `first_name`, `last_name`, `location`) VALUES
(3, 'Marny', 'Hermione', 'WH'),
(4, 'Chelsea', 'Claudia', 'WH'),
(5, 'Alec', 'Isadora', 'WH'),
(6, 'Xena', 'Rahim', '3'),
(7, 'Kelsey', 'Cameron', '3'),
(8, 'Hamilton', 'Emi', '3'),
(9, 'Caldwell', 'Veda', '3'),
(10, 'Ima', 'Winifred', '3'),
(11, 'Ruth', 'Leslie', '4'),
(12, 'Britanni', 'Jorden', '4'),
(13, 'Berk', 'Derek', '4'),
(14, 'Damon', 'Sasha', '4'),
(15, 'Remedios', 'Mari', '4'),
(16, 'Reed', 'Eve', '5'),
(17, 'Quail', 'Octavia', '5'),
(18, 'Ezekiel', 'Rashad', '5'),
(19, 'Peter', 'Paloma', '5'),
(20, 'Ronan', 'Magee', '5'),
(21, 'Melodie', 'Mercedes', '6'),
(22, 'Marny', 'Dennis', '6'),
(23, 'Blythe', 'Arsenio', '6'),
(24, 'Garrett', 'Doris', '6'),
(25, 'Aline', 'Melanie', '6'),
(26, 'Joelle', 'Christen', '7'),
(27, 'Ainsley', 'Evelyn', '7'),
(28, 'Joseph', 'Byron', '7'),
(29, 'Orson', 'Benedict', '7'),
(30, 'Amela', 'Chadwick', '7'),
(31, 'Dawn', 'Anthony', '8'),
(32, 'Alisa', 'Lysandra', '8'),
(33, 'Cairo', 'Vaughan', '8'),
(34, 'Yasir', 'Lillith', '8'),
(35, 'Xavier', 'Zachary', '8'),
(36, 'Anthony', 'Kaitlin', '9'),
(37, 'Hop', 'Bianca', '9'),
(38, 'Ezekiel', 'Bertha', '9'),
(39, 'Vance', 'Samuel', '9'),
(40, 'Brent', 'Herman', '9'),
(41, 'Adrian', 'Macon', '10'),
(42, 'Kylie', 'Candace', '10'),
(43, 'Tatum', 'Laurel', '10'),
(44, 'Tamekah', 'Maya', '10'),
(45, 'Pandora', 'Neville', '10'),
(46, 'Desiree', 'Anika', 'FL'),
(47, 'Hope', 'Sheila', 'FL'),
(48, 'Clare', 'Oscar', 'FL'),
(49, 'Gemma', 'Eaton', 'FL'),
(50, 'Dale', 'Joshua', 'FL'),
(51, 'Lawrence', 'Roberts', 'FL'),
(52, 'Melinda', 'Zeus', 'FL'),
(53, 'Sawyer', 'Kasper', 'FL'),
(54, 'Ezekiel', 'Griffin', 'FL'),
(55, 'Coby', 'Shelly', 'FL');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
