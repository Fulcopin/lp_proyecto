// routes/search.routes.js
const express = require('express');
const router = express.Router();
const searchController = require('../controllers/search.controller');

// @route   GET api/search/users
// @desc    Buscar usuarios por edad y ubicación
// @access  Público
router.get('/users', searchController.searchUsers);

module.exports = router;