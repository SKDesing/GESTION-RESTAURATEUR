const express = require('express');
const app = express();
const userRoutes = require('./routes/userRoutes');
const restaurantRoutes = require('./routes/restaurantRoutes');

app.use(express.json());
app.use('/api/users', userRoutes);
app.use('/api/restaurants', restaurantRoutes);

app.get('/', (req, res) => {
  res.send('API GESTION RESTAURATEUR opérationnelle');
});


const DEFAULT_PORT = 3000;
const FALLBACK_PORT = 4000;
const PORT = process.env.PORT || DEFAULT_PORT;

const server = app.listen(PORT, () => {
  console.log(`Serveur lancé sur le port ${PORT}`);
});

server.on('error', (err) => {
  if (err.code === 'EADDRINUSE') {
    console.log(`Port ${PORT} occupé, tentative sur le port ${FALLBACK_PORT}...`);
    app.listen(FALLBACK_PORT, () => {
      console.log(`Serveur lancé sur le port ${FALLBACK_PORT}`);
    });
  } else {
    throw err;
  }
});
