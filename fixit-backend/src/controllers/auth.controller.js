const jwt = require('jsonwebtoken');
const { User } = require('../models');

// Registro en memoria de intentos fallidos por correo
// Estructura: email -> { count: number, bloqueadoHasta: timestamp }
const intentosFallidos = new Map();
const MAX_INTENTOS = 5;
const TIEMPO_BLOQUEO_MS = 15 * 60 * 1000; // 15 minutos

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
 * Iniciar sesión con límite de 5 intentos fallidos
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

    // 1. Verificar si el usuario está actualmente bloqueado por exceso de intentos
    const estado = intentosFallidos.get(emailLimpio);
    const ahora = Date.now();

    if (estado && estado.bloqueadoHasta && ahora < estado.bloqueadoHasta) {
      const minutosRestantes = Math.ceil((estado.bloqueadoHasta - ahora) / 60000);
      return res.status(429).json({
        success: false,
        bloqueado: true,
        intentosRestantes: 0,
        message: `Has superado el límite de ${MAX_INTENTOS} intentos fallidos. Tu cuenta está bloqueada temporalmente por seguridad. Intenta nuevamente en ${minutosRestantes} minuto(s).`,
      });
    }

    // 2. Buscar usuario en base de datos y validar contraseña
    const usuario = await User.findOne({ where: { email: emailLimpio } });
    const esValido = usuario ? await usuario.validarPassword(password) : false;

    if (!esValido) {
      // Registrar intento fallido
      const nuevoConteo = (estado ? estado.count : 0) + 1;

      if (nuevoConteo >= MAX_INTENTOS) {
        // Bloquear cuenta por 15 minutos
        intentosFallidos.set(emailLimpio, {
          count: nuevoConteo,
          bloqueadoHasta: ahora + TIEMPO_BLOQUEO_MS,
        });

        return res.status(429).json({
          success: false,
          bloqueado: true,
          intentosRestantes: 0,
          message: `Has alcanzado el límite máximo de ${MAX_INTENTOS} intentos fallidos. Por seguridad, el acceso ha sido bloqueado por 15 minutos.`,
        });
      } else {
        const intentosRestantes = MAX_INTENTOS - nuevoConteo;
        intentosFallidos.set(emailLimpio, {
          count: nuevoConteo,
          bloqueadoHasta: null,
        });

        return res.status(401).json({
          success: false,
          bloqueado: false,
          intentosRestantes,
          message: `Credenciales incorrectas. Te quedan ${intentosRestantes} de ${MAX_INTENTOS} intentos antes del bloqueo.`,
        });
      }
    }

    // 3. Si las credenciales son válidas, limpiar historial de intentos fallidos
    intentosFallidos.delete(emailLimpio);

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
