const jwt = require('jsonwebtoken');

const verificarAuth = (req, res, next) => {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({
      success: false,
      message: 'Token de autorización no proporcionado o formato inválido',
    });
  }

  const token = authHeader.split(' ')[1];

  try {
    const decodificado = jwt.verify(
      token,
      process.env.JWT_SECRET || 'bethel_secret_key_default'
    );
    req.usuario = decodificado;
    next();
  } catch (error) {
    return res.status(403).json({
      success: false,
      message: 'Token inválido o expirado',
    });
  }
};

module.exports = {
  verificarAuth,
};
