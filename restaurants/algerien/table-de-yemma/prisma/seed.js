
const { PrismaClient } = require('@prisma/client');
const bcrypt = require('bcryptjs');
const prisma = new PrismaClient();

async function main() {
  // Seed uniquement le modèle User (présent dans le schéma)
  const users = [
    {
      email: 'admin@resto.com',
      password: await bcrypt.hash('admin123', 10),
      nom: 'Admin',
      prenom: 'Super',
      role: 'RESTAURATEUR',
      actif: true
    },
    {
      email: 'user@resto.com',
      password: await bcrypt.hash('user123', 10),
      nom: 'User',
      prenom: 'Employé',
      role: 'SERVEUR',
      actif: true
    }
  ];
  await prisma.user.createMany({ data: users });
  console.log('Seed terminé !');
}

main()
  .catch(e => { console.error(e); process.exit(1); })
  .finally(() => prisma.$disconnect());
