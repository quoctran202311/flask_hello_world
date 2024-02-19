-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: mysql-tran.alwaysdata.net
-- Generation Time: Feb 19, 2024 at 03:27 PM
-- Server version: 10.6.16-MariaDB
-- PHP Version: 7.4.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `tran_weeat`
--
CREATE DATABASE IF NOT EXISTS `tran_weeat` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `tran_weeat`;

-- --------------------------------------------------------

--
-- Table structure for table `Clients`
--

CREATE TABLE `Clients` (
  `ClientID` int(11) NOT NULL,
  `Nom` varchar(255) NOT NULL,
  `Prenom` varchar(255) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `Telephone` varchar(12) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Clients`
--

INSERT INTO `Clients` (`ClientID`, `Nom`, `Prenom`, `Email`, `Telephone`) VALUES
(1, 'CltNOM_1', 'CltPrenom_1', 'CltEmail_1@weeat.fr', '0123456701'),
(2, 'CltNOM_2', 'CltPrenom_2', 'CltEmail_2@weeat.fr', '0123456712'),
(3, 'CltNOM_3', 'CltPrenom_3', 'CltEmail_3@weeat.fr', '0123456723');

-- --------------------------------------------------------

--
-- Table structure for table `Commandes`
--

CREATE TABLE `Commandes` (
  `CommandeID` int(11) NOT NULL,
  `DateCommande` date NOT NULL,
  `Statut` varchar(255) NOT NULL,
  `RefClientID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Commandes`
--

INSERT INTO `Commandes` (`CommandeID`, `DateCommande`, `Statut`, `RefClientID`) VALUES
(1, '2023-11-27', 'A-LIVRER', 1),
(2, '2023-11-27', 'A-LIVRER', 1),
(3, '2023-11-30', 'ENCOURS', 1),
(4, '2023-11-30', 'ENCOURS', 2),
(5, '2023-11-30', 'ENCOURS', 2),
(6, '2024-02-29', 'A-LIVRER', 1),
(7, '2024-02-29', 'ENCOURS', 3);

-- --------------------------------------------------------

--
-- Table structure for table `Detail_Commande`
--

CREATE TABLE `Detail_Commande` (
  `DetailID` int(11) NOT NULL,
  `Quantite` int(11) NOT NULL,
  `PrixTotal` int(11) NOT NULL,
  `RefCommandeID` int(11) NOT NULL,
  `RefProduitID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Detail_Commande`
--

INSERT INTO `Detail_Commande` (`DetailID`, `Quantite`, `PrixTotal`, `RefCommandeID`, `RefProduitID`) VALUES
(5, 1, 11, 1, 1),
(6, 1, 12, 1, 2),
(7, 2, 24, 2, 2),
(8, 1, 12, 2, 2);

-- --------------------------------------------------------

--
-- Table structure for table `Livraisons`
--

CREATE TABLE `Livraisons` (
  `LivraisonID` int(11) NOT NULL,
  `DateLivraison` date NOT NULL,
  `AdresseLivraison` varchar(255) NOT NULL,
  `RefLivreurID` int(11) NOT NULL,
  `RefDetailID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Livraisons`
--

INSERT INTO `Livraisons` (`LivraisonID`, `DateLivraison`, `AdresseLivraison`, `RefLivreurID`, `RefDetailID`) VALUES
(9, '2024-03-30', 'Adresse-Livraison 1', 1, 5),
(10, '2024-03-30', 'Adresse-Livraison 1', 1, 5),
(11, '2024-03-30', 'Adresse-Livraison 2', 1, 6),
(12, '2024-03-30', 'Adresse-Livraison 3', 1, 7);

-- --------------------------------------------------------

--
-- Table structure for table `Livreurs`
--

CREATE TABLE `Livreurs` (
  `LivreurID` int(11) NOT NULL,
  `Nom` varchar(255) NOT NULL,
  `Prenom` varchar(255) NOT NULL,
  `Telephone` varchar(12) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Livreurs`
--

INSERT INTO `Livreurs` (`LivreurID`, `Nom`, `Prenom`, `Telephone`) VALUES
(1, 'LivreurNOM_1', 'LivreurPrenom_1', '0123456711'),
(2, 'LivreurNOM_2', 'LivreurPrenom_2', '0123456722'),
(3, 'LivreurNOM_3', 'LivreurPrenom_3', '0123456733');

-- --------------------------------------------------------

--
-- Table structure for table `Produits`
--

CREATE TABLE `Produits` (
  `ProduitID` int(11) NOT NULL,
  `Nom` varchar(255) NOT NULL,
  `Description` varchar(255) NOT NULL,
  `Prix` double NOT NULL,
  `Stock` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `Produits`
--

INSERT INTO `Produits` (`ProduitID`, `Nom`, `Description`, `Prix`, `Stock`) VALUES
(1, 'Produit_1', 'Produit test 1', 11, 1),
(2, 'Produit_2', 'Produit test 2', 12, 20),
(3, 'Produit_3', 'Produit test 3', 13, 3);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `Clients`
--
ALTER TABLE `Clients`
  ADD PRIMARY KEY (`ClientID`);

--
-- Indexes for table `Commandes`
--
ALTER TABLE `Commandes`
  ADD PRIMARY KEY (`CommandeID`),
  ADD KEY `fk_RefClientID` (`RefClientID`);

--
-- Indexes for table `Detail_Commande`
--
ALTER TABLE `Detail_Commande`
  ADD PRIMARY KEY (`DetailID`),
  ADD KEY `fk_RefCommandeID` (`RefCommandeID`),
  ADD KEY `fk_RefProduitID` (`RefProduitID`);

--
-- Indexes for table `Livraisons`
--
ALTER TABLE `Livraisons`
  ADD PRIMARY KEY (`LivraisonID`),
  ADD KEY `fk_RefDetailID` (`RefDetailID`),
  ADD KEY `fk_RefLivreurID` (`RefLivreurID`);

--
-- Indexes for table `Livreurs`
--
ALTER TABLE `Livreurs`
  ADD PRIMARY KEY (`LivreurID`);

--
-- Indexes for table `Produits`
--
ALTER TABLE `Produits`
  ADD PRIMARY KEY (`ProduitID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `Clients`
--
ALTER TABLE `Clients`
  MODIFY `ClientID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `Commandes`
--
ALTER TABLE `Commandes`
  MODIFY `CommandeID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `Detail_Commande`
--
ALTER TABLE `Detail_Commande`
  MODIFY `DetailID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `Livraisons`
--
ALTER TABLE `Livraisons`
  MODIFY `LivraisonID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `Livreurs`
--
ALTER TABLE `Livreurs`
  MODIFY `LivreurID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `Produits`
--
ALTER TABLE `Produits`
  MODIFY `ProduitID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `Commandes`
--
ALTER TABLE `Commandes`
  ADD CONSTRAINT `fk_RefClientID` FOREIGN KEY (`RefClientID`) REFERENCES `Clients` (`ClientID`);

--
-- Constraints for table `Detail_Commande`
--
ALTER TABLE `Detail_Commande`
  ADD CONSTRAINT `fk_RefCommandeID` FOREIGN KEY (`RefCommandeID`) REFERENCES `Commandes` (`CommandeID`),
  ADD CONSTRAINT `fk_RefProduitID` FOREIGN KEY (`RefProduitID`) REFERENCES `Produits` (`ProduitID`);

--
-- Constraints for table `Livraisons`
--
ALTER TABLE `Livraisons`
  ADD CONSTRAINT `fk_RefDetailID` FOREIGN KEY (`RefDetailID`) REFERENCES `Detail_Commande` (`DetailID`),
  ADD CONSTRAINT `fk_RefLivreurID` FOREIGN KEY (`RefLivreurID`) REFERENCES `Livreurs` (`LivreurID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
