import 'package:flutter/foundation.dart' show kIsWeb;

/// Configuración centralizada de la API y dominio para OrderTracker.
class ApiConfig {
  // =========================================================================
  // DOMINIO Y PUERTO DEL SERVIDOR (Servidor desplegado en Railway)
  // =========================================================================

  static String get _dominio =>
      'https://fixit-backend-production-57b4.up.railway.app';

  // Prefijo de la API
  static const String _apiPrefix = '/api';

  /// URL Base completa: 'https://fixit-backend-production-57b4.up.railway.app/api'
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
