const { Proveedor, Categoria } = require('../models');
const { Op } = require('sequelize');

/**
 * Obtener listado de todos los proveedores con su categoría
 * GET /api/proveedores
 */
const listarProveedores = async (req, res, next) => {
  try {
    const { verificado, destacado, search, categoriaId } = req.query;
    const where = {};

    if (verificado !== undefined) {
      where.verificado = verificado === 'true' || verificado === '1';
    }

    if (destacado !== undefined) {
      where.destacado = destacado === 'true' || destacado === '1';
    }

    if (categoriaId) {
      where.categoriaId = categoriaId;
    }

    if (search) {
      where[Op.or] = [
        { nombreNegocio: { [Op.like]: `%${search}%` } },
        { descripcion: { [Op.like]: `%${search}%` } },
        { ciudad: { [Op.like]: `%${search}%` } },
        { departamento: { [Op.like]: `%${search}%` } },
      ];
    }

    const proveedores = await Proveedor.findAll({
      where,
      include: [
        {
          model: Categoria,
          as: 'Categoria',
          attributes: ['id', 'nombre'],
        },
      ],
      order: [
        ['destacado', 'DESC'],
        ['calificacion', 'DESC'],
        ['id', 'ASC'],
      ],
    });

    // Retornamos formato compatible con Flutter (acepta lista directa o { data: [...] })
    return res.status(200).json({
      success: true,
      total: proveedores.length,
      data: proveedores,
      proveedores, // alias para máxima compatibilidad
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Obtener un proveedor por su ID
 * GET /api/proveedores/:id
 */
const obtenerProveedorPorId = async (req, res, next) => {
  try {
    const { id } = req.params;

    const proveedor = await Proveedor.findByPk(id, {
      include: [
        {
          model: Categoria,
          as: 'Categoria',
          attributes: ['id', 'nombre'],
        },
      ],
    });

    if (!proveedor) {
      return res.status(404).json({
        success: false,
        message: `Proveedor con ID ${id} no encontrado`,
      });
    }

    return res.status(200).json({
      success: true,
      data: proveedor,
      ...proveedor.toJSON(), // compatibilidad directa
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Crear un nuevo proveedor
 * POST /api/proveedores
 */
const crearProveedor = async (req, res, next) => {
  try {
    const nuevoProveedor = await Proveedor.create(req.body);
    const proveedorCompleto = await Proveedor.findByPk(nuevoProveedor.id, {
      include: [{ model: Categoria, as: 'Categoria' }],
    });

    return res.status(201).json({
      success: true,
      message: 'Proveedor creado exitosamente',
      data: proveedorCompleto,
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Actualizar proveedor existente
 * PUT /api/proveedores/:id
 */
const actualizarProveedor = async (req, res, next) => {
  try {
    const { id } = req.params;
    const proveedor = await Proveedor.findByPk(id);

    if (!proveedor) {
      return res.status(404).json({
        success: false,
        message: 'Proveedor no encontrado',
      });
    }

    await proveedor.update(req.body);
    const proveedorActualizado = await Proveedor.findByPk(id, {
      include: [{ model: Categoria, as: 'Categoria' }],
    });

    return res.status(200).json({
      success: true,
      message: 'Proveedor actualizado exitosamente',
      data: proveedorActualizado,
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Eliminar proveedor
 * DELETE /api/proveedores/:id
 */
const eliminarProveedor = async (req, res, next) => {
  try {
    const { id } = req.params;
    const proveedor = await Proveedor.findByPk(id);

    if (!proveedor) {
      return res.status(404).json({
        success: false,
        message: 'Proveedor no encontrado',
      });
    }

    await proveedor.destroy();

    return res.status(200).json({
      success: true,
      message: 'Proveedor eliminado exitosamente',
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  listarProveedores,
  obtenerProveedorPorId,
  crearProveedor,
  actualizarProveedor,
  eliminarProveedor,
};
