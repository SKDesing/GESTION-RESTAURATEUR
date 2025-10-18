-- CreateEnum
CREATE TYPE "Role" AS ENUM ('RESTAURATEUR', 'MANAGER', 'SERVEUR', 'CUISINIER', 'CLIENT');

-- CreateEnum
CREATE TYPE "StatutTable" AS ENUM ('DISPONIBLE', 'OCCUPEE', 'RESERVEE', 'NETTOYAGE');

-- CreateEnum
CREATE TYPE "StatutCommande" AS ENUM ('EN_COURS', 'EN_PREPARATION', 'PRETE', 'SERVIE', 'PAYEE', 'ANNULEE');

-- CreateEnum
CREATE TYPE "StatutReservation" AS ENUM ('EN_ATTENTE', 'CONFIRMEE', 'ANNULEE');

-- CreateTable
CREATE TABLE "Groupe" (
    "id" TEXT NOT NULL,
    "nom" TEXT NOT NULL,
    "description" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Groupe_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Etablissement" (
    "id" TEXT NOT NULL,
    "nom" TEXT NOT NULL,
    "adresse" TEXT NOT NULL,
    "telephone" TEXT,
    "email" TEXT,
    "logo" TEXT,
    "SIRET" TEXT,
    "SIREN" TEXT,
    "TVA" DOUBLE PRECISION NOT NULL DEFAULT 0.20,
    "formeJuridique" TEXT,
    "horaires" JSONB,
    "fraisDeService" DOUBLE PRECISION DEFAULT 0,
    "groupeId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Etablissement_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "nom" TEXT NOT NULL,
    "prenom" TEXT NOT NULL,
    "actif" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Employe" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "etablissementId" TEXT NOT NULL,
    "role" "Role" NOT NULL DEFAULT 'SERVEUR',

    CONSTRAINT "Employe_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Menu" (
    "id" TEXT NOT NULL,
    "nom" TEXT NOT NULL,
    "description" TEXT,
    "etablissementId" TEXT NOT NULL,
    "estActif" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Menu_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CategorieMenu" (
    "id" TEXT NOT NULL,
    "nom" TEXT NOT NULL,
    "menuId" TEXT NOT NULL,
    "ordre" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "CategorieMenu_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Plat" (
    "id" TEXT NOT NULL,
    "nom" TEXT NOT NULL,
    "description" TEXT,
    "prix" DOUBLE PRECISION NOT NULL,
    "imageUrl" TEXT,
    "tauxTva" DOUBLE PRECISION NOT NULL DEFAULT 0.20,
    "disponibilite" BOOLEAN NOT NULL DEFAULT true,
    "categorieMenuId" TEXT NOT NULL,
    "allergenes" TEXT,
    "ingredients" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Plat_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Table" (
    "id" TEXT NOT NULL,
    "numero" TEXT NOT NULL,
    "capacite" INTEGER NOT NULL,
    "zone" TEXT,
    "statut" "StatutTable" NOT NULL DEFAULT 'DISPONIBLE',
    "etablissementId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Table_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Reservation" (
    "id" TEXT NOT NULL,
    "nomClient" TEXT NOT NULL,
    "nbCouverts" INTEGER NOT NULL,
    "heureReservation" TIMESTAMP(3) NOT NULL,
    "statut" "StatutReservation" NOT NULL DEFAULT 'EN_ATTENTE',
    "tableId" TEXT NOT NULL,
    "etablissementId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Reservation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Commande" (
    "id" TEXT NOT NULL,
    "montantTotal" DOUBLE PRECISION NOT NULL,
    "datePrise" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "datePaiement" TIMESTAMP(3),
    "modePaiement" TEXT,
    "statut" "StatutCommande" NOT NULL DEFAULT 'EN_COURS',
    "tableId" TEXT NOT NULL,
    "etablissementId" TEXT NOT NULL,
    "serveurId" TEXT NOT NULL,

    CONSTRAINT "Commande_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CommandePlat" (
    "id" TEXT NOT NULL,
    "quantite" INTEGER NOT NULL,
    "prixUnit" DOUBLE PRECISION NOT NULL,
    "commandeId" TEXT NOT NULL,
    "platId" TEXT NOT NULL,

    CONSTRAINT "CommandePlat_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Stock" (
    "id" TEXT NOT NULL,
    "quantiteActuelle" INTEGER NOT NULL,
    "seuilAlerte" INTEGER NOT NULL DEFAULT 5,
    "platId" TEXT NOT NULL,
    "produitId" TEXT,
    "etablissementId" TEXT NOT NULL,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Stock_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Produit" (
    "id" TEXT NOT NULL,
    "nom" TEXT NOT NULL,
    "description" TEXT,
    "prixAchat" DOUBLE PRECISION NOT NULL,
    "fournisseurId" TEXT,

    CONSTRAINT "Produit_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Fournisseur" (
    "id" TEXT NOT NULL,
    "nom" TEXT NOT NULL,
    "contact" TEXT,
    "email" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Fournisseur_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ZCaisse" (
    "id" TEXT NOT NULL,
    "dateCloture" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "caTotalHT" DOUBLE PRECISION NOT NULL,
    "caTotalTTC" DOUBLE PRECISION NOT NULL,
    "totalTvaCollectede" DOUBLE PRECISION NOT NULL,
    "totalEspeces" DOUBLE PRECISION NOT NULL,
    "totalCB" DOUBLE PRECISION NOT NULL,
    "totalCheques" DOUBLE PRECISION NOT NULL,
    "totalTR" DOUBLE PRECISION NOT NULL,
    "nbTickets" INTEGER NOT NULL,
    "ecart" DOUBLE PRECISION,
    "etablissementId" TEXT NOT NULL,

    CONSTRAINT "ZCaisse_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "UserEtablissement" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "etablissementId" TEXT NOT NULL,
    "role" "Role" NOT NULL DEFAULT 'SERVEUR',

    CONSTRAINT "UserEtablissement_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "HistoriquePrix" (
    "id" TEXT NOT NULL,
    "ancienPrix" DOUBLE PRECISION NOT NULL,
    "nouveauPrix" DOUBLE PRECISION NOT NULL,
    "dateChangement" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "platId" TEXT NOT NULL,

    CONSTRAINT "HistoriquePrix_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Etablissement_SIRET_key" ON "Etablissement"("SIRET");

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Employe_userId_key" ON "Employe"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "CommandePlat_commandeId_platId_key" ON "CommandePlat"("commandeId", "platId");

-- CreateIndex
CREATE UNIQUE INDEX "UserEtablissement_userId_etablissementId_key" ON "UserEtablissement"("userId", "etablissementId");

-- AddForeignKey
ALTER TABLE "Etablissement" ADD CONSTRAINT "Etablissement_groupeId_fkey" FOREIGN KEY ("groupeId") REFERENCES "Groupe"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Employe" ADD CONSTRAINT "Employe_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Employe" ADD CONSTRAINT "Employe_etablissementId_fkey" FOREIGN KEY ("etablissementId") REFERENCES "Etablissement"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Menu" ADD CONSTRAINT "Menu_etablissementId_fkey" FOREIGN KEY ("etablissementId") REFERENCES "Etablissement"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CategorieMenu" ADD CONSTRAINT "CategorieMenu_menuId_fkey" FOREIGN KEY ("menuId") REFERENCES "Menu"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Plat" ADD CONSTRAINT "Plat_categorieMenuId_fkey" FOREIGN KEY ("categorieMenuId") REFERENCES "CategorieMenu"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Table" ADD CONSTRAINT "Table_etablissementId_fkey" FOREIGN KEY ("etablissementId") REFERENCES "Etablissement"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Reservation" ADD CONSTRAINT "Reservation_tableId_fkey" FOREIGN KEY ("tableId") REFERENCES "Table"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Reservation" ADD CONSTRAINT "Reservation_etablissementId_fkey" FOREIGN KEY ("etablissementId") REFERENCES "Etablissement"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Commande" ADD CONSTRAINT "Commande_tableId_fkey" FOREIGN KEY ("tableId") REFERENCES "Table"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Commande" ADD CONSTRAINT "Commande_etablissementId_fkey" FOREIGN KEY ("etablissementId") REFERENCES "Etablissement"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Commande" ADD CONSTRAINT "Commande_serveurId_fkey" FOREIGN KEY ("serveurId") REFERENCES "Employe"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CommandePlat" ADD CONSTRAINT "CommandePlat_commandeId_fkey" FOREIGN KEY ("commandeId") REFERENCES "Commande"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CommandePlat" ADD CONSTRAINT "CommandePlat_platId_fkey" FOREIGN KEY ("platId") REFERENCES "Plat"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Stock" ADD CONSTRAINT "Stock_platId_fkey" FOREIGN KEY ("platId") REFERENCES "Plat"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Stock" ADD CONSTRAINT "Stock_produitId_fkey" FOREIGN KEY ("produitId") REFERENCES "Produit"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Stock" ADD CONSTRAINT "Stock_etablissementId_fkey" FOREIGN KEY ("etablissementId") REFERENCES "Etablissement"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Produit" ADD CONSTRAINT "Produit_fournisseurId_fkey" FOREIGN KEY ("fournisseurId") REFERENCES "Fournisseur"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ZCaisse" ADD CONSTRAINT "ZCaisse_etablissementId_fkey" FOREIGN KEY ("etablissementId") REFERENCES "Etablissement"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserEtablissement" ADD CONSTRAINT "UserEtablissement_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserEtablissement" ADD CONSTRAINT "UserEtablissement_etablissementId_fkey" FOREIGN KEY ("etablissementId") REFERENCES "Etablissement"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "HistoriquePrix" ADD CONSTRAINT "HistoriquePrix_platId_fkey" FOREIGN KEY ("platId") REFERENCES "Plat"("id") ON DELETE CASCADE ON UPDATE CASCADE;
