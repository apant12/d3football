-- phpMyAdmin SQL Dump
-- version 4.6.5.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 14, 2017 at 03:59 AM
-- Server version: 10.1.21-MariaDB
-- PHP Version: 5.6.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `d3football`
--

-- --------------------------------------------------------

--
-- Table structure for table `drives`
--

CREATE TABLE `drives` (
  `id` int(11) NOT NULL,
  `game_id` int(11) NOT NULL,
  `team_id` int(11) NOT NULL,
  `location` tinyint(4) NOT NULL,
  `quarter` varchar(4) NOT NULL,
  `starttime` time NOT NULL,
  `points` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `drives`
--

INSERT INTO `drives` (`id`, `game_id`, `team_id`, `location`, `quarter`, `starttime`, `points`) VALUES
(1, 1, 1, 32, '1st', '11:22:00', 0),
(2, 1, 2, 14, '1st', '09:00:00', 0),
(3, 1, 1, 33, '1st', '06:15:00', 0),
(4, 1, 2, 25, '1st', '04:22:00', 0),
(5, 1, 1, 22, '1st', '01:15:00', 0),
(6, 1, 2, 34, '2nd', '14:54:00', 0),
(7, 1, 1, 35, '2nd', '13:48:00', 0),
(8, 1, 2, 34, '2nd', '10:01:00', 0),
(9, 1, 1, 36, '2nd', '06:24:00', 0),
(10, 1, 2, 35, '2nd', '04:14:00', 0),
(11, 1, 1, 25, '2nd', '00:37:00', 0),
(12, 1, 1, 23, '3rd', '15:00:00', 0),
(13, 1, 1, 38, '3rd', '11:00:00', 0),
(14, 1, 2, 19, '3rd', '09:13:00', 0),
(15, 1, 1, 35, '3rd', '07:22:00', 0),
(16, 1, 2, 21, '3rd', '06:04:00', 0),
(17, 1, 1, 1, '3rd', '02:40:00', 0),
(18, 1, 2, 44, '3rd', '00:28:00', 0),
(19, 1, 1, 24, '4th', '13:16:00', 0),
(20, 1, 2, 27, '4th', '11:28:00', 0),
(21, 1, 1, 21, '4th', '09:02:00', 0),
(22, 1, 2, 40, '4th', '05:07:00', 0),
(23, 1, 1, 44, '4th', '03:49:00', 0),
(24, 1, 2, 21, '4th', '02:47:00', 0),
(25, 1, 1, 32, '4th', '01:43:00', 0);

-- --------------------------------------------------------

--
-- Table structure for table `field_goals`
--

CREATE TABLE `field_goals` (
  `play_id` int(11) NOT NULL,
  `distance` tinyint(4) NOT NULL,
  `success` enum('0','1') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `games`
--

CREATE TABLE `games` (
  `id` int(11) NOT NULL,
  `home_id` int(11) NOT NULL,
  `road_id` int(11) NOT NULL,
  `home_score` tinyint(3) UNSIGNED NOT NULL,
  `road_score` tinyint(3) UNSIGNED NOT NULL,
  `date` datetime NOT NULL,
  `gamecode` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `games`
--

INSERT INTO `games` (`id`, `home_id`, `road_id`, `home_score`, `road_score`, `date`, `gamecode`) VALUES
(1, 1, 2, 28, 35, '2016-10-15 00:00:00', 'm72v');

-- --------------------------------------------------------

--
-- Table structure for table `goforit`
--

CREATE TABLE `goforit` (
  `play_id` int(11) NOT NULL,
  `success` enum('0','1') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `plays`
--

CREATE TABLE `plays` (
  `id` int(10) UNSIGNED NOT NULL,
  `drive_id` int(11) NOT NULL,
  `playnum` tinyint(4) NOT NULL,
  `down` enum('1','2','3','4') NOT NULL,
  `distance` tinyint(4) NOT NULL,
  `location` tinyint(4) NOT NULL,
  `quarter` enum('1','2','3','4','5') NOT NULL,
  `description` varchar(255) NOT NULL,
  `result` tinyint(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `punts`
--

CREATE TABLE `punts` (
  `play_id` int(11) NOT NULL,
  `distance` tinyint(4) NOT NULL,
  `net` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `teams`
--

CREATE TABLE `teams` (
  `id` int(11) NOT NULL,
  `school` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `teams`
--

INSERT INTO `teams` (`id`, `school`) VALUES
(2, 'Illinois College'),
(1, 'Knox College');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `drives`
--
ALTER TABLE `drives`
  ADD PRIMARY KEY (`id`),
  ADD KEY `game_id` (`game_id`,`team_id`);

--
-- Indexes for table `field_goals`
--
ALTER TABLE `field_goals`
  ADD PRIMARY KEY (`play_id`);

--
-- Indexes for table `games`
--
ALTER TABLE `games`
  ADD PRIMARY KEY (`id`),
  ADD KEY `home_id` (`home_id`,`road_id`,`gamecode`);

--
-- Indexes for table `goforit`
--
ALTER TABLE `goforit`
  ADD PRIMARY KEY (`play_id`);

--
-- Indexes for table `plays`
--
ALTER TABLE `plays`
  ADD PRIMARY KEY (`id`),
  ADD KEY `drive_id` (`drive_id`);

--
-- Indexes for table `punts`
--
ALTER TABLE `punts`
  ADD PRIMARY KEY (`play_id`);

--
-- Indexes for table `teams`
--
ALTER TABLE `teams`
  ADD PRIMARY KEY (`id`),
  ADD KEY `school` (`school`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `drives`
--
ALTER TABLE `drives`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;
--
-- AUTO_INCREMENT for table `games`
--
ALTER TABLE `games`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `plays`
--
ALTER TABLE `plays`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `teams`
--
ALTER TABLE `teams`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
