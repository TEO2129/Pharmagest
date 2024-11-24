-- Table des rôles
CREATE TABLE Role (
    id_role SERIAL PRIMARY KEY,
    nom_role VARCHAR(50) NOT NULL
);

-- Table des employés
CREATE TABLE Employee (
    id_employee SERIAL PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    prenom VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    telephone VARCHAR(20),
    adresse TEXT,
    id_role INTEGER REFERENCES Role(id_role)
);

-- Table des utilisateurs
CREATE TABLE Utilisateur (
    id_utilisateur SERIAL PRIMARY KEY,
    nom_utilisateur VARCHAR(255) NOT NULL UNIQUE,
    mot_de_passe VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    id_role INTEGER REFERENCES Role(id_role)
);

-- Table des médicaments
CREATE TABLE Medicament (
    id_medicament SERIAL PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    forme VARCHAR(50),
    famille VARCHAR(50),
    ordonnance BOOLEAN,
    quantite_stock INTEGER,
    seuil_min INTEGER,
    quantite_max INTEGER
);

-- Table des fournisseurs
CREATE TABLE Fournisseur (
    id_fournisseur SERIAL PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    email VARCHAR(255)
);

-- Table des prix fournisseurs
CREATE TABLE PrixFournisseur (
    id_prix_fournisseur SERIAL PRIMARY KEY,
    id_medicament INTEGER REFERENCES Medicament(id_medicament),
    id_fournisseur INTEGER REFERENCES Fournisseur(id_fournisseur),
    prix_achat DECIMAL(10, 2),
    prix_vente DECIMAL(10, 2),
    quantite_min_commande INTEGER
);

-- Table des prescriptions
CREATE TABLE Prescription (
    id_prescription SERIAL PRIMARY KEY,
    nom_medecin VARCHAR(255),
    date_prescription DATE,
    nom_patient VARCHAR(255),
    numero_identification SERIAL UNIQUE
);

-- Table des ventes
CREATE TABLE Vente (
    id_vente SERIAL PRIMARY KEY,
    date_vente DATE,
    total_vente DECIMAL(10, 2),
    paiement_recu BOOLEAN,
    id_prescription INTEGER REFERENCES Prescription(id_prescription),
    id_employee INTEGER REFERENCES Employee(id_employee)
);

-- Table des médicaments vendus
CREATE TABLE VenteMedicament (
    id_vente_medicament SERIAL PRIMARY KEY,
    id_vente INTEGER REFERENCES Vente(id_vente),
    id_medicament INTEGER REFERENCES Medicament(id_medicament),
    quantite INTEGER,
    prix_unitaire DECIMAL(10, 2)
);

-- Table des commandes
CREATE TABLE Commande (
    id_commande SERIAL PRIMARY KEY,
    id_fournisseur INTEGER REFERENCES Fournisseur(id_fournisseur),
    date_commande DATE,
    montant_total DECIMAL(10, 2),
    id_employee INTEGER REFERENCES Employee(id_employee)
);

-- Table des médicaments commandés
CREATE TABLE CommandeMedicament (
    id_commande_medicament SERIAL PRIMARY KEY,
    id_commande INTEGER REFERENCES Commande(id_commande),
    id_medicament INTEGER REFERENCES Medicament(id_medicament),
    quantite_commande INTEGER,
    prix_unitaire_achat DECIMAL(10, 2)
);

-- Procédure stockée pour mettre à jour le stock après réception de commande
CREATE OR REPLACE FUNCTION update_stock_reception()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Medicament
    SET quantite_stock = quantite_stock + NEW.quantite_commande
    WHERE id_medicament = NEW.id_medicament;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_stock_reception
AFTER INSERT ON CommandeMedicament
FOR EACH ROW
EXECUTE FUNCTION update_stock_reception();

-- Déclencheur pour vérifier le seuil de réapprovisionnement
CREATE OR REPLACE FUNCTION check_seuil_approvisionnement()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.quantite_stock < NEW.seuil_min THEN
        -- Logique pour notifier ou lancer automatiquement une commande
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_seuil_approvisionnement
AFTER UPDATE OF quantite_stock ON Medicament
FOR EACH ROW
EXECUTE FUNCTION check_seuil_approvisionnement();
