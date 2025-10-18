#!/bin/bash
# Script d'installation pour une nouvelle instance de restaurant

set -e

# Installer les dépendances
npm install

# Générer le client Prisma
npx prisma generate

# Lancer les migrations
npx prisma migrate dev --name init

# Démarrer le développement
npm run dev
