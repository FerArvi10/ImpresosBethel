const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/database');

const Producto = sequelize.define('Producto', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  },
  nombre: {
    type: DataTypes.STRING(150),
    allowNull: false,
  },
  categoria: {
    type: DataTypes.STRING(100),
    allowNull: false,
  },
  categoriaId: {
    type: DataTypes.INTEGER,
    allowNull: true,
  },
  precio: {
    type: DataTypes.DECIMAL(10, 2),
    allowNull: false,
  },
  esPersonalizable: {
    type: DataTypes.BOOLEAN,
    defaultValue: false,
  },
  descripcion: {
    type: DataTypes.TEXT,
    allowNull: true,
  },
  iconoNombre: {
    type: DataTypes.STRING(50),
    allowNull: true,
    defaultValue: 'receipt_long',
  },
  tiempoEntrega: {
    type: DataTypes.STRING(100),
    defaultValue: '2 a 3 días hábiles',
  },
  stockDisponible: {
    type: DataTypes.INTEGER,
    defaultValue: 25,
  },
  imagenUrl: {
    type: DataTypes.STRING(255),
    allowNull: true,
  },
}, {
  tableName: 'productos',
  timestamps: true,
});

module.exports = Producto;
