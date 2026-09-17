import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../main.dart';

/// Pantalla de Perfil y Configuración (Layout obligatorio 3: Card + ListTile, mínimo 5 opciones).
class PerfilScreen extends StatefulWidget {
  final String nombreUsuario;
  final bool mostrarAppBar;

  const PerfilScreen({
    super.key,
    this.nombreUsuario = 'Yerson Alvarenga',
    this.mostrarAppBar = false,
  });

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  bool _notificacionesPush = true;
  bool _alertasWhatsApp = true;

  void _cerrarSesion() {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.logout, color: Colors.red),
            SizedBox(width: 8),
            Text('Cerrar Sesión'),
          ],
        ),
        content: const Text('¿Estás seguro de que deseas salir de tu cuenta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(dialogCtx);
              // Limpieza total de la pila regresando al login
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            child: const Text('Salir'),
          ),
        ],
      ),
    );
  }

  void _mostrarConfiguracionServidor() {
    final ipController = TextEditingController(text: ApiConfig.ipLocalWifi);

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.dns_outlined, color: Colors.teal),
                SizedBox(width: 8),
                Text('Conexión y Servidor', style: TextStyle(fontSize: 18)),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selecciona cómo se conecta tu app móvil:',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  RadioListTile<ModoConexion>(
                    value: ModoConexion.nube,
                    groupValue: ApiConfig.modoActual,
                    title: const Text('Nube (Railway)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    subtitle: const Text('Funciona en cualquier celular con Internet', style: TextStyle(fontSize: 11)),
                    activeColor: Colors.teal,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) {
                      setModalState(() => ApiConfig.modoActual = val!);
                      setState(() {});
                    },
                  ),
                  RadioListTile<ModoConexion>(
                    value: ModoConexion.wifiLocal,
                    groupValue: ApiConfig.modoActual,
                    title: const Text('Wi-Fi Local (PC)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    subtitle: Text('IP PC: ${ApiConfig.ipLocalWifi}:3000 (Misma red)', style: const TextStyle(fontSize: 11)),
                    activeColor: Colors.teal,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) {
                      setModalState(() => ApiConfig.modoActual = val!);
                      setState(() {});
                    },
                  ),
                  RadioListTile<ModoConexion>(
                    value: ModoConexion.localhost,
                    groupValue: ApiConfig.modoActual,
                    title: const Text('USB / Localhost', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    subtitle: const Text('localhost:3000 (con adb reverse)', style: TextStyle(fontSize: 11)),
                    activeColor: Colors.teal,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) {
                      setModalState(() => ApiConfig.modoActual = val!);
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 10),
                  const Text('Cambiar IP Local Wi-Fi si tu red es diferente:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: ipController,
                    decoration: const InputDecoration(
                      isDense: true,
                      labelText: 'Dirección IPv4 de la PC',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.wifi, size: 18),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (v) {
                      ApiConfig.ipLocalWifi = v.trim();
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'URL Activa: ${ApiConfig.baseUrl}',
                    style: const TextStyle(fontSize: 11, color: Colors.teal, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton.icon(
                icon: const Icon(Icons.speed, size: 16),
                label: const Text('Probar Conexión'),
                onPressed: () async {
                  try {
                    final res = await http.get(Uri.parse(ApiConfig.health)).timeout(const Duration(seconds: 4));
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Servidor OK (${res.statusCode}): En línea'),
                          backgroundColor: Colors.teal,
                        ),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error de conexión: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Listo'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final esOscuro = Theme.of(context).brightness == Brightness.dark;

    final contenido = SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tarjeta Principal de Cabecera del Usuario
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: esOscuro ? Colors.teal.shade900 : Colors.teal.shade100,
                    child: Icon(
                      Icons.person,
                      size: 36,
                      color: esOscuro ? Colors.tealAccent : Colors.teal.shade800,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.nombreUsuario,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'cliente@bethel.hn',
                          style: TextStyle(
                            fontSize: 13,
                            color: esOscuro ? Colors.grey.shade400 : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: esOscuro
                                ? Colors.teal.withAlpha((0.2 * 255).round())
                                : Colors.teal.shade50,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: esOscuro ? Colors.tealAccent : Colors.teal.shade200,
                            ),
                          ),
                          child: Text(
                            'Cliente Preferencial',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: esOscuro ? Colors.tealAccent : Colors.teal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.edit_outlined,
                      color: esOscuro ? Colors.tealAccent : Colors.teal,
                    ),
                    tooltip: 'Editar Perfil',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Edición de perfil disponible en próxima versión'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // SECCIÓN 1: AJUSTES DE CUENTA
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              'Ajustes de Cuenta',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: esOscuro ? Colors.tealAccent : Colors.teal,
              ),
            ),
          ),

          // 5.2 Layout Obligatorio: Card con ListTile (Opción 1 y 2)
          Card(
            elevation: 1.5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Column(
              children: [
                // ListTile 1: Datos de facturación SAR
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: esOscuro
                          ? Colors.teal.withAlpha((0.2 * 255).round())
                          : Colors.teal.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.receipt_long,
                      color: esOscuro ? Colors.tealAccent : Colors.teal,
                    ),
                  ),
                  title: const Text('Datos de Facturación'),
                  subtitle: const Text('RTN y razón social para facturas SAR'),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('RTN: 0801199012345 — Impresos Bethel'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                const Divider(height: 1, indent: 64),

                // ListTile 2: Direcciones de entrega
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: esOscuro
                          ? Colors.teal.withAlpha((0.2 * 255).round())
                          : Colors.teal.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.location_on_outlined,
                      color: esOscuro ? Colors.tealAccent : Colors.teal,
                    ),
                  ),
                  title: const Text('Dirección de Envío'),
                  subtitle: const Text('Tegucigalpa, Francisco Morazán'),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 64),

                // ListTile 3: Seguridad y Contraseña
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: esOscuro
                          ? Colors.teal.withAlpha((0.2 * 255).round())
                          : Colors.teal.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.lock_outline,
                      color: esOscuro ? Colors.tealAccent : Colors.teal,
                    ),
                  ),
                  title: const Text('Seguridad y Contraseña'),
                  subtitle: const Text('Actualizar credenciales de acceso'),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 64),

                // ListTile 4: Conexión y Servidor Móvil
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: esOscuro
                          ? Colors.teal.withAlpha((0.2 * 255).round())
                          : Colors.teal.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.router_outlined,
                      color: esOscuro ? Colors.tealAccent : Colors.teal,
                    ),
                  ),
                  title: const Text('Conexión y Servidor (Celular)'),
                  subtitle: Text(
                    ApiConfig.modoActual == ModoConexion.nube
                        ? 'Nube Railway (En línea)'
                        : 'Local: ${ApiConfig.baseUrl}',
                  ),
                  trailing: const Icon(Icons.tune, color: Colors.teal),
                  onTap: _mostrarConfiguracionServidor,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // SECCIÓN 2: PREFERENCIAS Y NOTIFICACIONES
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              'Preferencias y Alertas',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: esOscuro ? Colors.tealAccent : Colors.teal,
              ),
            ),
          ),

          // 5.2 Layout Obligatorio: Card con SwitchListTile (Opción 4, 5 y 6)
          Card(
            elevation: 1.5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Column(
              children: [
                // ListTile 4: Notificaciones Push
                SwitchListTile(
                  secondary: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: esOscuro
                          ? Colors.teal.withAlpha((0.2 * 255).round())
                          : Colors.teal.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.notifications_active_outlined,
                      color: esOscuro ? Colors.tealAccent : Colors.teal,
                    ),
                  ),
                  title: const Text('Notificaciones de Pedido'),
                  subtitle: const Text('Avisar cuando un trabajo esté listo'),
                  value: _notificacionesPush,
                  activeTrackColor: Colors.teal,
                  onChanged: (val) => setState(() => _notificacionesPush = val),
                ),
                const Divider(height: 1, indent: 64),

                // ListTile 5: Alertas por WhatsApp
                SwitchListTile(
                  secondary: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: esOscuro
                          ? Colors.green.withAlpha((0.2 * 255).round())
                          : Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.chat_outlined, color: Colors.green),
                  ),
                  title: const Text('Alertas por WhatsApp'),
                  subtitle: const Text('Recibir comprobantes en formato PDF'),
                  value: _alertasWhatsApp,
                  activeTrackColor: Colors.teal,
                  onChanged: (val) => setState(() => _alertasWhatsApp = val),
                ),
                const Divider(height: 1, indent: 64),

                // ListTile 6: Modo Oscuro (Reactivo con ValueListenableBuilder)
                ValueListenableBuilder<ThemeMode>(
                  valueListenable: themeNotifier,
                  builder: (context, currentMode, _) {
                    final isDark = currentMode == ThemeMode.dark;
                    return SwitchListTile(
                      secondary: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.purple.withAlpha((0.25 * 255).round())
                              : Colors.purple.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          isDark ? Icons.dark_mode : Icons.dark_mode_outlined,
                          color: isDark ? Colors.purpleAccent : Colors.purple,
                        ),
                      ),
                      title: const Text('Modo Oscuro'),
                      subtitle: Text(
                        isDark ? 'Tema oscuro activado' : 'Tema visual para poca luz',
                      ),
                      value: isDark,
                      activeTrackColor: Colors.teal,
                      onChanged: (val) {
                        themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // SECCIÓN 3: INFORMACIÓN Y ACCIONES
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              'Soporte e Información',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: esOscuro ? Colors.tealAccent : Colors.teal,
              ),
            ),
          ),

          // 5.2 Layout Obligatorio: Card con ListTile (Opción 7 y 8)
          Card(
            elevation: 1.5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Column(
              children: [
                // ListTile 7: Acerca de
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: esOscuro
                          ? Colors.teal.withAlpha((0.2 * 255).round())
                          : Colors.teal.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.info_outline,
                      color: esOscuro ? Colors.tealAccent : Colors.teal,
                    ),
                  ),
                  title: const Text('Acerca de Impresos Bethel'),
                  subtitle: const Text('Versión 1.4.0 • Equipo de desarrollo'),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () => Navigator.pushNamed(context, '/acerca-de'),
                ),
                const Divider(height: 1, indent: 64),

                // ListTile 8: Cerrar Sesión
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: esOscuro
                          ? Colors.red.withAlpha((0.2 * 255).round())
                          : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.logout, color: Colors.red),
                  ),
                  title: const Text(
                    'Cerrar Sesión',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text('Salir de la cuenta en este dispositivo'),
                  trailing: const Icon(Icons.chevron_right, color: Colors.red),
                  onTap: _cerrarSesion,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );

    if (!widget.mostrarAppBar) {
      return contenido;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil y Ajustes'),
        centerTitle: true,
      ),
      body: contenido,
    );
  }
}
