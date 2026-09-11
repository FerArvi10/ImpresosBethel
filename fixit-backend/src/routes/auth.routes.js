const express = require('express');
const router = express.Router();
const authController = require('../controllers/auth.controller');
const { verificarAuth } = require('../middlewares/auth.middleware');

router.post('/register', authController.registro);
router.post('/login', authController.login);
router.get('/profile', verificarAuth, authController.perfil);

module.exports = router;
