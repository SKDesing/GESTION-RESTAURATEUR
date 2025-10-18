# Template Restaurateur

Ce dossier sert de modèle pour la création d'une nouvelle instance de restaurant.

## Structure
- `prisma/` : Fichiers Prisma ORM (schema, migrations, .env)
- `src/api/` : Backend Express (routes, controllers, middleware)
- `src/caisse/` : Module caisse (gestion des ventes, tickets, etc.)
- `src/serveur/` : Module serveur (prise de commande, gestion tables)
- `src/cuisine/` : Module cuisine (gestion des plats, préparation)
- `src/admin/` : Module administration (utilisateurs, reporting)
- `scripts/` : Scripts d'automatisation (duplication, migration, etc.)
- `config/` : Fichiers de configuration spécifiques

## Utilisation
1. Dupliquez ce dossier pour chaque nouveau restaurant.
2. Adaptez la configuration et la base de données.
3. Lancez les scripts d'installation et de migration.

---

*Ce template est la base de tout nouveau restaurant dans le système multi-restaurateur.*
