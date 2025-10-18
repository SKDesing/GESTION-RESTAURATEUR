-- CreateEnum
CREATE TYPE "Role" AS ENUM ('ADMIN', 'MANAGER', 'EMPLOYE', 'CUISINIER');

-- CreateEnum
CREATE TYPE "StatutReservation" AS ENUM ('EN_ATTENTE', 'CONFIRMEE', 'ANNULEE', 'TERMINEE');

-- CreateEnum
CREATE TYPE "StatutCommande" AS ENUM ('EN_COURS', 'SERVIE', 'PAYEE', 'ANNULEE');

-- CreateEnum
CREATE TYPE "ModePaiement" AS ENUM ('ESPECES', 'CARTE_BANCAIRE', 'TICKET_RESTAURANT', 'AUTRE');

-- CreateTable
CREATE TABLE "groupes" (
    "id" TEXT NOT NULL,
    "nom" TEXT NOT NULL,
    "logo" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "groupes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "etablissements" (
    "id" TEXT NOT NULL,
    "nom" TEXT NOT NULL,
    "enseigne" TEXT NOT NULL,
    "siren" TEXT NOT NULL,
    "siret" TEXT NOT NULL,
    "tva" TEXT NOT NULL,
    "formeJuridique" TEXT NOT NULL,
    "adresse" TEXT NOT NULL,
    "codePostal" TEXT NOT NULL,
    "ville" TEXT NOT NULL,
    "telephone" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "gpsLat" DOUBLE PRECISION,
    "gpsLng" DOUBLE PRECISION,
    "groupeId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "etablissements_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "users" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "nom" TEXT NOT NULL,
    "prenom" TEXT NOT NULL,
    "role" "Role" NOT NULL DEFAULT 'EMPLOYE',
    "actif" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "employes" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "etablissementId" TEXT NOT NULL,
    "poste" TEXT NOT NULL,
    "tauxHoraire" DOUBLE PRECISION NOT NULL,
    "dateEmbauche" TIMESTAMP(3) NOT NULL,
    "dateSortie" TIMESTAMP(3),
    "actif" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "employes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "categories_produits" (
    "id" TEXT NOT NULL,
    "nom" TEXT NOT NULL,
    "ordre" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "categories_produits_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "produits" (
    "id" TEXT NOT NULL,
    "nom" TEXT NOT NULL,
    "reference" TEXT NOT NULL,
    "unite" TEXT NOT NULL,
    "categorieId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "produits_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "stocks" (
    "id" TEXT NOT NULL,
    "produitId" TEXT NOT NULL,
    "etablissementId" TEXT NOT NULL,
    "quantite" DOUBLE PRECISION NOT NULL,
    "seuilAlerte" DOUBLE PRECISION NOT NULL,
    "prixUnitaire" DOUBLE PRECISION NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "stocks_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "allergenes" (
    "id" TEXT NOT NULL,
    "nom" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "allergenes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "categories_menu" (
    "id" TEXT NOT NULL,
    "nom" TEXT NOT NULL,
    "ordre" INTEGER NOT NULL DEFAULT 0,
    "etablissementId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "categories_menu_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "plats" (
    "id" TEXT NOT NULL,
    "nom" TEXT NOT NULL,
    "description" TEXT,
    "prix" DOUBLE PRECISION NOT NULL,
    "prixTTC" DOUBLE PRECISION NOT NULL,
    "tauxTVA" INTEGER NOT NULL DEFAULT 10,
    "disponible" BOOLEAN NOT NULL DEFAULT true,
    "categorieId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "plats_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "plats_ingredients" (
    "id" TEXT NOT NULL,
    "platId" TEXT NOT NULL,
    "produitId" TEXT NOT NULL,
    "quantite" DOUBLE PRECISION NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "plats_ingredients_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tables" (
    "id" TEXT NOT NULL,
    "numero" INTEGER NOT NULL,
    "capacite" INTEGER NOT NULL,
    "zone" TEXT,
    "etablissementId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "tables_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "reservations" (
    "id" TEXT NOT NULL,
    "dateReservation" TIMESTAMP(3) NOT NULL,
    "nombrePersonnes" INTEGER NOT NULL,
    "nomClient" TEXT NOT NULL,
    "telephoneClient" TEXT NOT NULL,
    "emailClient" TEXT,
    "commentaire" TEXT,
    "statut" "StatutReservation" NOT NULL DEFAULT 'EN_ATTENTE',
    "tableId" TEXT NOT NULL,
    "etablissementId" TEXT NOT NULL,
    "employeId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "reservations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "commandes" (
    "id" TEXT NOT NULL,
    "numeroCommande" TEXT NOT NULL,
    "statut" "StatutCommande" NOT NULL DEFAULT 'EN_COURS',
    "tableId" TEXT NOT NULL,
    "etablissementId" TEXT NOT NULL,
    "employeId" TEXT NOT NULL,
    "montantHT" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "montantTVA" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "montantTTC" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "modePaiement" "ModePaiement",
    "datePaiement" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "commandes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "commandes_plats" (
    "id" TEXT NOT NULL,
    "commandeId" TEXT NOT NULL,
    "platId" TEXT NOT NULL,
    "quantite" INTEGER NOT NULL DEFAULT 1,
    "prixUnitaire" DOUBLE PRECISION NOT NULL,
    "commentaire" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "commandes_plats_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "fournisseurs" (
    "id" TEXT NOT NULL,
    "nom" TEXT NOT NULL,
    "contactNom" TEXT,
    "contactEmail" TEXT NOT NULL,
    "contactTel" TEXT,
    "adresse" TEXT NOT NULL,
    "siret" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "fournisseurs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "fournisseurs_etablissements" (
    "fournisseurId" TEXT NOT NULL,
    "etablissementId" TEXT NOT NULL,
    "actif" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "fournisseurs_etablissements_pkey" PRIMARY KEY ("fournisseurId","etablissementId")
);

-- CreateTable
CREATE TABLE "z_caisses" (
    "id" TEXT NOT NULL,
    "etablissementId" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "nombreTickets" INTEGER NOT NULL,
    "chiffreAffaires" DOUBLE PRECISION NOT NULL,
    "montantEspeces" DOUBLE PRECISION NOT NULL,
    "montantCB" DOUBLE PRECISION NOT NULL,
    "montantTickets" DOUBLE PRECISION NOT NULL,
    "montantAutres" DOUBLE PRECISION NOT NULL,
    "totalTVA10" DOUBLE PRECISION NOT NULL,
    "totalTVA20" DOUBLE PRECISION NOT NULL,
    "fondCaisseDebut" DOUBLE PRECISION NOT NULL,
    "fondCaisseFin" DOUBLE PRECISION NOT NULL,
    "cloture" BOOLEAN NOT NULL DEFAULT false,
    "clotureAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "z_caisses_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_PlatAllergenes" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "etablissements_siren_key" ON "etablissements"("siren");

-- CreateIndex
CREATE UNIQUE INDEX "etablissements_siret_key" ON "etablissements"("siret");

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "employes_userId_key" ON "employes"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "produits_reference_key" ON "produits"("reference");

-- CreateIndex
CREATE UNIQUE INDEX "stocks_produitId_etablissementId_key" ON "stocks"("produitId", "etablissementId");

-- CreateIndex
CREATE UNIQUE INDEX "allergenes_nom_key" ON "allergenes"("nom");

-- CreateIndex
CREATE UNIQUE INDEX "plats_ingredients_platId_produitId_key" ON "plats_ingredients"("platId", "produitId");

-- CreateIndex
CREATE UNIQUE INDEX "tables_numero_etablissementId_key" ON "tables"("numero", "etablissementId");

-- CreateIndex
CREATE UNIQUE INDEX "commandes_numeroCommande_key" ON "commandes"("numeroCommande");

-- CreateIndex
CREATE UNIQUE INDEX "z_caisses_etablissementId_date_key" ON "z_caisses"("etablissementId", "date");

-- CreateIndex
CREATE UNIQUE INDEX "_PlatAllergenes_AB_unique" ON "_PlatAllergenes"("A", "B");

-- CreateIndex
CREATE INDEX "_PlatAllergenes_B_index" ON "_PlatAllergenes"("B");

-- AddForeignKey
ALTER TABLE "etablissements" ADD CONSTRAINT "etablissements_groupeId_fkey" FOREIGN KEY ("groupeId") REFERENCES "groupes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "employes" ADD CONSTRAINT "employes_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "employes" ADD CONSTRAINT "employes_etablissementId_fkey" FOREIGN KEY ("etablissementId") REFERENCES "etablissements"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "produits" ADD CONSTRAINT "produits_categorieId_fkey" FOREIGN KEY ("categorieId") REFERENCES "categories_produits"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "stocks" ADD CONSTRAINT "stocks_produitId_fkey" FOREIGN KEY ("produitId") REFERENCES "produits"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "stocks" ADD CONSTRAINT "stocks_etablissementId_fkey" FOREIGN KEY ("etablissementId") REFERENCES "etablissements"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "categories_menu" ADD CONSTRAINT "categories_menu_etablissementId_fkey" FOREIGN KEY ("etablissementId") REFERENCES "etablissements"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "plats" ADD CONSTRAINT "plats_categorieId_fkey" FOREIGN KEY ("categorieId") REFERENCES "categories_menu"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "plats_ingredients" ADD CONSTRAINT "plats_ingredients_platId_fkey" FOREIGN KEY ("platId") REFERENCES "plats"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "plats_ingredients" ADD CONSTRAINT "plats_ingredients_produitId_fkey" FOREIGN KEY ("produitId") REFERENCES "produits"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tables" ADD CONSTRAINT "tables_etablissementId_fkey" FOREIGN KEY ("etablissementId") REFERENCES "etablissements"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reservations" ADD CONSTRAINT "reservations_tableId_fkey" FOREIGN KEY ("tableId") REFERENCES "tables"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reservations" ADD CONSTRAINT "reservations_etablissementId_fkey" FOREIGN KEY ("etablissementId") REFERENCES "etablissements"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reservations" ADD CONSTRAINT "reservations_employeId_fkey" FOREIGN KEY ("employeId") REFERENCES "employes"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "commandes" ADD CONSTRAINT "commandes_tableId_fkey" FOREIGN KEY ("tableId") REFERENCES "tables"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "commandes" ADD CONSTRAINT "commandes_etablissementId_fkey" FOREIGN KEY ("etablissementId") REFERENCES "etablissements"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "commandes" ADD CONSTRAINT "commandes_employeId_fkey" FOREIGN KEY ("employeId") REFERENCES "employes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "commandes_plats" ADD CONSTRAINT "commandes_plats_commandeId_fkey" FOREIGN KEY ("commandeId") REFERENCES "commandes"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "commandes_plats" ADD CONSTRAINT "commandes_plats_platId_fkey" FOREIGN KEY ("platId") REFERENCES "plats"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fournisseurs_etablissements" ADD CONSTRAINT "fournisseurs_etablissements_fournisseurId_fkey" FOREIGN KEY ("fournisseurId") REFERENCES "fournisseurs"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "fournisseurs_etablissements" ADD CONSTRAINT "fournisseurs_etablissements_etablissementId_fkey" FOREIGN KEY ("etablissementId") REFERENCES "etablissements"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "z_caisses" ADD CONSTRAINT "z_caisses_etablissementId_fkey" FOREIGN KEY ("etablissementId") REFERENCES "etablissements"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_PlatAllergenes" ADD CONSTRAINT "_PlatAllergenes_A_fkey" FOREIGN KEY ("A") REFERENCES "allergenes"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_PlatAllergenes" ADD CONSTRAINT "_PlatAllergenes_B_fkey" FOREIGN KEY ("B") REFERENCES "plats"("id") ON DELETE CASCADE ON UPDATE CASCADE;
