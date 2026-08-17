import 'package:flutter/material.dart';

/// Pantalla de autenticación y registro de Impresos Bethel.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _esRegistro = false;
  bool _ocultarPassword = true;

  @override
  void dispose() {
    _nombreController.dispose();
    _correoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _enviar() {
    if (!_formKey.currentState!.validate()) return;

    final nombre = _esRegistro
        ? _nombreController.text.trim()
        : 'Yerson Alvarenga';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _esRegistro
              ? 'Cuenta creada, ¡bienvenido/a $nombre!'
              : '¡Bienvenido de nuevo, $nombre!',
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );

    // Navegación con ruta nombrada y limpieza total de la pila (Decisión técnica obligatoria)
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/home',
      (route) => false,
      arguments: nombre,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.teal.shade50,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.teal.shade200, width: 2),
                      ),
                      child: const Icon(
                        Icons.print,
                        size: 48,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
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
                      'Crecemos gracias a su preferencia',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 32),

                  Text(
                    _esRegistro ? 'Crear Cuenta' : 'Iniciar Sesión',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (_esRegistro) ...[
                    TextFormField(
                      controller: _nombreController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre completo',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) => (value == null || value.trim().isEmpty)
                          ? 'Ingresa tu nombre'
                          : null,
                    ),
                    const SizedBox(height: 16),
                  ],

                  TextFormField(
                    controller: _correoController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Correo electrónico',
                      hintText: 'ejemplo@bethel.hn',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Ingresa tu correo';
                      }
                      if (!value.contains('@')) return 'Correo inválido';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: _ocultarPassword,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: const OutlineInputBorder(),
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
                    validator: (value) => (value == null || value.length < 4)
                        ? 'Mínimo 4 caracteres'
                        : null,
                  ),
                  const SizedBox(height: 24),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _enviar,
                    child: Text(
                      _esRegistro ? 'Registrarse' : 'Ingresar',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextButton(
                    onPressed: () => setState(() => _esRegistro = !_esRegistro),
                    child: Text(
                      _esRegistro
                          ? '¿Ya tienes cuenta? Inicia sesión'
                          : '¿No tienes cuenta? Regístrate aquí',
                      style: TextStyle(color: theme.colorScheme.primary),
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
