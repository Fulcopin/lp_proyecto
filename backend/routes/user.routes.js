// routes/user.routes.js
const express = require('express');
const router = express.Router();
const userController = require('../controllers/user.controller');
const authMiddleware = require('../middleware/auth.middleware'); // Importa el middleware de autenticación

// @route   POST api/users/register
// @desc    Registrar un usuario
// @access  Público
router.post('/register', userController.registerUser);

// @route   POST api/users/profile
// @desc    Crear o actualizar el perfil de un usuario
// @access  Privado (requiere autenticación)
router.post('/profile',  userController.createOrUpdateProfile);

// @route   GET api/users/profile/:userId
// @desc    Obtener el perfil de un usuario por ID
// @access  Público
router.get('/profile/:userId', userController.getProfile);
router.post('/login', userController.loginUser);

module.exports = router;