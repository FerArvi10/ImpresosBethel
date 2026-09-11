const { Pedido } = require('../models');
const { Op } = require('sequelize');

/**
 * Listar pedidos / historial
 * GET /api/pedidos
 */
const listarPedidos = async (req, res, next) => {
  try {
    const { estado, search, cliente } = req.query;
    const where = {};

    if (estado && estado !== 'Todos') {
      where.estado = estado;
    }

    if (cliente) {
      where.cliente = { [Op.like]: `%${cliente}%` };
    }

    if (search) {
      where[Op.or] = [
        { codigo: { [Op.like]: `%${search}%` } },
        { cliente: { [Op.like]: `%${search}%` } },
        { tipoTrabajo: { [Op.like]: `%${search}%` } },
        { descripcion: { [Op.like]: `%${search}%` } },
      ];
    }

    const pedidos = await Pedido.findAll({
      where,
      order: [['id', 'DESC']],
    });

    return res.status(200).json({
      success: true,
      total: pedidos.length,
      data: pedidos,
      pedidos, // alias de compatibilidad
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Obtener un pedido por código o ID
 * GET /api/pedidos/:codigo
 */
const obtenerPedidoPorCodigo = async (req, res, next) => {
  try {
    const { codigo } = req.params;

    // Buscar primero por código (ej. BET-1048), luego por ID numérico si aplica
    let pedido = await Pedido.findOne({ where: { codigo } });

    if (!pedido && !isNaN(Number(codigo))) {
      pedido = await Pedido.findByPk(codigo);
    }

    if (!pedido) {
      return res.status(404).json({
        success: false,
        message: `Pedido ${codigo} no encontrado`,
      });
    }

    return res.status(200).json({
      success: true,
      data: pedido,
      ...pedido.toJSON(),
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Crear un nuevo pedido (Checkout de Carrito)
 * POST /api/pedidos
 */
const crearPedido = async (req, res, next) => {
  try {
    let {
      codigo,
      cliente,
      clienteEmail,
      telefono,
      fecha,
      tipoTrabajo,
      descripcion,
      total,
      estado,
      cantidad,
      items,
    } = req.body;

    // Generar código autoincrementable realista si no se proporcionó
    if (!codigo) {
      const ultimo = await Pedido.findOne({ order: [['id', 'DESC']] });
      const correlativo = ultimo ? ultimo.id + 1040 : 1050;
      codigo = `BET-${correlativo}`;
    }

    if (!fecha) {
      const opciones = { day: '2-digit', month: 'short', year: 'numeric' };
      fecha = new Date().toLocaleDateString('es-HN', opciones);
    }

    const nuevoPedido = await Pedido.create({
      codigo,
      cliente: cliente || 'Cliente General',
      clienteEmail,
      telefono,
      fecha,
      tipoTrabajo: tipoTrabajo || 'Impresión General',
      descripcion: descripcion || 'Pedido registrado desde la aplicación móvil',
      total: total || 0.0,
      estado: estado || 'pendiente',
      cantidad: cantidad || 1,
      items,
    });

    return res.status(201).json({
      success: true,
      message: 'Pedido registrado con éxito',
      data: nuevoPedido,
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Actualizar estado de un pedido
 * PATCH /api/pedidos/:codigo/estado
 */
const actualizarEstadoPedido = async (req, res, next) => {
  try {
    const { codigo } = req.params;
    const { estado } = req.body;

    let pedido = await Pedido.findOne({ where: { codigo } });
    if (!pedido && !isNaN(Number(codigo))) {
      pedido = await Pedido.findByPk(codigo);
    }

    if (!pedido) {
      return res.status(404).json({
        success: false,
        message: 'Pedido no encontrado',
      });
    }

    await pedido.update({ estado });

    return res.status(200).json({
      success: true,
      message: `Estado de pedido ${pedido.codigo} actualizado a ${estado}`,
      data: pedido,
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  listarPedidos,
  obtenerPedidoPorCodigo,
  crearPedido,
  actualizarEstadoPedido,
};
