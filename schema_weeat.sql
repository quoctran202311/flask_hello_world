CREATE DATABASE IF NOT EXISTS `weeat`;
USE `weeat`;

DROP TABLE IF EXISTS `Livraisons`;
DROP TABLE IF EXISTS `Detail_Commande`;
DROP TABLE IF EXISTS `Commandes`;
DROP TABLE IF EXISTS `Clients`;
DROP TABLE IF EXISTS `Produits`;
DROP TABLE IF EXISTS `Livreurs`;


CREATE TABLE IF NOT EXISTS `Clients`(
    `ClientID` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `Nom` VARCHAR(255) NOT NULL,
    `Prenom` VARCHAR(255) NOT NULL,
    `Email` VARCHAR(255) NOT NULL,
    `Telephone` VARCHAR(12) NOT NULL
);


CREATE TABLE IF NOT EXISTS `Produits`(
    `ProduitID` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `Nom` VARCHAR(255) NOT NULL,
    `Description` VARCHAR(255) NOT NULL,
    `Prix` DOUBLE NOT NULL,
    `Stock` INT NOT NULL
);


CREATE TABLE IF NOT EXISTS `Livreurs`(
    `LivreurID` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `Nom` VARCHAR(255) NOT NULL,
    `Prenom` VARCHAR(255) NOT NULL,
    `Telephone` VARCHAR(12) NOT NULL
);


CREATE TABLE IF NOT EXISTS `Commandes`(
    `CommandeID` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `DateCommande` date NOT NULL,
    `Statut` VARCHAR(255) NOT NULL,
    `RefClientID` INT NOT NULL,
    KEY `fk_RefClientID` (`RefClientID`),
    CONSTRAINT fk_RefClientID FOREIGN KEY (`RefClientID`) REFERENCES `Clients`(`ClientID`)
);


CREATE TABLE IF NOT EXISTS `Detail_Commande`(
    `DetailID` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `Quantite` INT NOT NULL,
    `PrixTotal` INT NOT NULL,
    `RefCommandeID` INT NOT NULL,
    `RefProduitID` INT NOT NULL,
    KEY `fk_RefCommandeID` (`RefCommandeID`),
    CONSTRAINT `fk_RefCommandeID` FOREIGN KEY (`RefCommandeID`) REFERENCES `Commandes`(`CommandeID`),
    KEY `fk_RefProduitID` (`RefProduitID`),
    CONSTRAINT `fk_RefProduitID` FOREIGN KEY (`RefProduitID`) REFERENCES `Produits`(`ProduitID`)
);


CREATE TABLE IF NOT EXISTS `Livraisons`(
    `LivraisonID` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `DateLivraison` DATE NOT NULL,
    `AdresseLivraison` VARCHAR(255) NOT NULL,
    `RefLivreurID` INT NOT NULL,
    `RefDetailID` INT NOT NULL,
    KEY `fk_RefDetailID` (`RefDetailID`),
    CONSTRAINT `fk_RefDetailID` FOREIGN KEY(`RefDetailID`) REFERENCES `Detail_Commande`(`DetailID`),
    KEY `fk_RefLivreurID` (`RefLivreurID`),
    CONSTRAINT `fk_RefLivreurID` FOREIGN KEY(`RefLivreurID`) REFERENCES `Livreurs`(`LivreurID`)
);


USE `tran_weeat`;
INSERT INTO `Clients` (`Nom`, `Prenom`, `Email`, `Telephone`) VALUES
	('CltNOM_1', 'CltPrenom_1', 'CltEmail_1@weeat.fr', '0123456701'),
	('CltNOM_2', 'CltPrenom_2', 'CltEmail_2@weeat.fr', '0123456712'),
	('CltNOM_3', 'CltPrenom_3', 'CltEmail_3@weeat.fr', '0123456723');


USE `tran_weeat`;
INSERT INTO `Livreurs` (`Nom`, `Prenom`, `Telephone`) VALUES
	('LivreurNOM_1', 'LivreurPrenom_1', '0123456711'),
	('LivreurNOM_2', 'LivreurPrenom_2', '0123456722'),
	('LivreurNOM_3', 'LivreurPrenom_3', '0123456733');


USE `tran_weeat`;
INSERT INTO `Produits` (`Nom`, `Description`, `Prix`, `Stock`) VALUES
	('Produit_1', 'Produit test 1', 11.00, 1),
	('Produit_2', 'Produit test 2', 12.00, 20),
	('Produit_3', 'Produit test 3', 13.00, 3);


USE `tran_weeat`;
INSERT INTO `Commandes`(`DateCommande`, `Statut`, `RefClientID`) VALUES
	('2023-11-27', "A-LIVRER", 1),
	('2023-11-27', "A-LIVRER", 1),
	('2023-11-30', "ENCOURS", 1),
	('2023-11-30', "ENCOURS", 2),
	('2023-11-30', "ENCOURS", 2),
	('2024-02-29', "A-LIVRER", 1),
	('2024-02-29', "ENCOURS", 3);


USE `tran_weeat`;
INSERT INTO `Detail_Commande`(`Quantite`, `PrixTotal`, `RefCommandeID`, `RefProduitID`) VALUES
	(1, 11.00, 1, 1),
	(1, 12.00, 1, 2),
	(2, 24.00, 2, 2),
	(1, 12.00, 2, 2);


USE `tran_weeat`;
INSERT INTO `Livraisons`(`DateLivraison`, `AdresseLivraison`, `RefLivreurID`, `RefDetailID`) VALUES
	('2024-03-30', "Adresse-Livraison 1", 1, 5),
	('2024-03-30', "Adresse-Livraison 1", 1, 5),
	('2024-03-30', "Adresse-Livraison 2", 1, 6),
	('2024-03-30', "Adresse-Livraison 3", 1, 7);
