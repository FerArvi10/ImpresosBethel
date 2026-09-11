require('dotenv').config();
const app = require('./app');
const { sequelize, conectarBD } = require('./config/database');
require('./models'); // Carga asociaciones

const PORT = process.env.PORT || 3000;

async function iniciarServidor() {
  try {
    console.log('🔄 Iniciando servidor de Impresos Bethel...');
    await conectarBD();

    // Sincronizar esquemas de base de datos
    await sequelize.sync();
    console.log('✅ Modelos sincronizados correctamente con la base de datos.');

    app.listen(PORT, '0.0.0.0', () => {
      console.log('====================================================');
      console.log(`🚀 SERVIDOR LISTO EN EL PUERTO: ${PORT}`);
      console.log(`🌐 Local:            http://localhost:${PORT}`);
      console.log(`📱 Emulador Android: http://10.0.2.2:${PORT}`);
      console.log(`🔗 API Base URL:     http://localhost:${PORT}/api`);
      console.log(`📦 Proveedores URL:  http://localhost:${PORT}/api/proveedores`);
      console.log('====================================================');
    });
  } catch (error) {
    console.error('❌ Error fatal al iniciar el servidor:', error);
    process.exit(1);
  }
}

iniciarServidor();
