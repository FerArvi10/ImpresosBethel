import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'listado_screen.dart';
import 'perfil_screen.dart';
import 'acerca_de_screen.dart';
import '../models/producto.dart';
import '../widgets/mi_status_widget.dart';
import '../widgets/mi_item_card.dart';

class HomeScreen extends StatefulWidget {
  final String nombreUsuario;

  const HomeScreen({super.key, required this.nombreUsuario});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Map<String, dynamic>> _pedidos = [];

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

  // Parte A: FAB.extended abre BottomSheet con formulario de 3 campos
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
                      'Nuevo Pedido',
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
                    labelText: 'Nombre del Cliente',
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

                // Campo 2: Tipo de trabajo (Dropdown)
                DropdownButtonFormField<String>(
                  initialValue: _tipoTrabajo,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Trabajo',
                    prefixIcon: Icon(Icons.print),
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                        value: 'Talonarios', child: Text('Talonarios')),
                    DropdownMenuItem(
                        value: 'Camisetas', child: Text('Camisetas')),
                    DropdownMenuItem(
                        value: 'Estampados', child: Text('Estampados')),
                    DropdownMenuItem(
                        value: 'Bordados', child: Text('Bordados')),
                    DropdownMenuItem(
                        value: 'Stickers', child: Text('Stickers')),
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
                    labelText: 'Descripción del trabajo',
                    prefixIcon: Icon(Icons.description),
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Ingrese una descripción';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Botón Cancelar cierra el BottomSheet
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

                          setState(() {
                            _pedidos.insert(0, {
                              'cliente': nombreCliente,
                              'tipo': trabajo,
                              'descripcion': descripcion,
                              'precio': 120.00,
                              'estado': 'En proceso',
                            });
                          });

                          Navigator.pop(ctx);

                          // Parte B.3: SnackBar flotante con 5s de duración
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Pedido para $nombreCliente registrado',
                              ),
                              duration: const Duration(seconds: 5),
                              behavior: SnackBarBehavior.floating,
                              margin: const EdgeInsets.all(12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              action: SnackBarAction(
                                label: 'VER',
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
                      label: const Text('Guardar'),
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

  // Tab Inicio: dashboard con MiItemCard y MiStatusWidget
  Widget _construirTabInicio() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner de bienvenida
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.teal.shade700, Colors.teal.shade400],
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
                    Icon(Icons.print, color: Colors.white, size: 36),
                    SizedBox(width: 10),
                    Text(
                      'Impresos Bethel',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Bienvenid@, ${widget.nombreUsuario}',
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

          const Text('Estado de la Tienda',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          // Uso de MiStatusWidget en tab Inicio
          MiStatusWidget(
            estado: 'Activo',
            detalles: '${catalogoDemo.length} productos en catálogo',
            progreso: 0.85,
          ),

          const SizedBox(height: 20),
          const Text('Producto Destacado',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          // Uso de MiItemCard en tab Inicio
          MiItemCard(
            titulo: catalogoDemo[0].nombre,
            subtitulo: catalogoDemo[0].descripcion,
            valor: catalogoDemo[0].precio,
            estado: 'Activo',
            colorAccento: Colors.teal,
            mostrarBadge: catalogoDemo[0].esPersonalizable,
            onTap: () => setState(() => _currentIndex = 1),
            onAccionSecundaria: () => setState(() => _currentIndex = 1),
          ),
        ],
      ),
    );
  }

  // Tab Pedidos: lista interactiva de pedidos registrados
  Widget _construirTabPedidos() {
    if (_pedidos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined,
                size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text('Aún no tienes pedidos registrados',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
            const SizedBox(height: 8),
            Text('Usa el botón "Nuevo Pedido" para crear uno',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      itemCount: _pedidos.length,
      itemBuilder: (context, index) {
        final pedido = _pedidos[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: MiItemCard(
            titulo: '${pedido['tipo']} — ${pedido['cliente']}',
            subtitulo: pedido['descripcion'] as String,
            valor: pedido['precio'] as double,
            estado: pedido['estado'] as String,
            colorAccento: Colors.teal,
            mostrarBadge: true,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Pedido de ${pedido['cliente']} seleccionado'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            onAccionSecundaria: () {
              showDialog(
                context: context,
                builder: (dialogCtx) => AlertDialog(
                  title: Row(
                    children: [
                      const Icon(Icons.receipt, color: Colors.teal),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Pedido: ${pedido['tipo']}',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('• Cliente: ${pedido['cliente']}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('• Estado: ${pedido['estado']}'),
                      const SizedBox(height: 4),
                      Text('• Total: L ${(pedido['precio'] as double).toStringAsFixed(2)}'),
                      const SizedBox(height: 8),
                      Text('• Descripción:\n${pedido['descripcion']}'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogCtx),
                      child: const Text('Cerrar'),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.delete, size: 16),
                      label: const Text('Eliminar'),
                      onPressed: () {
                        Navigator.pop(dialogCtx);
                        setState(() {
                          _pedidos.removeAt(index);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Pedido eliminado correctamente'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Parte B.1: 4 secciones del BottomNavigationBar
    final List<Widget> pantallas = [
      _construirTabInicio(),
      const ListadoScreen(),
      _construirTabPedidos(),
      PerfilScreen(nombreUsuario: widget.nombreUsuario),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        title: const Text('Impresos Bethel'),
        centerTitle: true,
      ),

      // Parte B.2: Drawer con DrawerHeader personalizado (NO UserAccountsDrawerHeader)
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // DrawerHeader personalizado con Container + LinearGradient
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal.shade900, Colors.teal.shade500],
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
                    child:
                        Icon(Icons.print, size: 32, color: Colors.teal),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.nombreUsuario,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Impresos Bethel',
                    style: TextStyle(
                      color:
                          Colors.white.withAlpha((0.85 * 255).round()),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // Mínimo 5 opciones con ListTile
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Inicio'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentIndex = 0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.grid_view),
              title: const Text('Catálogo Completo'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentIndex = 1);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag_outlined),
              title: const Text('Mis Pedidos'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentIndex = 2);
              },
            ),

            // ExpansionTile con 3 sub-opciones
            ExpansionTile(
              leading: const Icon(Icons.category_outlined),
              title: const Text('Categorías'),
              children: [
                ListTile(
                  leading: const Icon(Icons.receipt_long, size: 20),
                  title: const Text('Talonarios'),
                  contentPadding: const EdgeInsets.only(left: 32),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _currentIndex = 1);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.checkroom, size: 20),
                  title: const Text('Camisetas'),
                  contentPadding: const EdgeInsets.only(left: 32),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _currentIndex = 1);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.brush, size: 20),
                  title: const Text('Estampados'),
                  contentPadding: const EdgeInsets.only(left: 32),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _currentIndex = 1);
                  },
                ),
              ],
            ),

            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Mi Perfil'),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AcercaDeScreen(),
                  ),
                );
              },
            ),
            const Divider(),

            // Cerrar sesión con ícono Icons.logout y color rojo
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Cerrar sesión',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),

      // Parte B.1: IndexedStack mantiene el estado de cada sección
      body: IndexedStack(index: _currentIndex, children: pantallas),

      // Parte A: FloatingActionButton.extended con ícono Y texto
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.teal,
        onPressed: _mostrarFormularioBottomSheet,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Nuevo Pedido',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      // Parte B.1: BottomNavigationBar con 4 secciones
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
              icon: Icon(Icons.grid_view), label: 'Catálogo'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag), label: 'Pedidos'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
