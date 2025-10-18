// Script de seed Prisma pour le template restaurateur
const { PrismaClient } = require('@prisma/client');
const bcrypt = require('bcrypt');
const prisma = new PrismaClient();

async function main() {
  const users = [
    { email: 'admin@resto.com', name: 'Admin', password: await bcrypt.hash('admin123', 10) },
    { email: 'user@resto.com', name: 'User', password: await bcrypt.hash('user123', 10) }
  ];
  await prisma.user.createMany({ data: users });
  // Ajoute ici d'autres seeds si besoin
}

main()
  .catch((e) => { console.error(e); process.exit(1); })
  .finally(async () => { await prisma.$disconnect(); });
