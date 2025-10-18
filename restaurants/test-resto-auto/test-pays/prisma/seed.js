
const { PrismaClient } = require('@prisma/client');
const bcrypt = require('bcryptjs');
const prisma = new PrismaClient();

async function main() {
  // Exemple de données à adapter selon DATABASE_EXPORT.md
  const users = [
    { email: 'admin@resto.com', name: 'Admin', password: await bcrypt.hash('admin123', 10) },
    { email: 'user@resto.com', name: 'User', password: await bcrypt.hash('user123', 10) }
  ];
  const restaurants = [
    { name: 'Resto Paris', address: '1 rue Paris', phone: '0101010101', franchiseId: 'FR001' }
  ];
  const suppliers = [
    { name: 'Fournisseur 1', contactEmail: 'f1@fournisseur.com', phone: '0202020202', address: '2 rue Fournisseur', isApproved: true }
  ];
  const contracts = [
    { supplierId: 1, franchiseId: 'FR001', startDate: new Date(), endDate: new Date(), terms: 'Contrat standard' }
  ];

  await prisma.user.createMany({ data: users });
  await prisma.restaurant.createMany({ data: restaurants });
  await prisma.supplier.createMany({ data: suppliers });
  await prisma.contract.createMany({ data: contracts });

  console.log('Seed terminé !');
}

main()
  .catch(e => { console.error(e); process.exit(1); })
  .finally(() => prisma.$disconnect());
