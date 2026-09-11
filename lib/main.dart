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
import 'screens/proveedores_screen.dart';
import 'screens/proveedor_detalle_screen.dart';

/// Notificador global reactivo para alternar entre Modo Claro y Modo Oscuro.
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);

/// Función global para alternar entre modo claro y modo oscuro
void alternarModoOscuro() {
  themeNotifier.value = themeNotifier.value == ThemeMode.dark
      ? ThemeMode.light
      : ThemeMode.dark;
}

void main() {
  runApp(const OrderTrackerApp());
}

/// Aplicación principal OrderTracker para Impresos Bethel.
/// Configuración centralizada de rutas con nombre y soporte de Modo Oscuro.
class OrderTrackerApp extends StatelessWidget {
  const OrderTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
          title: 'OrderTracker - Impresos Bethel',
          debugShowCheckedModeBanner: false,
          themeMode: currentMode,
          // TEMA CLARO
          theme: ThemeData(
            brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.teal,
              primary: Colors.teal,
              brightness: Brightness.light,
            ),
            scaffoldBackgroundColor: const Color(0xFFF6F8F8),
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
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Colors.white,
              selectedItemColor: Colors.teal,
              unselectedItemColor: Colors.grey,
              type: BottomNavigationBarType.fixed,
              elevation: 8,
            ),
            drawerTheme: const DrawerThemeData(
              backgroundColor: Colors.white,
            ),
          ),
          // TEMA OSCURO
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.teal,
              primary: Colors.tealAccent,
              surface: const Color(0xFF1E1E1E),
              brightness: Brightness.dark,
            ),
            scaffoldBackgroundColor: const Color(0xFF121212),
            canvasColor: const Color(0xFF1E1E1E),
            cardColor: const Color(0xFF1E1E1E),
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1E1E1E),
              foregroundColor: Colors.tealAccent,
              elevation: 0.5,
              centerTitle: true,
              titleTextStyle: TextStyle(
                color: Colors.tealAccent,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            cardTheme: CardThemeData(
              color: const Color(0xFF1E1E1E),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Color(0xFF1E1E1E),
              selectedItemColor: Colors.tealAccent,
              unselectedItemColor: Colors.grey,
              type: BottomNavigationBarType.fixed,
              elevation: 8,
            ),
            drawerTheme: const DrawerThemeData(
              backgroundColor: Color(0xFF1E1E1E),
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: Color(0xFF1E1E1E),
            ),
            bottomSheetTheme: const BottomSheetThemeData(
              backgroundColor: Color(0xFF1E1E1E),
            ),
            dividerColor: Colors.white12,
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
            '/proveedores': (context) => const ProveedoresScreen(),
            '/proveedor-detalle': (context) => const ProveedorDetalleScreen(),
          },
        );
      },
    );
  }
}
