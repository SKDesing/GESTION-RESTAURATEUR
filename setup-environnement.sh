#!/bin/bash

# ANSI Color Codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=====================================================${NC}"
echo -e "${BLUE}  SCRIPT D'INSTALLATION DE L'ÉCOSYSTÈME COMPLET     ${NC}"
echo -e "${BLUE}=====================================================${NC}"

# === ÉTAPE 1: VÉRIFICATION DES PRÉREQUIS ===
echo -e "\n${YELLOW}[ÉTAPE 1/6] Vérification des prérequis (Docker, Node.js, Python)...${NC}"
command -v docker >/dev/null 2>&1 || { echo -e >&2 "${RED}ERREUR: Docker n'est pas installé. Abandon.${NC}"; exit 1; }
command -v docker-compose >/dev/null 2>&1 || { echo -e >&2 "${RED}ERREUR: Docker Compose n'est pas installé. Abandon.${NC}"; exit 1; }
command -v node >/dev/null 2>&1 || { echo -e >&2 "${RED}ERREUR: Node.js n'est pas installé. Abandon.${NC}"; exit 1; }
command -v python3 >/dev/null 2>&1 || { echo -e >&2 "${RED}ERREUR: Python 3 n'est pas installé. Abandon.${NC}"; exit 1; }
echo -e "${GREEN}Prérequis validés.${NC}"

# === ÉTAPE 2: CONFIGURATION PYTHON ===
echo -e "\n${YELLOW}[ÉTAPE 2/6] Configuration de l'environnement virtuel Python...${NC}"
if [ ! -d ".venv" ]; then
    echo "Création de l'environnement virtuel Python dans './.venv'..."
    python3 -m venv .venv
    if [ $? -ne 0 ]; then
        echo -e "${RED}ERREUR: La création de l'environnement virtuel Python a échoué. Abandon.${NC}"
        exit 1
    fi
    echo -e "${GREEN}Environnement virtuel créé.${NC}"
else
    echo -e "${GREEN}L'environnement virtuel './.venv' existe déjà.${NC}"
fi

echo "Activation de l'environnement et installation des dépendances depuis 'requirements.txt'..."
source .venv/bin/activate
pip install -r requirements.txt
if [ $? -ne 0 ]; then
    echo -e "${RED}ERREUR: L'installation des dépendances Python a échoué. Abandon.${NC}"
    exit 1
fi
deactivate
echo -e "${GREEN}Dépendances Python installées avec succès dans .venv.${NC}"

# === ÉTAPE 3: CONFIGURATION NODE.JS ===
echo -e "\n${YELLOW}[ÉTAPE 3/6] Configuration du fichier d'environnement Node.js (.env)...${NC}"
if [ ! -f .env ]; then
    cp .env.example .env
    echo -e "${GREEN}Fichier '.env' créé à partir de '.env.example'.${NC}"
    echo -e "${YELLOW}VEUILLEZ VÉRIFIER et COMPLÉTER les variables dans le fichier '.env' AVANT de continuer.${NC}"
    read -p "Appuyez sur [Entrée] pour continuer une fois le fichier .env configuré..."
else
    echo -e "${GREEN}Le fichier '.env' existe déjà.${NC}"
fi

# === ÉTAPE 4: DÉMARRAGE DE L'INFRASTRUCTURE DOCKER ===
echo -e "\n${YELLOW}[ÉTAPE 4/6] Démarrage de tous les services via Docker Compose...${NC}"
docker-compose up --build -d
if [ $? -ne 0 ]; then
    echo -e "${RED}ERREUR: Le démarrage de Docker Compose a échoué. Abandon.${NC}"
    exit 1
fi
echo -e "${GREEN}Tous les services Docker ont été démarrés.${NC}"

# === ÉTAPE 5: MIGRATION DE LA BASE DE DONNÉES ===
echo -e "\n${YELLOW}[ÉTAPE 5/6] Application des migrations Prisma...${NC}"
echo "Pause de 15 secondes pour assurer que PostgreSQL est prêt..."
sleep 15
docker-compose exec app npx prisma migrate deploy
if [ $? -ne 0 ]; then
    echo -e "${RED}ERREUR: Les migrations Prisma ont échoué. Abandon.${NC}"
    exit 1
fi
echo -e "${GREEN}Migrations appliquées.${NC}"

# === ÉTAPE 6: PEUPLEMENT COMPLET DE LA BASE DE DONNÉES ===
echo -e "\n${YELLOW}[ÉTAPE 6/6] Exécution du script de 'seed' pour injecter TOUTES les données...${NC}"
docker-compose exec app npx prisma db seed
if [ $? -ne 0 ]; then
    echo -e "${RED}ERREUR: Le script 'prisma db seed' a échoué !${NC}"
    exit 1
fi
echo -e "${GREEN}Base de données peuplée.${NC}"

# === FINALISATION ===
echo -e "\n${GREEN}=====================================================${NC}"
echo -e "${GREEN}   INSTALLATION TERMINÉE AVEC SUCCÈS !             ${NC}"
echo -e "${GREEN}=====================================================${NC}"
echo -e "\nL'environnement est 100% opérationnel."
echo -e "  - ${BLUE}Services Docker :${NC} (vérifiez avec 'docker-compose ps')"
docker-compose ps
echo -e "\n  - ${BLUE}Pour explorer la DB :${NC} npx prisma studio"
echo -e "  - ${BLUE}Pour travailler sur les scripts Python, activez le venv :${NC} source .venv/bin/activate"
echo -e "\n${YELLOW}Les tests peuvent commencer.${NC}"
