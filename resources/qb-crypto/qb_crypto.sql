CREATE TABLE IF NOT EXISTS crypto (
  # int(11) NOT NULL AUTO_INCREMENT,
  crypto varchar(50) NOT NULL DEFAULT 'qbit',
  worth int(11) NOT NULL DEFAULT 0,
  history text DEFAULT NULL,
  PRIMARY KEY (#)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- Data exporting was unselected.

-- Dumping structure for table qbus.crypto_transactions
CREATE TABLE IF NOT EXISTS crypto_transactions (
  id int(11) NOT NULL AUTO_INCREMENT,
  citizenid varchar(50) DEFAULT NULL,
  title varchar(50) DEFAULT NULL,
  message varchar(50) DEFAULT NULL,
  date timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (id),
  KEY citizenid (citizenid)
) ENGINE=InnoDB AUTO_INCREMENT=939 DEFAULT CHARSET=utf8mb4;