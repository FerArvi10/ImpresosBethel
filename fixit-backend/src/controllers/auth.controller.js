const jwt = require('jsonwebtoken');
const { User } = require('../models');

const generarToken = (usuario) => {
  return jwt.sign(
    {
      id: usuario.id,
      nombre: usuario.nombre,
      apellido: usuario.apellido || '',
      email: usuario.email,
      rol: usuario.rol,
    },
    process.env.JWT_SECRET || 'bethel_secret_key_default',
    { expiresIn: process.env.JWT_EXPIRES_IN || '7d' }
  );
};

/**
 * Registro de nuevo usuario
 * POST /api/auth/register
 */
const registro = async (req, res, next) => {
  try {
    const { nombre, apellido, email, password, rol } = req.body;

    if (!nombre || !email || !password) {
      return res.status(400).json({
        success: false,
        message: 'Por favor proporciona nombre, correo electrónico y contraseña',
      });
    }

    const emailLimpio = String(email).trim().toLowerCase();

    // Verificación de correo duplicado
    const usuarioExiste = await User.findOne({ where: { email: emailLimpio } });
    if (usuarioExiste) {
      return res.status(400).json({
        success: false,
        message: 'El correo electrónico ya se encuentra registrado',
      });
    }

    // Creación del nuevo usuario (la contraseña se hashea con bcrypt en el hook beforeCreate)
    const nuevoUsuario = await User.create({
      nombre: String(nombre).trim(),
      apellido: apellido ? String(apellido).trim() : '',
      email: emailLimpio,
      password: String(password),
      rol: rol || 'cliente',
    });

    const token = generarToken(nuevoUsuario);

    return res.status(201).json({
      success: true,
      message: 'Usuario registrado exitosamente',
      token,
      usuario: {
        id: nuevoUsuario.id,
        nombre: nuevoUsuario.nombre,
        apellido: nuevoUsuario.apellido,
        email: nuevoUsuario.email,
        rol: nuevoUsuario.rol,
      },
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Iniciar sesión
 * POST /api/auth/login
 */
const login = async (req, res, next) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({
        success: false,
        message: 'Debes proporcionar correo electrónico y contraseña',
      });
    }

    const emailLimpio = String(email).trim().toLowerCase();
    const usuario = await User.findOne({ where: { email: emailLimpio } });
    if (!usuario) {
      return res.status(401).json({
        success: false,
        message: 'Credenciales inválidas',
      });
    }

    const esValido = await usuario.validarPassword(password);
    if (!esValido) {
      return res.status(401).json({
        success: false,
        message: 'Credenciales inválidas',
      });
    }

    const token = generarToken(usuario);

    return res.status(200).json({
      success: true,
      message: 'Sesión iniciada con éxito',
      token,
      usuario: {
        id: usuario.id,
        nombre: usuario.nombre,
        apellido: usuario.apellido,
        email: usuario.email,
        rol: usuario.rol,
      },
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Obtener perfil de usuario autenticado
 * GET /api/auth/profile
 */
const perfil = async (req, res, next) => {
  try {
    const usuario = await User.findByPk(req.usuario.id, {
      attributes: ['id', 'nombre', 'apellido', 'email', 'rol', 'createdAt'],
    });

    if (!usuario) {
      return res.status(404).json({
        success: false,
        message: 'Usuario no encontrado',
      });
    }

    return res.status(200).json({
      success: true,
      usuario,
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Listado de usuarios registrados para comprobación de persistencia
 * GET /api/auth/users
 */
const listarUsuarios = async (req, res, next) => {
  try {
    const usuarios = await User.findAll({
      attributes: ['id', 'nombre', 'apellido', 'email', 'rol', 'password', 'createdAt'],
      order: [['id', 'DESC']],
    });

    return res.status(200).json({
      success: true,
      total: usuarios.length,
      mensaje: 'Persistencia en Base de Datos verificada correctamente',
      usuarios,
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  registro,
  login,
  perfil,
  listarUsuarios,
};
