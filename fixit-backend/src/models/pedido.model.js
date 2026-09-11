const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/database');

const Pedido = sequelize.define('Pedido', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  },
  codigo: {
    type: DataTypes.STRING(30),
    allowNull: false,
    unique: true,
  },
  cliente: {
    type: DataTypes.STRING(150),
    allowNull: false,
  },
  clienteEmail: {
    type: DataTypes.STRING(120),
    allowNull: true,
  },
  telefono: {
    type: DataTypes.STRING(30),
    allowNull: true,
  },
  fecha: {
    type: DataTypes.STRING(50),
    allowNull: false,
  },
  tipoTrabajo: {
    type: DataTypes.STRING(100),
    allowNull: false,
  },
  descripcion: {
    type: DataTypes.TEXT,
    allowNull: false,
  },
  total: {
    type: DataTypes.DECIMAL(10, 2),
    allowNull: false,
  },
  estado: {
    type: DataTypes.ENUM('pendiente', 'enProceso', 'listo', 'entregado', 'cancelado'),
    defaultValue: 'pendiente',
  },
  cantidad: {
    type: DataTypes.INTEGER,
    defaultValue: 1,
  },
  iconoNombre: {
    type: DataTypes.STRING(50),
    defaultValue: 'receipt_long',
  },
  items: {
    type: DataTypes.JSON,
    allowNull: true,
  },
}, {
  tableName: 'pedidos',
  timestamps: true,
});

module.exports = Pedido;
