import 'package:flutter/material.dart';

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
  bool _modoOscuro = false;

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

  @override
  Widget build(BuildContext context) {
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
                    backgroundColor: Colors.teal.shade100,
                    child: Icon(Icons.person, size: 36, color: Colors.teal.shade800),
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
                          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.teal.shade50,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.teal.shade200),
                          ),
                          child: const Text(
                            'Cliente Preferencial',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Colors.teal),
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
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              'Ajustes de Cuenta',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.teal),
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
                      color: Colors.teal.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.receipt_long, color: Colors.teal),
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
                      color: Colors.teal.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.location_on_outlined, color: Colors.teal),
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
                      color: Colors.teal.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.lock_outline, color: Colors.teal),
                  ),
                  title: const Text('Seguridad y Contraseña'),
                  subtitle: const Text('Actualizar credenciales de acceso'),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // SECCIÓN 2: PREFERENCIAS Y NOTIFICACIONES
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              'Preferencias y Alertas',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.teal),
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
                      color: Colors.teal.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.notifications_active_outlined, color: Colors.teal),
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
                      color: Colors.green.shade50,
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

                // ListTile 6: Modo Oscuro
                SwitchListTile(
                  secondary: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.dark_mode_outlined, color: Colors.purple),
                  ),
                  title: const Text('Modo Oscuro'),
                  subtitle: const Text('Tema visual para poca luz'),
                  value: _modoOscuro,
                  activeTrackColor: Colors.teal,
                  onChanged: (val) => setState(() => _modoOscuro = val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // SECCIÓN 3: INFORMACIÓN Y ACCIONES
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              'Soporte e Información',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.teal),
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
                      color: Colors.teal.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.info_outline, color: Colors.teal),
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
                      color: Colors.red.shade50,
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
      backgroundColor: const Color(0xFFF6F8F8),
      appBar: AppBar(
        title: const Text('Mi Perfil y Ajustes'),
        centerTitle: true,
      ),
      body: contenido,
    );
  }
}
