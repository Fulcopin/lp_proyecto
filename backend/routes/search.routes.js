const express = require('express');
const router = express.Router();
const searchController = require('../controllers/search.controller');
const { query, validationResult } = require('express-validator');

router.get('/', [
    query('edad').optional().isInt().withMessage('Edad debe ser un número entero'),
    query('ubicacion').optional().isString().withMessage('Ubicación debe ser una cadena de texto'),
    query('edadMin').optional().isInt().withMessage('Edad mínima debe ser un número entero'),
    query('edadMax').optional().isInt().withMessage('Edad máxima debe ser un número entero'),
], searchController.searchUsers);

module.exports = router;