# Documentation scripts d'automatisation

## duplicate.sh
Duplique le template-restaurateur dans le dossier restaurants/<nom> et lance l'installation.

## install.sh
Installe les dépendances, génère Prisma, lance la migration et démarre le dev.

## launch.sh
Démarre le serveur de l'instance.

## configure-env.sh
Personnalise le fichier .env d'une instance avec les identifiants PostgreSQL fournis :

```bash
bash scripts/configure-env.sh <chemin_instance> <db_user> <db_password> <db_name>
```

---

Chaque script est à lancer depuis la racine du projet ou le dossier de l'instance.
