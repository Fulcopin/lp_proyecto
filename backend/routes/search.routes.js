const express = require('express');
const router = express.Router();
const searchController = require('../controllers/search.controller');
const { query, validationResult } = require('express-validator');

// Request logger
router.use((req, res, next) => {
    console.log('Search Request:', {
        path: req.path,
        query: req.query,
        headers: req.headers
    });
    next();
});

// Validation middleware
router.get('/', [
    query('edadMin')
        .optional()
        .isInt({ min: 18, max: 100 })
        .withMessage('Edad mínima debe ser entre 18 y 100'),
    query('edadMax')
        .optional()
        .isInt({ min: 18, max: 100 })
        .withMessage('Edad máxima debe ser entre 18 y 100'),
    query('location')
        .optional()
        .isString()
        .trim()
        .withMessage('Ubicación debe ser texto válido')
], (req, res, next) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }
    next();
}, searchController.searchUsers);

module.exports = router;