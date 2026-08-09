import 'package:flutter/material.dart';

import 'home_screen.dart';

enum UserRole { cajera, cocinera }

class Usuario {
  final String username;
  final String password;
  final UserRole role;
  final String nombreCompleto;

  const Usuario({
    required this.username,
    required this.password,
    required this.role,
    required this.nombreCompleto,
  });
}

// Usuarios "hardcoded" solo para la primera versión.
// Cuando decidan backend (Firebase u otro), esta lista se reemplaza
// por una llamada real de autenticación.
const List<Usuario> _usuariosDemo = [
  Usuario(
    username: 'cajera1',
    password: '1234',
    role: UserRole.cajera,
    nombreCompleto: 'María Pérez',
  ),
  Usuario(
    username: 'cocinera1',
    password: '1234',
    role: UserRole.cocinera,
    nombreCompleto: 'Ana López',
  ),
];

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _cargando = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Usuario? _validarLogin(String username, String password) {
    for (final usuario in _usuariosDemo) {
      if (usuario.username == username && usuario.password == password) {
        return usuario;
      }
    }
    return null;
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _cargando = true);

    // Simula una pequeña espera, útil si luego conectan un backend real.
    await Future.delayed(const Duration(milliseconds: 400));

    final usuario = _validarLogin(
      _usernameController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;
    setState(() => _cargando = false);

    if (usuario == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuario o contraseña incorrectos'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // HomeScreen es compartida; cambia lo que muestra según el rol.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => HomeScreen(
          role: usuario.role,
          nombreUsuario: usuario.nombreCompleto,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.local_gas_station, size: 72),
                  const SizedBox(height: 12),
                  Text(
                    'Order Tracker',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Texaco Satuye',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Usuario',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Ingresa tu usuario';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingresa tu contraseña';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _cargando ? null : _handleLogin,
                    child: _cargando
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Ingresar'),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Demo: cajera1 / cocinera1  —  contraseña: 1234',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
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

