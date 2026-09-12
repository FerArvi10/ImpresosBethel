const express = require('express');
const router = express.Router();
const authController = require('../controllers/auth.controller');
const { verificarAuth } = require('../middlewares/auth.middleware');

// Rutas de autenticación y registro
router.post('/register', authController.registro);
router.post('/login', authController.login);
router.get('/profile', verificarAuth, authController.perfil);

// Endpoint de verificación de persistencia para demostración académica
router.get('/users', authController.listarUsuarios);

module.exports = router;
