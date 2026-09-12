import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/notification_banner.dart';

/// Pantalla de autenticación y registro de Impresos Bethel.
/// Cumple con todos los requisitos de la Actividad 8.1 de Programación Móvil.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para los campos del formulario
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _correoController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Estados de interfaz
  bool _esRegistro = false;
  bool _ocultarPassword = true;
  bool _ocultarConfirmPassword = true;
  bool _cargando = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _correoController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Limpia los campos al alternar entre Iniciar Sesión y Crear Cuenta
  void _alternarModo(bool registro) {
    setState(() {
      _esRegistro = registro;
      _formKey.currentState?.reset();
    });
  }

  /// Procesa el formulario (Registro o Inicio de Sesión)
  Future<void> _enviar() async {
    // 3. Validación de campos en el cliente
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor corrige los errores antes de continuar.'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Ocultar teclado
    FocusScope.of(context).unfocus();

    setState(() => _cargando = true);

    if (_esRegistro) {
      // 4. Envío de información al backend mediante API REST
      final resultado = await AuthService.register(
        nombre: _nombreController.text.trim(),
        apellido: _apellidoController.text.trim(),
        email: _correoController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;
      setState(() => _cargando = false);

      if (resultado.success) {
        // 6 & 7. Respuesta exitosa y generación/recepción de Notificación
        final nombreCompleto =
            '${_nombreController.text.trim()} ${_apellidoController.text.trim()}';

        // 7. Despliegue de la notificación al usuario
        NotificationBanner.mostrar(
          context,
          titulo: 'Registro completado',
          mensaje: 'Tu cuenta ha sido creada correctamente.',
          duracion: const Duration(seconds: 5),
        );

        // Mensaje en pantalla de confirmación
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '¡Bienvenido/a $nombreCompleto! Registro completado.',
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.teal.shade700,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );

        // Navegación a la pantalla principal limpiando la pila de navegación
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
          (route) => false,
          arguments: nombreCompleto,
        );
      } else {
        // 9. Manejo de errores: Correo duplicado u otros errores del backend
        _mostrarErrorDialog(resultado.message);
      }
    } else {
      // Inicio de sesión normal
      final resultado = await AuthService.login(
        email: _correoController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;
      setState(() => _cargando = false);

      if (resultado.success) {
        final nombreUsuario =
            resultado.usuario?['nombre'] ?? 'Yerson Alvarenga';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('¡Bienvenido de nuevo, $nombreUsuario!'),
            backgroundColor: Colors.teal,
            behavior: SnackBarBehavior.floating,
          ),
        );

        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
          (route) => false,
          arguments: nombreUsuario,
        );
      } else {
        _mostrarErrorDialog(resultado.message);
      }
    }
  }

  /// Muestra diálogo modal con mensaje de error del backend (ej. correo duplicado)
  void _mostrarErrorDialog(String mensaje) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.error_outline, color: Colors.red, size: 28),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'No se pudo registrar',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Text(
          mensaje,
          style: const TextStyle(fontSize: 15, color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'Aceptar',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.teal,
              ),
            ),
          ),
        ],
      ),
    );

    // También mostrar SnackBar en rojo para máxima visibilidad en el video
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(mensaje)),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logotipo y Encabezado
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade50,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.teal.shade200, width: 2),
                      ),
                      child: const Icon(
                        Icons.print,
                        size: 42,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Center(
                    child: Text(
                      'Impresos Bethel',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'OrderTracker • Crecemos gracias a su preferencia',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Selector Segmentado: Iniciar Sesión vs Crear Cuenta (Requisito 1)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _alternarModo(false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: !_esRegistro ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(9),
                                boxShadow: !_esRegistro
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withAlpha((0.08 * 255).round()),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  'Iniciar Sesión',
                                  style: TextStyle(
                                    fontWeight: !_esRegistro ? FontWeight.bold : FontWeight.normal,
                                    color: !_esRegistro ? Colors.teal.shade800 : Colors.grey.shade700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _alternarModo(true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _esRegistro ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(9),
                                boxShadow: _esRegistro
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withAlpha((0.08 * 255).round()),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  'Crear Cuenta',
                                  style: TextStyle(
                                    fontWeight: _esRegistro ? FontWeight.bold : FontWeight.normal,
                                    color: _esRegistro ? Colors.teal.shade800 : Colors.grey.shade700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Título dinámico
                  Text(
                    _esRegistro ? 'Formulario de Registro' : 'Bienvenido de nuevo',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _esRegistro
                        ? 'Completa tus datos para crear una nueva cuenta.'
                        : 'Ingresa tus credenciales para acceder a tus pedidos.',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                  const SizedBox(height: 18),

                  // CAMPOS DE REGISTRO
                  if (_esRegistro) ...[
                    // Campo 1: Nombre (Obligatorio)
                    TextFormField(
                      controller: _nombreController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Nombre *',
                        hintText: 'Ej. Fernando',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'El nombre es obligatorio';
                        }
                        if (value.trim().length < 2) {
                          return 'Ingresa un nombre válido (mínimo 2 letras)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    // Campo 2: Apellido (Obligatorio)
                    TextFormField(
                      controller: _apellidoController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Apellido *',
                        hintText: 'Ej. Arvizu',
                        prefixIcon: Icon(Icons.badge_outlined),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'El apellido es obligatorio';
                        }
                        if (value.trim().length < 2) {
                          return 'Ingresa un apellido válido (mínimo 2 letras)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                  ],

                  // Campo 3: Correo Electrónico (Obligatorio y Formato válido)
                  TextFormField(
                    controller: _correoController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Correo electrónico *',
                      hintText: 'ejemplo@bethel.hn',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El correo electrónico es obligatorio';
                      }
                      final emailRegex =
                          RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(value.trim())) {
                        return 'Ingresa un correo electrónico con formato válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // Campo 4: Contraseña (Mínimo 6 caracteres)
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _ocultarPassword,
                    decoration: InputDecoration(
                      labelText: 'Contraseña *',
                      hintText: 'Mínimo 6 caracteres',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _ocultarPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () => setState(
                          () => _ocultarPassword = !_ocultarPassword,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'La contraseña es obligatoria';
                      }
                      if (value.length < 6) {
                        return 'La contraseña debe tener mínimo 6 caracteres';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  // Campo 5: Confirmación de Contraseña (Solo en Registro)
                  if (_esRegistro) ...[
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _ocultarConfirmPassword,
                      decoration: InputDecoration(
                        labelText: 'Confirmación de contraseña *',
                        hintText: 'Vuelve a escribir la contraseña',
                        prefixIcon: const Icon(Icons.lock_reset_outlined),
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _ocultarConfirmPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () => setState(
                            () => _ocultarConfirmPassword =
                                !_ocultarConfirmPassword,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Debes confirmar la contraseña';
                        }
                        if (value != _passwordController.text) {
                          return 'Las contraseñas no coinciden';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),
                  ] else
                    const SizedBox(height: 10),

                  // Botón Principal de Envío (Registrarse / Ingresar)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _cargando ? null : _enviar,
                    child: _cargando
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            _esRegistro ? 'Registrarse en Bethel' : 'Ingresar',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),

                  const SizedBox(height: 16),

                  // Botón alternativo de cambio de modo
                  TextButton(
                    onPressed: _cargando
                        ? null
                        : () => _alternarModo(!_esRegistro),
                    child: Text(
                      _esRegistro
                          ? '¿Ya tienes una cuenta? Inicia sesión aquí'
                          : '¿No tienes cuenta? Crear una cuenta',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
