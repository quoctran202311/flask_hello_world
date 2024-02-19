; -- sqlite3 Test.db ".read schema_weeat.sql"
; -- sqlite3 Test.db -init schema_weeat.sql
; -- sqlite3 Test.db < insert_data.sql

CREATE DATABASE IF NOT EXISTS weeat;
;USE weeat;

DROP TABLE IF EXISTS Livraisons;
DROP TABLE IF EXISTS Detail_Commande;
DROP TABLE IF EXISTS Commandes;
DROP TABLE IF EXISTS Clients;
DROP TABLE IF EXISTS Produits;
DROP TABLE IF EXISTS Livreurs;


CREATE TABLE IF NOT EXISTS Clients(
    ClientID INT NOT NULL AUTOINCREMENT PRIMARY KEY,
    Nom VARCHAR(255) NOT NULL,
    Prenom VARCHAR(255) NOT NULL,
    Email VARCHAR(255) NOT NULL,
    Telephone VARCHAR(12) NOT NULL
);


CREATE TABLE IF NOT EXISTS Produits(
    ProduitID INT NOT NULL AUTOINCREMENT PRIMARY KEY,
    Nom VARCHAR(255) NOT NULL,
    Description VARCHAR(255) NOT NULL,
    Prix DOUBLE NOT NULL,
    Stock INT NOT NULL
);


CREATE TABLE IF NOT EXISTS Livreurs(
    LivreurID INT NOT NULL AUTOINCREMENT PRIMARY KEY,
    Nom VARCHAR(255) NOT NULL,
    Prenom VARCHAR(255) NOT NULL,
    Telephone VARCHAR(12) NOT NULL
);


CREATE TABLE IF NOT EXISTS Commandes(
    CommandeID INT NOT NULL AUTOINCREMENT PRIMARY KEY,
    DateCommande date NOT NULL,
    Statut VARCHAR(255) NOT NULL,
    RefClientID INT NOT NULL,
    KEY fk_RefClientID (RefClientID),
    CONSTRAINT fk_RefClientID FOREIGN KEY (RefClientID) REFERENCES Clients(ClientID)
);


CREATE TABLE IF NOT EXISTS Detail_Commande(
    DetailID INT NOT NULL AUTOINCREMENT PRIMARY KEY,
    Quantite INT NOT NULL,
    PrixTotal INT NOT NULL,
    RefCommandeID INT NOT NULL,
    RefProduitID INT NOT NULL,
    KEY fk_RefCommandeID (RefCommandeID),
    CONSTRAINT fk_RefCommandeID FOREIGN KEY (RefCommandeID) REFERENCES Commandes(CommandeID),
    KEY fk_RefProduitID (RefProduitID),
    CONSTRAINT fk_RefProduitID FOREIGN KEY (RefProduitID) REFERENCES Produits(ProduitID)
);


CREATE TABLE IF NOT EXISTS Livraisons(
    LivraisonID INT NOT NULL AUTOINCREMENT PRIMARY KEY,
    DateLivraison DATE NOT NULL,
    AdresseLivraison VARCHAR(255) NOT NULL,
    RefLivreurID INT NOT NULL,
    RefDetailID INT NOT NULL,
    KEY fk_RefDetailID (RefDetailID),
    CONSTRAINT fk_RefDetailID FOREIGN KEY(RefDetailID) REFERENCES Detail_Commande(DetailID),
    KEY fk_RefLivreurID (RefLivreurID),
    CONSTRAINT fk_RefLivreurID FOREIGN KEY(RefLivreurID) REFERENCES Livreurs(LivreurID)
);
