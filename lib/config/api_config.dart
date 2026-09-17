/// Modos de conexión disponibles para el backend de Impresos Bethel.
enum ModoConexion {
  nube,
  wifiLocal,
  localhost,
  emulador,
  personalizado,
}

/// Configuración centralizada de la API y dominio para OrderTracker.
class ApiConfig {
  // Modo actual de conexión (por defecto Nube para máxima compatibilidad con celulares)
  static ModoConexion modoActual = ModoConexion.nube;

  // IP local de la computadora para celulares en la misma red Wi-Fi
  static String ipLocalWifi = '192.168.1.11';
  static int puertoLocal = 3000;

  // URL personalizada en caso de que cambie la IP
  static String urlPersonalizada = '';

  /// Resuelve dinámicamente el dominio base según el modo seleccionado
  static String get _dominio {
    switch (modoActual) {
      case ModoConexion.nube:
        return 'https://fixit-backend-production-57b4.up.railway.app';
      case ModoConexion.wifiLocal:
        return 'http://$ipLocalWifi:$puertoLocal';
      case ModoConexion.localhost:
        return 'http://localhost:$puertoLocal';
      case ModoConexion.emulador:
        return 'http://10.0.2.2:$puertoLocal';
      case ModoConexion.personalizado:
        return urlPersonalizada.isNotEmpty
            ? urlPersonalizada
            : 'http://$ipLocalWifi:$puertoLocal';
    }
  }

  // Prefijo de la API
  static const String _apiPrefix = '/api';

  /// URL Base completa: ej. 'https://.../api' o 'http://192.168.1.11:3000/api'
  static String get baseUrl => '$_dominio$_apiPrefix';

  // =========================================================================
  // ENDPOINTS DE LA APLICACIÓN
  // =========================================================================

  /// Endpoint GET /api/proveedores
  static String get proveedores => '$baseUrl/proveedores';

  /// Endpoint GET /api/proveedores/:id
  static String proveedorDetalle(int id) => '$baseUrl/proveedores/$id';

  /// Endpoint GET y POST /api/productos
  static String get productos => '$baseUrl/productos';

  /// Endpoint GET y POST /api/pedidos
  static String get pedidos => '$baseUrl/pedidos';

  /// Endpoint GET /api/categorias
  static String get categorias => '$baseUrl/categorias';

  // =========================================================================
  // ENDPOINTS DE AUTENTICACIÓN Y REGISTRO
  // =========================================================================

  /// Endpoint POST /api/auth/register
  static String get authRegister => '$baseUrl/auth/register';

  /// Endpoint POST /api/auth/login
  static String get authLogin => '$baseUrl/auth/login';

  /// Endpoint GET /api/auth/users (Persistencia)
  static String get authUsers => '$baseUrl/auth/users';

  /// Endpoint GET /api/health (Estado del Backend)
  static String get health => '$baseUrl/health';

  /// Timeout estándar para peticiones en red (12 segundos)
  static const Duration timeout = Duration(seconds: 12);

  /// Headers estándar para peticiones JSON
  static Map<String, String> get headersJson => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
}
