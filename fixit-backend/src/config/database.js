const { Sequelize } = require('sequelize');
const path = require('path');
require('dotenv').config();

const dialect = (process.env.DB_DIALECT || 'sqlite').toLowerCase();

let sequelize;

if (dialect === 'mysql') {
  sequelize = new Sequelize(
    process.env.DB_NAME || 'impresos_bethel',
    process.env.DB_USER || 'root',
    process.env.DB_PASSWORD || '',
    {
      host: process.env.DB_HOST || 'localhost',
      port: process.env.DB_PORT || 3306,
      dialect: 'mysql',
      logging: process.env.NODE_ENV === 'development' ? false : false,
      pool: {
        max: 10,
        min: 0,
        acquire: 30000,
        idle: 10000,
      },
    }
  );
} else {
  // Por defecto SQLite para desarrollo local sin requerir servicios externos
  const storagePath = process.env.DB_STORAGE
    ? path.resolve(process.env.DB_STORAGE)
    : path.resolve(__dirname, 'database.sqlite');

  sequelize = new Sequelize({
    dialect: 'sqlite',
    storage: storagePath,
    logging: false,
  });
}

/**
 * Función para inicializar y verificar conexión a la base de datos
 */
async function conectarBD() {
  try {
    if (dialect === 'mysql') {
      // Intentar crear la base de datos si no existe en MySQL
      try {
        const mysql = require('mysql2/promise');
        const connection = await mysql.createConnection({
          host: process.env.DB_HOST || 'localhost',
          port: process.env.DB_PORT || 3306,
          user: process.env.DB_USER || 'root',
          password: process.env.DB_PASSWORD || '',
        });
        await connection.query(`CREATE DATABASE IF NOT EXISTS \`${process.env.DB_NAME || 'impresos_bethel'}\`;`);
        await connection.end();
      } catch (err) {
        console.warn('⚠️ No se pudo verificar la creación de base de datos MySQL automática:', err.message);
      }
    }

    await sequelize.authenticate();
    console.log(`✅ Conexión establecida exitosamente con la base de datos (${dialect.toUpperCase()}).`);
  } catch (error) {
    console.error('❌ Error de conexión a la base de datos:', error.message);
    if (dialect === 'mysql') {
      console.log('💡 Sugerencia: Asegúrate de que MySQL esté corriendo en XAMPP o cambia DB_DIALECT=sqlite en tu archivo .env');
    }
    throw error;
  }
}

module.exports = {
  sequelize,
  conectarBD,
};
