const { Producto, Categoria } = require('../models');
const { Op } = require('sequelize');

/**
 * Listar productos con filtros opcionales
 * GET /api/productos
 */
const listarProductos = async (req, res, next) => {
  try {
    const { categoria, search, esPersonalizable } = req.query;
    const where = {};

    if (categoria && categoria.toLowerCase() !== 'todas') {
      where.categoria = categoria;
    }

    if (esPersonalizable !== undefined) {
      where.esPersonalizable = esPersonalizable === 'true' || esPersonalizable === '1';
    }

    if (search) {
      where[Op.or] = [
        { nombre: { [Op.like]: `%${search}%` } },
        { descripcion: { [Op.like]: `%${search}%` } },
      ];
    }

    const productos = await Producto.findAll({
      where,
      include: [{ model: Categoria, as: 'Categoria', attributes: ['id', 'nombre'] }],
      order: [['id', 'ASC']],
    });

    return res.status(200).json({
      success: true,
      total: productos.length,
      data: productos,
      productos, // alias de compatibilidad
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Obtener producto por ID
 * GET /api/productos/:id
 */
const obtenerProductoPorId = async (req, res, next) => {
  try {
    const { id } = req.params;
    const producto = await Producto.findByPk(id, {
      include: [{ model: Categoria, as: 'Categoria' }],
    });

    if (!producto) {
      return res.status(404).json({
        success: false,
        message: 'Producto no encontrado',
      });
    }

    return res.status(200).json({
      success: true,
      data: producto,
      ...producto.toJSON(),
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Crear producto
 * POST /api/productos
 */
const crearProducto = async (req, res, next) => {
  try {
    const nuevoProducto = await Producto.create(req.body);
    return res.status(201).json({
      success: true,
      message: 'Producto creado exitosamente',
      data: nuevoProducto,
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Actualizar producto
 * PUT /api/productos/:id
 */
const actualizarProducto = async (req, res, next) => {
  try {
    const { id } = req.params;
    const producto = await Producto.findByPk(id);

    if (!producto) {
      return res.status(404).json({
        success: false,
        message: 'Producto no encontrado',
      });
    }

    await producto.update(req.body);
    return res.status(200).json({
      success: true,
      message: 'Producto actualizado exitosamente',
      data: producto,
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Eliminar producto
 * DELETE /api/productos/:id
 */
const eliminarProducto = async (req, res, next) => {
  try {
    const { id } = req.params;
    const producto = await Producto.findByPk(id);

    if (!producto) {
      return res.status(404).json({
        success: false,
        message: 'Producto no encontrado',
      });
    }

    await producto.destroy();
    return res.status(200).json({
      success: true,
      message: 'Producto eliminado exitosamente',
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  listarProductos,
  obtenerProductoPorId,
  crearProducto,
  actualizarProducto,
  eliminarProducto,
};
