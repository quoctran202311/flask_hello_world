-- --------------------------------------------------------
-- Hôte:                         127.0.0.1
-- Version du serveur:           11.2.2-MariaDB - mariadb.org binary distribution
-- SE du serveur:                Win64
-- HeidiSQL Version:             12.3.0.6589
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Listage de la structure de la base pour weeat
CREATE DATABASE IF NOT EXISTS `weeat` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `weeat`;

-- Listage de la structure de table weeat. clients
CREATE TABLE IF NOT EXISTS `clients` (
  `ClientID` int(11) NOT NULL AUTO_INCREMENT,
  `Nom` varchar(255) NOT NULL,
  `Prenom` varchar(255) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `Telephone` varchar(12) NOT NULL,
  PRIMARY KEY (`ClientID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Listage des données de la table weeat.clients : ~3 rows (environ)
DELETE FROM `clients`;
INSERT INTO `clients` (`ClientID`, `Nom`, `Prenom`, `Email`, `Telephone`) VALUES
	(1, 'CltNOM_1', 'CltPrenom_1', 'CltEmail_1@weeat.fr', '0123456701'),
	(2, 'CltNOM_2', 'CltPrenom_2', 'CltEmail_2@weeat.fr', '0123456712'),
	(3, 'CltNOM_3', 'CltPrenom_3', 'CltEmail_3@weeat.fr', '0123456723');

-- Listage de la structure de table weeat. commandes
CREATE TABLE IF NOT EXISTS `commandes` (
  `CommandeID` int(11) NOT NULL AUTO_INCREMENT,
  `DateCommande` date NOT NULL,
  `Statut` varchar(255) NOT NULL,
  `RefClientID` int(11) NOT NULL,
  PRIMARY KEY (`CommandeID`),
  KEY `fk_RefClientID` (`RefClientID`),
  CONSTRAINT `fk_RefClientID` FOREIGN KEY (`RefClientID`) REFERENCES `clients` (`ClientID`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Listage des données de la table weeat.commandes : ~7 rows (environ)
DELETE FROM `commandes`;
INSERT INTO `commandes` (`CommandeID`, `DateCommande`, `Statut`, `RefClientID`) VALUES
	(1, '2023-11-27', 'A-LIVRER', 1),
	(2, '2023-11-27', 'A-LIVRER', 1),
	(3, '2023-11-30', 'ENCOURS', 1),
	(4, '2023-11-30', 'ENCOURS', 2),
	(5, '2023-11-30', 'ENCOURS', 2),
	(6, '2024-02-29', 'A-LIVRER', 1),
	(7, '2024-02-29', 'ENCOURS', 3);

-- Listage de la structure de table weeat. detail_commande
CREATE TABLE IF NOT EXISTS `detail_commande` (
  `DetailID` int(11) NOT NULL AUTO_INCREMENT,
  `Quantite` int(11) NOT NULL,
  `PrixTotal` int(11) NOT NULL,
  `RefCommandeID` int(11) NOT NULL,
  `RefProduitID` int(11) NOT NULL,
  PRIMARY KEY (`DetailID`),
  KEY `fk_RefCommandeID` (`RefCommandeID`),
  KEY `fk_RefProduitID` (`RefProduitID`),
  CONSTRAINT `fk_RefCommandeID` FOREIGN KEY (`RefCommandeID`) REFERENCES `commandes` (`CommandeID`),
  CONSTRAINT `fk_RefProduitID` FOREIGN KEY (`RefProduitID`) REFERENCES `produits` (`ProduitID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Listage des données de la table weeat.detail_commande : ~4 rows (environ)
DELETE FROM `detail_commande`;
INSERT INTO `detail_commande` (`DetailID`, `Quantite`, `PrixTotal`, `RefCommandeID`, `RefProduitID`) VALUES
	(1, 1, 11, 1, 1),
	(2, 1, 12, 1, 2),
	(3, 2, 24, 2, 2),
	(4, 1, 12, 2, 2);

-- Listage de la structure de table weeat. livraisons
CREATE TABLE IF NOT EXISTS `livraisons` (
  `LivraisonID` int(11) NOT NULL AUTO_INCREMENT,
  `DateLivraison` date NOT NULL,
  `AdresseLivraison` varchar(255) NOT NULL,
  `RefLivreurID` int(11) NOT NULL,
  `RefDetailID` int(11) NOT NULL,
  PRIMARY KEY (`LivraisonID`),
  KEY `fk_RefDetailID` (`RefDetailID`),
  KEY `fk_RefLivreurID` (`RefLivreurID`),
  CONSTRAINT `fk_RefDetailID` FOREIGN KEY (`RefDetailID`) REFERENCES `detail_commande` (`DetailID`),
  CONSTRAINT `fk_RefLivreurID` FOREIGN KEY (`RefLivreurID`) REFERENCES `livreurs` (`LivreurID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Listage des données de la table weeat.livraisons : ~4 rows (environ)
DELETE FROM `livraisons`;
INSERT INTO `livraisons` (`LivraisonID`, `DateLivraison`, `AdresseLivraison`, `RefLivreurID`, `RefDetailID`) VALUES
	(1, '2024-03-30', 'Adresse-Livraison 1', 1, 1),
	(2, '2024-03-30', 'Adresse-Livraison 1', 1, 2),
	(3, '2024-03-30', 'Adresse-Livraison 2', 1, 3),
	(4, '2024-03-30', 'Adresse-Livraison 3', 1, 4);

-- Listage de la structure de table weeat. livreurs
CREATE TABLE IF NOT EXISTS `livreurs` (
  `LivreurID` int(11) NOT NULL AUTO_INCREMENT,
  `Nom` varchar(255) NOT NULL,
  `Prenom` varchar(255) NOT NULL,
  `Telephone` varchar(12) NOT NULL,
  PRIMARY KEY (`LivreurID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Listage des données de la table weeat.livreurs : ~3 rows (environ)
DELETE FROM `livreurs`;
INSERT INTO `livreurs` (`LivreurID`, `Nom`, `Prenom`, `Telephone`) VALUES
	(1, 'LivreurNOM_1', 'LivreurPrenom_1', '0123456711'),
	(2, 'LivreurNOM_2', 'LivreurPrenom_2', '0123456722'),
	(3, 'LivreurNOM_3', 'LivreurPrenom_3', '0123456733');

-- Listage de la structure de table weeat. produits
CREATE TABLE IF NOT EXISTS `produits` (
  `ProduitID` int(11) NOT NULL AUTO_INCREMENT,
  `Nom` varchar(255) NOT NULL,
  `Description` varchar(255) NOT NULL,
  `Prix` double NOT NULL,
  `Stock` int(11) NOT NULL,
  PRIMARY KEY (`ProduitID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Listage des données de la table weeat.produits : ~3 rows (environ)
DELETE FROM `produits`;
INSERT INTO `produits` (`ProduitID`, `Nom`, `Description`, `Prix`, `Stock`) VALUES
	(1, 'Produit_1', 'Produit test 1', 11, 1),
	(2, 'Produit_2', 'Produit test 2', 12, 20),
	(3, 'Produit_3', 'Produit test 3', 13, 3);

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
