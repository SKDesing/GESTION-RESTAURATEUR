const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

exports.getAllRestaurants = async (req, res) => {
  try {
    const restaurants = await prisma.restaurant.findMany();
    res.json(restaurants);
  } catch (error) {
    res.status(500).json({ error: 'Erreur serveur' });
  }
};
