-- --------------------------------------------------------
-- Host:                         74.63.209.103
-- Server version:               5.5.21-cll - MySQL Community Server (GPL) by Atomicorp
-- Server OS:                    Linux
-- HeidiSQL version:             7.0.0.4053
-- Date/time:                    2012-03-20 19:42:53
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET FOREIGN_KEY_CHECKS=0 */;

-- Dumping database structure for epidemic
CREATE DATABASE IF NOT EXISTS `epidemic` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `epidemic`;


-- Dumping structure for table epidemic.epi_characters
CREATE TABLE IF NOT EXISTS `epi_characters` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `Name` text NOT NULL,
  `SteamID` text NOT NULL,
  `Class` text NOT NULL,
  `Age` text NOT NULL,
  `PhysDesc` text NOT NULL,
  `OriMdl` text NOT NULL,
  `CharFlags` text NOT NULL,
  `HeavyWeaponry` text NOT NULL,
  `LightWeaponry` text NOT NULL,
  `HasBackpack` int(10) NOT NULL DEFAULT '0',
  `HasPouch` int(10) NOT NULL DEFAULT '0',
  `HWAmmo` int(10) NOT NULL DEFAULT '0',
  `LWammo` int(10) NOT NULL DEFAULT '0',
  `HWDeg` int(10) NOT NULL DEFAULT '0',
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- Dumping data for table epidemic.epi_characters: ~2 rows (approximately)
DELETE FROM `epi_characters`;
/*!40000 ALTER TABLE `epi_characters` DISABLE KEYS */;
INSERT INTO `epi_characters` (`id`, `Name`, `SteamID`, `Class`, `Age`, `PhysDesc`, `OriMdl`, `CharFlags`, `HeavyWeaponry`, `LightWeaponry`, `HasBackpack`, `HasPouch`, `HWAmmo`, `LWammo`, `HWDeg`) VALUES
	(1, 'Spencer Sharkey', 'STEAM_0:1:16110278', 'Survivor', '16', 'Spencer Sharkey', 'models/humans/modern/male_02_03.mdl#24', '', '', '', 1, 1, 0, 0, 0),
	(2, 'Rorick Bayn', 'STEAM_0:1:25915952', 'Survivor', '22', 'M|Thick-Black Hair|Dark-Military Garb|Light-Southern Accent', 'models/humans/modern/male_07_01.mdl#1', '', 'ep_m4a1', '', 1, 1, 26, 0, 96);
/*!40000 ALTER TABLE `epi_characters` ENABLE KEYS */;


-- Dumping structure for table epidemic.epi_inv
CREATE TABLE IF NOT EXISTS `epi_inv` (
  `id` int(10) NOT NULL,
  `itemid` int(10) NOT NULL DEFAULT '0',
  `x` int(10) NOT NULL DEFAULT '0',
  `y` int(10) NOT NULL DEFAULT '0',
  `amt` int(10) NOT NULL DEFAULT '0',
  `inv` int(10) NOT NULL DEFAULT '0',
  `SteamID` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table epidemic.epi_inv: ~3 rows (approximately)
DELETE FROM `epi_inv`;
/*!40000 ALTER TABLE `epi_inv` DISABLE KEYS */;
INSERT INTO `epi_inv` (`id`, `itemid`, `x`, `y`, `amt`, `inv`, `SteamID`) VALUES
	(1, 0, 1, 1, 1, 3, 'STEAM_0:1:16110278'),
	(2, 0, 1, 1, 1, 1, 'STEAM_0:1:25915952'),
	(2, 0, 4, 5, 1, 1, 'STEAM_0:1:25915952');
/*!40000 ALTER TABLE `epi_inv` ENABLE KEYS */;


-- Dumping structure for table epidemic.epi_recog
CREATE TABLE IF NOT EXISTS `epi_recog` (
  `i` int(10) NOT NULL AUTO_INCREMENT,
  `id` int(10) DEFAULT NULL,
  `recogid` int(10) DEFAULT NULL,
  `SteamID` text,
  KEY `i` (`i`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

-- Dumping data for table epidemic.epi_recog: ~4 rows (approximately)
DELETE FROM `epi_recog`;
/*!40000 ALTER TABLE `epi_recog` DISABLE KEYS */;
INSERT INTO `epi_recog` (`i`, `id`, `recogid`, `SteamID`) VALUES
	(1, 2, 1, 'STEAM_0:1:25915952'),
	(2, 1, 2, 'STEAM_0:1:16110278'),
	(3, 1, 2, 'STEAM_0:1:16110278'),
	(4, 2, 1, 'STEAM_0:1:25915952');
/*!40000 ALTER TABLE `epi_recog` ENABLE KEYS */;


-- Dumping structure for table epidemic.epi_users
CREATE TABLE IF NOT EXISTS `epi_users` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `SteamName` text NOT NULL,
  `SteamID` text NOT NULL,
  `IP` text NOT NULL,
  `Date` text NOT NULL,
  `Flags` text NOT NULL,
  `PlayerDesc` text NOT NULL,
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

-- Dumping data for table epidemic.epi_users: ~3 rows (approximately)
DELETE FROM `epi_users`;
/*!40000 ALTER TABLE `epi_users` DISABLE KEYS */;
INSERT INTO `epi_users` (`id`, `SteamName`, `SteamID`, `IP`, `Date`, `Flags`, `PlayerDesc`) VALUES
	(1, 'Spencer', 'STEAM_0:1:16110278', '68.38.36.121:27006', 'Mar-20-2012', '+', ''),
	(2, 'Rorick', 'STEAM_0:1:25915952', '74.248.52.161:27005', 'Mar-20-2012', '#!C+', ''),
	(3, '|HGN| General Cole', 'STEAM_0:0:22776775', '75.108.223.177:27005', 'Mar-20-2012', '', '');
/*!40000 ALTER TABLE `epi_users` ENABLE KEYS */;
/*!40014 SET FOREIGN_KEY_CHECKS=1 */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
