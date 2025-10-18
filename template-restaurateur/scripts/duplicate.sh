#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: ./duplicate.sh 'Nom du Restaurant'"
  exit 1
fi

RESTO_NAME="$1"
RESTO_SLUG=$(echo "$RESTO_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')

echo "🚀 Création du restaurant: $RESTO_NAME"
echo "📂 Slug: $RESTO_SLUG"

# Copier le template
cp -r template-restaurateur "../restaurants/$RESTO_SLUG"

cd "../restaurants/$RESTO_SLUG"

# Générer .env
cat > .env << ENVEOF
DATABASE_URL="postgresql://user:password@localhost:5432/${RESTO_SLUG}_db"
NEXTAUTH_SECRET="$(openssl rand -base64 32)"
NEXTAUTH_URL="http://localhost:3000"
RESTAURANT_NAME="$RESTO_NAME"
RESTAURANT_SLUG="$RESTO_SLUG"
ENVEOF

echo "✅ Restaurant créé: restaurants/$RESTO_SLUG"
echo "�� Prochaines étapes:"
echo "   cd restaurants/$RESTO_SLUG"
echo "   npm install"
echo "   npx prisma migrate dev"
echo "   npm run dev"
