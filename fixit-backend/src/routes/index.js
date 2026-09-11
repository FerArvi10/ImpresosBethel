const express = require('express');
const router = express.Router();

const proveedorRoutes = require('./proveedor.routes');
const categoriaRoutes = require('./categoria.routes');
const productoRoutes = require('./producto.routes');
const pedidoRoutes = require('./pedido.routes');
const authRoutes = require('./auth.routes');
const { sequelize } = require('../config/database');

// Verificación de estado del servidor
router.get('/health', async (req, res) => {
  let bdConectada = false;
  try {
    await sequelize.authenticate();
    bdConectada = true;
  } catch (_) {
    bdConectada = false;
  }

  return res.status(200).json({
    status: 'online',
    app: 'Impresos Bethel Backend API',
    version: '1.0.0',
    database: bdConectada ? 'conectada' : 'desconectada',
    timestamp: new Date().toISOString(),
    uptime: `${process.uptime().toFixed(0)} segundos`,
  });
});

// Montaje de rutas del API
router.use('/proveedores', proveedorRoutes);
router.use('/categorias', categoriaRoutes);
router.use('/productos', productoRoutes);
router.use('/pedidos', pedidoRoutes);
router.use('/auth', authRoutes);

module.exports = router;
