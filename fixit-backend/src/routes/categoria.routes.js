const express = require('express');
const router = express.Router();
const categoriaController = require('../controllers/categoria.controller');

router.get('/', categoriaController.listarCategorias);
router.get('/:id', categoriaController.obtenerCategoriaPorId);
router.post('/', categoriaController.crearCategoria);

module.exports = router;
