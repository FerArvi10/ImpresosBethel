const express = require('express');
const cors = require('cors');
const morgan = require('morgan');
const routes = require('./routes');
const errorHandler = require('./middlewares/errorHandler');

const app = express();

// Middlewares globales
app.use(cors({
  origin: '*', // Permitir peticiones desde emuladores Android, web y dispositivos móviles
  methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'Accept'],
}));

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

if (process.env.NODE_ENV !== 'test') {
  app.use(morgan('dev'));
}

// Ruta de bienvenida / Documentación rápida en la raíz
app.get('/', (req, res) => {
  res.json({
    nombre: 'API REST - Impresos Bethel',
    estado: 'Servidor en línea y listo para recibir peticiones',
    documentacion_rapida: {
      salud: 'GET /api/health',
      proveedores: {
        listar: 'GET /api/proveedores',
        detalle: 'GET /api/proveedores/:id',
        crear: 'POST /api/proveedores',
      },
      categorias: {
        listar: 'GET /api/categorias',
        detalle: 'GET /api/categorias/:id',
      },
      productos: {
        listar: 'GET /api/productos',
        detalle: 'GET /api/productos/:id',
        crear: 'POST /api/productos',
      },
      pedidos: {
        listar: 'GET /api/pedidos',
        detalle: 'GET /api/pedidos/:codigo',
        crear: 'POST /api/pedidos',
        actualizarEstado: 'PATCH /api/pedidos/:codigo/estado',
      },
      autenticacion: {
        registro: 'POST /api/auth/register',
        login: 'POST /api/auth/login',
        perfil: 'GET /api/auth/profile',
      },
    },
  });
});

// Montar el prefijo /api requerido por ApiConfig en Flutter
app.use('/api', routes);

// Manejo de ruta no encontrada (404)
app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: `Ruta ${req.method} ${req.originalUrl} no encontrada en este servidor`,
  });
});

// Manejador central de errores
app.use(errorHandler);

module.exports = app;
