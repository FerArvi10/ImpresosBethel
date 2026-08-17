import 'dart:async';
import 'package:flutter/material.dart';

/// Pantalla de bienvenida con branding de Impresos Bethel y redirección a /login.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );

    _animController.forward();

    _timer = Timer(const Duration(milliseconds: 2000), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.teal.shade900,
              Colors.teal.shade700,
              Colors.teal.shade500,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                // Logotipo de Impresos Bethel
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha((0.25 * 255).round()),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.print,
                    size: 72,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Impresos Bethel',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'OrderTracker • Sistema de Pedidos y Catálogo',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withAlpha((0.9 * 255).round()),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Crecemos gracias a su preferencia',
                  style: TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: Colors.amber.shade200,
                  ),
                ),
                const Spacer(),
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2.5,
                ),
                const SizedBox(height: 16),
                Text(
                  'Cargando...',
                  style: TextStyle(
                    color: Colors.white.withAlpha((0.8 * 255).round()),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
