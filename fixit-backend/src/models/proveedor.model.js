const { DataTypes } = require('sequelize');
const { sequelize } = require('../config/database');

const Proveedor = sequelize.define('Proveedor', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  },
  nombreNegocio: {
    type: DataTypes.STRING(150),
    allowNull: false,
  },
  descripcion: {
    type: DataTypes.TEXT,
    allowNull: true,
  },
  telefono: {
    type: DataTypes.STRING(30),
    allowNull: true,
  },
  ciudad: {
    type: DataTypes.STRING(100),
    allowNull: true,
  },
  departamento: {
    type: DataTypes.STRING(100),
    allowNull: true,
  },
  precioDesde: {
    type: DataTypes.DECIMAL(10, 2),
    allowNull: true,
  },
  calificacion: {
    type: DataTypes.DECIMAL(3, 1),
    defaultValue: 5.0,
  },
  totalResenas: {
    type: DataTypes.INTEGER,
    defaultValue: 0,
  },
  verificado: {
    type: DataTypes.BOOLEAN,
    defaultValue: false,
  },
  destacado: {
    type: DataTypes.BOOLEAN,
    defaultValue: false,
  },
  disponible: {
    type: DataTypes.BOOLEAN,
    defaultValue: true,
  },
  fotoUrl: {
    type: DataTypes.STRING(255),
    allowNull: true,
  },
  categoriaId: {
    type: DataTypes.INTEGER,
    allowNull: false,
  },
}, {
  tableName: 'proveedores',
  timestamps: true,
});

module.exports = Proveedor;
