const express = require('express');
const router = express.Router();
const pedidoController = require('../controllers/pedido.controller');

router.get('/', pedidoController.listarPedidos);
router.get('/:codigo', pedidoController.obtenerPedidoPorCodigo);
router.post('/', pedidoController.crearPedido);
router.patch('/:codigo/estado', pedidoController.actualizarEstadoPedido);

module.exports = router;
