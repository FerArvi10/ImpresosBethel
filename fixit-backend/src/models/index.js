const { sequelize } = require('../config/database');
const Categoria = require('./categoria.model');
const Proveedor = require('./proveedor.model');
const Producto = require('./producto.model');
const Pedido = require('./pedido.model');
const User = require('./user.model');

// Relaciones entre Modelos
Categoria.hasMany(Proveedor, { foreignKey: 'categoriaId', as: 'proveedores' });
Proveedor.belongsTo(Categoria, { foreignKey: 'categoriaId', as: 'Categoria' });

Categoria.hasMany(Producto, { foreignKey: 'categoriaId', as: 'productos' });
Producto.belongsTo(Categoria, { foreignKey: 'categoriaId', as: 'Categoria' });

User.hasMany(Pedido, { foreignKey: 'usuarioId', as: 'pedidos' });
Pedido.belongsTo(User, { foreignKey: 'usuarioId', as: 'usuario' });

module.exports = {
  sequelize,
  Categoria,
  Proveedor,
  Producto,
  Pedido,
  User,
};
