#!/bin/bash


# Usage: ./duplicate.sh 'Nom du Restaurant' 'pays-ou-groupe'
set -e

if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: ./duplicate.sh 'Nom du Restaurant' 'pays-ou-groupe'"
  exit 1
fi

RESTO_NAME="$1"
RESTO_PAYS="$2"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
TEMPLATE_DIR="$PROJECT_ROOT"
# Nettoyage du slug (minuscules, tirets, pas de caractères spéciaux)
RESTO_SLUG=$(echo "$RESTO_NAME" | iconv -t ascii//TRANSLIT | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g')
RESTO_PAYS_SLUG=$(echo "$RESTO_PAYS" | iconv -t ascii//TRANSLIT | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-\|-$//g')
RESTAURANTS_ROOT="$PROJECT_ROOT/../restaurants"
TARGET_DIR="$RESTAURANTS_ROOT/$RESTO_PAYS_SLUG/$RESTO_SLUG"


if [ -d "$TARGET_DIR" ]; then
  echo "❌ Le dossier $TARGET_DIR existe déjà. Abandon."
  exit 2
fi

# Créer les dossiers parents si besoin
mkdir -p "$(dirname "$TARGET_DIR")"
# Copier le template
cp -r "$TEMPLATE_DIR" "$TARGET_DIR"
cd "$TARGET_DIR"

echo "🚀 Création du restaurant: $RESTO_NAME ($RESTO_PAYS)"
echo "📂 Dossier: $TARGET_DIR"

# Si un fichier .env.secret existe à la racine du projet, on source les credentials
if [ -f "$PROJECT_ROOT/../.env.secret" ]; then
  source "$PROJECT_ROOT/../.env.secret"
else
  # Valeurs par défaut (à adapter si besoin)
  DB_USER="user"
  DB_PASSWORD="password"
fi

# Générer .env
cat > .env << ENVEOF
DATABASE_URL="postgresql://$DB_USER:$DB_PASSWORD@localhost:5432/${RESTO_SLUG}_db"
NEXTAUTH_SECRET="$(openssl rand -base64 32)"
NEXTAUTH_URL="http://localhost:3000"
RESTAURANT_NAME="$RESTO_NAME"
RESTAURANT_SLUG="$RESTO_SLUG"
RESTAURANT_PAYS="$RESTO_PAYS"
ENVEOF

echo "✅ Restaurant créé: $TARGET_DIR"

echo "📦 Installation des dépendances..."
npm install || { echo '❌ npm install a échoué'; exit 3; }

echo "🗄️ Migration Prisma..."
npx prisma migrate dev --name init || { echo '❌ Migration Prisma échouée'; exit 4; }

echo "🌱 Seed de la base..."
npx prisma db seed || { echo '❌ Seed échoué'; exit 5; }

echo "🎉 Tout est prêt !"
echo "➡️  cd $TARGET_DIR && npm run dev"
