const express = require('express');
const router = express.Router();
const { getAllRestaurants } = require('../controllers/restaurantController');

router.get('/', getAllRestaurants);

module.exports = router;
