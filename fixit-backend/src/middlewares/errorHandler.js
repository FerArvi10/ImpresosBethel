const errorHandler = (err, req, res, next) => {
  console.error('💥 [Error Handler]:', err);

  // Errores de validación de Sequelize
  if (err.name === 'SequelizeValidationError' || err.name === 'SequelizeUniqueConstraintError') {
    const mensajes = err.errors ? err.errors.map(e => e.message) : [err.message];
    return res.status(400).json({
      success: false,
      message: 'Error de validación en los datos',
      errores: mensajes,
    });
  }

  const statusCode = err.statusCode || 500;
  return res.status(statusCode).json({
    success: false,
    message: err.message || 'Error interno del servidor',
    ...(process.env.NODE_ENV === 'development' ? { stack: err.stack } : {}),
  });
};

module.exports = errorHandler;
