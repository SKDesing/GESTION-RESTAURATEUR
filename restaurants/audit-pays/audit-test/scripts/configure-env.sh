#!/bin/bash
# Script pour personnaliser le .env d'une instance de restaurant

set -e

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ]; then
  echo "Usage: $0 <restaurant_path> <db_user> <db_password> <db_name>"
  exit 1
fi

RESTAURANT_PATH=$1
DB_USER=$2
DB_PASSWORD=$3
DB_NAME=$4

cat > "$RESTAURANT_PATH/prisma/.env" <<EOF
DATABASE_URL="postgresql://$DB_USER:$DB_PASSWORD@localhost:5432/$DB_NAME"
EOF

echo ".env personnalisé pour $RESTAURANT_PATH"
