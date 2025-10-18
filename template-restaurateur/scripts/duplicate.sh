#!/bin/bash
# Script pour dupliquer le template et créer une nouvelle instance de restaurant

set -e

if [ -z "$1" ]; then
  echo "Usage: $0 <nom_du_restaurant>"
  exit 1
fi

RESTAURANT_NAME=$1
cp -r ../template-restaurateur ../restaurants/$RESTAURANT_NAME
cd ../restaurants/$RESTAURANT_NAME
bash scripts/install.sh
