const { Categoria, Proveedor, Producto } = require('../models');

/**
 * Listar todas las categorías
 * GET /api/categorias
 */
const listarCategorias = async (req, res, next) => {
  try {
    const categorias = await Categoria.findAll({
      order: [['id', 'ASC']],
    });

    return res.status(200).json({
      success: true,
      total: categorias.length,
      data: categorias,
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Obtener categoría por ID con sus proveedores y productos
 * GET /api/categorias/:id
 */
const obtenerCategoriaPorId = async (req, res, next) => {
  try {
    const { id } = req.params;
    const categoria = await Categoria.findByPk(id, {
      include: [
        { model: Proveedor, as: 'proveedores' },
        { model: Producto, as: 'productos' },
      ],
    });

    if (!categoria) {
      return res.status(404).json({
        success: false,
        message: 'Categoría no encontrada',
      });
    }

    return res.status(200).json({
      success: true,
      data: categoria,
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Crear nueva categoría
 * POST /api/categorias
 */
const crearCategoria = async (req, res, next) => {
  try {
    const { nombre, descripcion } = req.body;
    const nuevaCategoria = await Categoria.create({ nombre, descripcion });

    return res.status(201).json({
      success: true,
      data: nuevaCategoria,
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  listarCategorias,
  obtenerCategoriaPorId,
  crearCategoria,
};
