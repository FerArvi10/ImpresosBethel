import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../models/pedido.dart';
import '../models/carrito_item.dart';
import '../widgets/mi_status_widget.dart';
import '../widgets/mi_item_card.dart';
import 'catalogo_screen.dart';
import 'historial_screen.dart';
import 'perfil_screen.dart';

/// Pantalla Principal / Dashboard de Impresos Bethel con Drawer, Tabs y Rutas con Nombre.
class HomeScreen extends StatefulWidget {
  final String? nombreUsuario;

  const HomeScreen({super.key, this.nombreUsuario});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final _formKeySheet = GlobalKey<FormState>();
  final _clienteController = TextEditingController();
  final _descripcionController = TextEditingController();
  String _tipoTrabajo = 'Talonarios';

  @override
  void dispose() {
    _clienteController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  void _mostrarFormularioBottomSheet() {
    _clienteController.clear();
    _descripcionController.clear();
    _tipoTrabajo = 'Talonarios';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Form(
            key: _formKeySheet,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Nuevo Pedido Rápido',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Campo 1: Nombre del cliente
                TextFormField(
                  controller: _clienteController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del Cliente / Empresa',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Ingrese el nombre del cliente';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Campo 2: Tipo de trabajo
                DropdownButtonFormField<String>(
                  initialValue: _tipoTrabajo,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Trabajo',
                    prefixIcon: Icon(Icons.print),
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Talonarios', child: Text('Talonarios')),
                    DropdownMenuItem(value: 'Camisetas', child: Text('Camisetas')),
                    DropdownMenuItem(value: 'Estampados', child: Text('Estampados')),
                    DropdownMenuItem(value: 'Bordados', child: Text('Bordados')),
                    DropdownMenuItem(value: 'Stickers', child: Text('Stickers')),
                    DropdownMenuItem(value: 'Sellos', child: Text('Sellos')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _tipoTrabajo = val);
                    }
                  },
                ),
                const SizedBox(height: 12),

                // Campo 3: Descripción del trabajo
                TextFormField(
                  controller: _descripcionController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Especificaciones del trabajo',
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Ingrese una descripción o requerimiento';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancelar'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        if (_formKeySheet.currentState!.validate()) {
                          final nombreCliente = _clienteController.text.trim();
                          final trabajo = _tipoTrabajo;
                          final descripcion = _descripcionController.text.trim();

                          historialPedidosDemo.insert(
                            0,
                            Pedido(
                              codigo: 'BET-${1049 + historialPedidosDemo.length}',
                              cliente: nombreCliente,
                              fecha: 'Hoy',
                              tipoTrabajo: trabajo,
                              descripcion: descripcion,
                              total: 180.00,
                              estado: EstadoPedido.pendiente,
                              cantidad: 1,
                              icono: Icons.print,
                            ),
                          );

                          Navigator.pop(ctx);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Pedido para $nombreCliente registrado'),
                              duration: const Duration(seconds: 4),
                              behavior: SnackBarBehavior.floating,
                              action: SnackBarAction(
                                label: 'VER HISTORIAL',
                                textColor: Colors.amber,
                                onPressed: () {
                                  setState(() => _currentIndex = 2);
                                },
                              ),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.save),
                      label: const Text('Guardar Pedido'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _construirTabInicio(String usuarioActual) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner de bienvenida corporativo Bethel
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal.shade800, Colors.teal.shade500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.teal.withAlpha((0.3 * 255).round()),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.print, color: Colors.white, size: 34),
                    SizedBox(width: 10),
                    Text(
                      'Impresos Bethel',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Bienvenid@, $usuarioActual',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                Text(
                  'Crecemos gracias a su preferencia',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withAlpha((0.85 * 255).round()),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // KPIs y accesos directos
          const Text(
            'Métricas Rápidas',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _kpiCard(
                  'En Catálogo',
                  '${catalogoDemo.length} productos',
                  Icons.grid_view,
                  Colors.teal,
                  () => setState(() => _currentIndex = 1),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _kpiCard(
                  'Historial',
                  '${historialPedidosDemo.length} órdenes',
                  Icons.history,
                  Colors.blue,
                  () => setState(() => _currentIndex = 2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Widget personalizado de estado (Semana 3)
          MiStatusWidget(
            estado: 'Activo',
            detalles: '${catalogoDemo.length} productos listos para cotizar y personalizar',
            progreso: 0.90,
          ),
          const SizedBox(height: 20),

          // Producto Destacado con MiItemCard
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Producto Destacado',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () => setState(() => _currentIndex = 1),
                child: const Text('Ver Todo'),
              ),
            ],
          ),
          const SizedBox(height: 6),

          MiItemCard(
            titulo: catalogoDemo[0].nombre,
            subtitulo: catalogoDemo[0].descripcion,
            valor: catalogoDemo[0].precio,
            estado: 'Disponible',
            colorAccento: Colors.teal,
            mostrarBadge: catalogoDemo[0].esPersonalizable,
            onTap: () {
              Navigator.pushNamed(context, '/detalle', arguments: catalogoDemo[0]);
            },
            onAccionSecundaria: () {
              Navigator.pushNamed(context, '/detalle', arguments: catalogoDemo[0]);
            },
          ),
          const SizedBox(height: 10),

          MiItemCard(
            titulo: catalogoDemo[1].nombre,
            subtitulo: catalogoDemo[1].descripcion,
            valor: catalogoDemo[1].precio,
            estado: 'Personalizable',
            colorAccento: Colors.teal.shade700,
            mostrarBadge: catalogoDemo[1].esPersonalizable,
            onTap: () {
              Navigator.pushNamed(context, '/detalle', arguments: catalogoDemo[1]);
            },
            onAccionSecundaria: () {
              Navigator.pushNamed(context, '/detalle', arguments: catalogoDemo[1]);
            },
          ),
        ],
      ),
    );
  }

  Widget _kpiCard(String titulo, String subtitulo, IconData icono, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.04 * 255).round()),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withAlpha((0.15 * 255).round()),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icono, color: color, size: 24),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titulo, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  Text(
                    subtitulo,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 5.1 Obtener argumentos de navegación
    final usuarioActual = widget.nombreUsuario ??
        (ModalRoute.of(context)?.settings.arguments as String?) ??
        'Yerson Alvarenga';

    final List<Widget> pantallas = [
      _construirTabInicio(usuarioActual),
      const CatalogoScreen(mostrarAppBar: false),
      const HistorialScreen(mostrarAppBar: false),
      PerfilScreen(nombreUsuario: usuarioActual, mostrarAppBar: false),
    ];

    final titulos = [
      'Impresos Bethel',
      'Catálogo Completo',
      'Historial de Pedidos',
      'Mi Perfil',
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F8),
      appBar: AppBar(
        title: Text(titulos[_currentIndex]),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Badge(
              label: Text('${carritoDemo.length}'),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            tooltip: 'Carrito de Pedidos',
            onPressed: () => Navigator.pushNamed(context, '/carrito'),
          ),
        ],
      ),

      // Drawer personalizado con Container + LinearGradient (Semana 3)
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal.shade900, Colors.teal.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.print, size: 32, color: Colors.teal),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    usuarioActual,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'OrderTracker • Impresos Bethel',
                    style: TextStyle(
                      color: Colors.white.withAlpha((0.85 * 255).round()),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Inicio'),
              selected: _currentIndex == 0,
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentIndex = 0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.grid_view),
              title: const Text('Catálogo de Productos'),
              selected: _currentIndex == 1,
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentIndex = 1);
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Historial de Pedidos'),
              selected: _currentIndex == 2,
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentIndex = 2);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart_outlined),
              title: const Text('Carrito de Compras'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/carrito');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Mi Perfil'),
              selected: _currentIndex == 3,
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentIndex = 3);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Acerca de'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/acerca-de');
              },
            ),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Cerrar sesión',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),

      body: IndexedStack(index: _currentIndex, children: pantallas),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.teal,
        onPressed: _mostrarFormularioBottomSheet,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Nuevo Pedido',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view), label: 'Catálogo'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Historial'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
