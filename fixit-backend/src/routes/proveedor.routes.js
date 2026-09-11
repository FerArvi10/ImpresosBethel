const express = require('express');
const router = express.Router();
const proveedorController = require('../controllers/proveedor.controller');

// Rutas públicas de proveedores (usadas directamente por Flutter)
router.get('/', proveedorController.listarProveedores);
router.get('/:id', proveedorController.obtenerProveedorPorId);

// Operaciones de gestión
router.post('/', proveedorController.crearProveedor);
router.put('/:id', proveedorController.actualizarProveedor);
router.delete('/:id', proveedorController.eliminarProveedor);

module.exports = router;
