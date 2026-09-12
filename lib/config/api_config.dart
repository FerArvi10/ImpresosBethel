import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

/// Configuración centralizada de la API y dominio para OrderTracker.
class ApiConfig {
  // =========================================================================
  // DOMINIO Y PUERTO DEL SERVIDOR (Auto-detectable)
  // =========================================================================
  // - Si estás en Windows / Chrome / Web: usa http://localhost:3000
  // - Si estás en Emulador Android: usa http://10.0.2.2:3000
  // - Si usas celular físico: descomenta la línea con tu IP local (ipconfig).
  // =========================================================================

  static String get _dominio {
    // Si pruebas con celular físico en la misma red Wi-Fi, descomenta esto:
    // return 'http://192.168.1.50:3000';

    if (kIsWeb) return 'http://localhost:3000';
    try {
      if (Platform.isAndroid) return 'http://10.0.2.2:3000';
    } catch (_) {}
    return 'http://localhost:3000';
  }

  // Prefijo de la API
  static const String _apiPrefix = '/api';

  /// URL Base completa: ej. 'http://localhost:3000/api' o 'http://10.0.2.2:3000/api'
  static String get baseUrl => '$_dominio$_apiPrefix';

  // =========================================================================
  // ENDPOINTS DE LA APLICACIÓN
  // =========================================================================

  /// Endpoint GET /api/proveedores
  static String get proveedores => '$baseUrl/proveedores';

  /// Endpoint GET /api/proveedores/:id
  static String proveedorDetalle(int id) => '$baseUrl/proveedores/$id';

  /// Endpoint GET /api/productos
  static String get productos => '$baseUrl/productos';

  /// Endpoint GET /api/pedidos
  static String get pedidos => '$baseUrl/pedidos';

  /// Endpoint GET /api/categorias
  static String get categorias => '$baseUrl/categorias';

  // =========================================================================
  // ENDPOINTS DE AUTENTICACIÓN Y REGISTRO (Actividad 8.1)
  // =========================================================================

  /// Endpoint POST /api/auth/register
  static String get authRegister => '$baseUrl/auth/register';

  /// Endpoint POST /api/auth/login
  static String get authLogin => '$baseUrl/auth/login';

  /// Endpoint GET /api/auth/users (Persistencia)
  static String get authUsers => '$baseUrl/auth/users';

  /// Endpoint GET /api/health (Estado del Backend)
  static String get health => '$baseUrl/health';

  /// Timeout estándar para peticiones en red (10 segundos)
  static const Duration timeout = Duration(seconds: 10);

  /// Headers estándar para peticiones JSON
  static Map<String, String> get headersJson => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
}
