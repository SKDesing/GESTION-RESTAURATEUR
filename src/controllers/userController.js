const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

exports.getAllUsers = async (req, res) => {
  try {
    const users = await prisma.user.findMany();
    res.json(users);
  } catch (error) {
    res.status(500).json({ error: 'Erreur serveur' });
  }
};

exports.loginUser = async (req, res) => {
  const { email, password } = req.body;
  try {
    const user = await prisma.user.findUnique({ where: { email } });
    if (!user || user.password !== password) {
      return res.status(401).json({ error: 'Identifiants invalides' });
    }
    res.json({ message: 'Connexion réussie', user });
  } catch (error) {
    res.status(500).json({ error: 'Erreur serveur' });
  }
};
