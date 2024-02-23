; -- Projet : POEC - MSPR - WeEat
; -- Database weeat.db
; -- Certains datatypes et autres ont ete rendus compatibles pour SQLite(3)
; -- Creation en ligne de commande
; -- (ou) sqlite3 weeat.db -init schema_weeat.sql
; -- (ou) sqlite3 weeat.db ".read schema_weeat.sql"
; -- (ou) sqlite3 weeat.db < insert_data.sql

; -- CREATE DATABASE IF NOT EXISTS weeat;
; -- USE weeat.db;

; -- Nouvelle livraison - Suppression des anciennes tables 

DROP TABLE IF EXISTS Livraisons;
DROP TABLE IF EXISTS Detail_Commande;
DROP TABLE IF EXISTS Commandes;
DROP TABLE IF EXISTS Clients;
DROP TABLE IF EXISTS Produits;
DROP TABLE IF EXISTS Livreurs;


; -- Nouvelle livraison - Recreation des tables 

CREATE TABLE IF NOT EXISTS Clients(
    ClientID INTEGER PRIMARY KEY AUTOINCREMENT,
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Nom TEXT NOT NULL,
    Prenom TEXT NOT NULL,
    Email TEXT NOT NULL,
    Telephone TEXT NOT NULL
);


CREATE TABLE IF NOT EXISTS Produits(
    ProduitID INTEGER PRIMARY KEY AUTOINCREMENT,
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Nom TEXT NOT NULL,
    Description TEXT NOT NULL,
    Prix DOUBLE NOT NULL,
    Stock INTEGER NOT NULL
);


CREATE TABLE IF NOT EXISTS Livreurs(
    LivreurID INTEGER PRIMARY KEY AUTOINCREMENT,
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Nom TEXT NOT NULL,
    Prenom TEXT NOT NULL,
    Telephone TEXT NOT NULL
);


CREATE TABLE IF NOT EXISTS Commandes(
    CommandeID INTEGER PRIMARY KEY AUTOINCREMENT,
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    DateCommande date NOT NULL,
    Statut TEXT NOT NULL,
    RefClientID INTEGER NOT NULL,
    FOREIGN KEY (RefClientID) REFERENCES "Clients"(ClientID)
);


CREATE TABLE IF NOT EXISTS Detail_Commande(
    DetailID INTEGER PRIMARY KEY AUTOINCREMENT,
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Quantite INTEGER NOT NULL,
    PrixTotal INTEGER NOT NULL,
    RefCommandeID INTEGER NOT NULL,
    RefProduitID INTEGER NOT NULL,
    FOREIGN KEY (RefCommandeID) REFERENCES "Commandes"(CommandeID),
    FOREIGN KEY (RefProduitID) REFERENCES "Produits"(ProduitID)
);


CREATE TABLE IF NOT EXISTS Livraisons(
    LivraisonID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    DateLivraison DATE NOT NULL,
    AdresseLivraison TEXT NOT NULL,
    RefLivreurID INTEGER NOT NULL,
    RefDetailID INTEGER NOT NULL,
    FOREIGN KEY(RefDetailID) REFERENCES "Detail_Commande"(DetailID),
    FOREIGN KEY(RefLivreurID) REFERENCES "Livreurs"(LivreurID)
);
