-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.3.16-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             11.0.0.5919
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dumping database structure for onecity
CREATE DATABASE IF NOT EXISTS `onecity` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `onecity`;

-- Dumping structure for table onecity.houses_
CREATE TABLE IF NOT EXISTS `houses_` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` varchar(55) NOT NULL DEFAULT 'nil',
  `name` varchar(55) NOT NULL,
  `price` int(55) NOT NULL DEFAULT 150000,
  `locked` char(5) NOT NULL DEFAULT 'true',
  `door` longtext NOT NULL,
  `shell` varchar(55) NOT NULL DEFAULT 'shell_lester',
  `draw` float NOT NULL DEFAULT 15,
  `failBuy` char(5) NOT NULL DEFAULT 'false',
  `purDate` longtext NOT NULL,
  `keys` longtext NOT NULL DEFAULT '[]',
  `furniture` longtext NOT NULL,
  `parkings` longtext NOT NULL,
  `doors` longtext NOT NULL,
  `garages` longtext NOT NULL,
  `storage` longtext NOT NULL,
  `wardrobe` longtext NOT NULL,
  `nogarage` char(5) DEFAULT NULL,
  `firstspawn` char(5) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4;

-- Dumping data for table onecity.houses_: ~3 rows (approximately)
/*!40000 ALTER TABLE `houses_` DISABLE KEYS */;
REPLACE INTO `houses_` (`id`, `owner`, `name`, `price`, `locked`, `door`, `shell`, `draw`, `failBuy`, `purDate`, `keys`, `furniture`, `parkings`, `doors`, `garages`, `storage`, `wardrobe`, `nogarage`, `firstspawn`) VALUES
	(1, 'nil', 'test', 1, 'true', '{"x":67.24698638916,"z":52.35387802124,"y":-253.82002258301}', 'mid', 15, 'false', '', '[]', '', '', '{"x":0.0,"z":0.0,"y":0.0}', '{"x":0.0,"z":0.0,"y":0.0}', '{"x":0.0,"z":0.0,"y":0.0}', '{"x":0.0,"z":0.0,"y":0.0}', '0', 'false'),
	(2, 'nil', 'Test3', 1111, 'true', '{"x":63.451671600342,"z":52.35387802124,"y":-262.03344726563}', 'mid', 15, 'false', '', '[]', '', '', '{"x":0.0,"z":0.0,"y":0.0}', '{"x":0.0,"z":0.0,"y":0.0}', '{"x":0.0,"z":0.0,"y":0.0}', '{"x":0.0,"z":0.0,"y":0.0}', '0', 'false'),
	(3, 'nil', 'test3', 1, 'true', '{"z":52.353874206543,"y":-255.80773925781,"x":66.495330810547}', 'mid', 15, 'false', '', '[]', '', '', '{"z":0.0,"y":0.0,"x":0.0}', '{"z":0.0,"y":0.0,"x":0.0}', '{"z":0.0,"y":0.0,"x":0.0}', '{"z":0.0,"y":0.0,"x":0.0}', '0', 'false'),
	(4, 'steam:11000010aa15521', 'House', 100000, 'true', '{"z":29.426710128784,"y":-977.91473388672,"x":387.22320556641}', 'mid', 15, '1', '', '[]', '', '', '{"z":6.4105024337769,"y":-987.91473388672,"x":388.72320556641}', '{"z":0.0,"y":0.0,"x":0.0}', '{"x":0.0,"z":0.0,"y":0.0}', '{"z":0.0,"y":0.0,"x":0.0}', '0', '1'),
	(5, 'nil', 'House', 1000, 'true', '{"z":29.442642211914,"x":386.95642089844,"y":-970.01385498047}', 'mid', 15, 'false', '', '[]', '', '', '{"z":6.4066257476807,"y":-980.01385498047,"x":388.45642089844}', '{"z":0.0,"x":0.0,"y":0.0}', '{"z":0.0,"x":0.0,"y":0.0}', '{"z":0.0,"x":0.0,"y":0.0}', '0', '1'),
	(7, 'nil', 'fuck', 3000, 'true', '{"z":29.417943954468,"y":-1004.7903442383,"x":386.18884277344}', 'mid', 15, 'false', '', '[]', '', '', '{"y":-1014.790222168,"x":387.68884277344,"z":6.4314002990723}', '{"z":0.0,"y":0.0,"x":0.0}', '{"z":0.0,"y":0.0,"x":0.0}', '{"z":0.0,"y":0.0,"x":0.0}', '0', '1'),
	(8, 'nil', 'fffuck', 10000, 'true', '{"z":29.450180053711,"y":-997.44018554688,"x":378.45916748047}', 'lester', 15, 'false', '', '[]', '', '', '{"z":0.0,"y":0.0,"x":0.0}', '{"z":0.0,"y":0.0,"x":0.0}', '{"z":0.0,"y":0.0,"x":0.0}', '{"z":0.0,"y":0.0,"x":0.0}', '0', 'false'),
	(9, 'nil', 'Trevors', 35000, 'true', '{"x":386.12933349609,"y":-1010.8706665039,"z":29.417932510376}', 'trevor', 15, 'false', '', '[]', '', '', '{"x":388.62933349609,"z":9.8724584579468,"y":-1015.9706420898}', '{"x":0.0,"y":0.0,"z":0.0}', '{"x":0.0,"y":0.0,"z":0.0}', '{"x":0.0,"y":0.0,"z":0.0}', '0', '1'),
	(10, 'nil', 'TestLow', 1, 'true', '{"z":29.337080001831,"x":376.61483764648,"y":-1027.9378662109}', 'low', 15, 'false', '', '[]', '', '', '{"x":376.17184448242,"z":29.336820602417,"y":-1028.0473632813}', '{"z":0.0,"x":0.0,"y":0.0}', '{"z":0.0,"x":0.0,"y":0.0}', '{"z":0.0,"x":0.0,"y":0.0}', '0', '1');
/*!40000 ALTER TABLE `houses_` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
