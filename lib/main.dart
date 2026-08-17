import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/catalogo_screen.dart';
import 'screens/detalle_screen.dart';
import 'screens/carrito_screen.dart';
import 'screens/historial_screen.dart';
import 'screens/perfil_screen.dart';
import 'screens/acerca_de_screen.dart';

void main() {
  runApp(const OrderTrackerApp());
}

/// Aplicación principal OrderTracker para Impresos Bethel.
/// Configuración centralizada de rutas con nombre (Semana 4).
class OrderTrackerApp extends StatelessWidget {
  const OrderTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OrderTracker - Impresos Bethel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          primary: Colors.teal,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.teal,
          elevation: 0.5,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.teal,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      // 5.1 Navegación con rutas con nombre centralizadas
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/catalogo': (context) => const CatalogoScreen(),
        '/detalle': (context) => const DetalleScreen(),
        '/carrito': (context) => const CarritoScreen(),
        '/historial': (context) => const HistorialScreen(),
        '/perfil': (context) => const PerfilScreen(),
        '/acerca-de': (context) => const AcercaDeScreen(),
      },
    );
  }
}
