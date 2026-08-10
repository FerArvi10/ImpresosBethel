import 'package:flutter/material.dart';
import '../models/orden.dart';
import '../widgets/orden_card.dart';
import 'detalle_orden_screen.dart';
import 'nueva_orden_screen.dart';

// StatefulWidget porque la lista de ordenes cambia
// (estados, favoritos y eliminaciones se actualizan en tiempo real)
class ListadoScreen extends StatefulWidget {
  const ListadoScreen({super.key});

  @override
  State<ListadoScreen> createState() => _ListadoScreenState();
}

// SingleTickerProviderStateMixin es necesario para que el TabController
// funcione con animacion (cambio de pestaña)
class _ListadoScreenState extends State<ListadoScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Lista de ordenes de ejemplo
  final List<Orden> _ordenes = [
    Orden(
      numeroOrden: 1,
      cliente: 'Carlos Lopez',
      productos: ['Baleada con huevo', 'Agua embotellada'],
      total: 40.10,
    ),
    Orden(
      numeroOrden: 2,
      cliente: 'Maria Garcia',
      productos: ['Arroz con pollo', 'Cafe'],
      total: 85.00,
      estado: 'En preparacion',
    ),
    Orden(
      numeroOrden: 3,
      cliente: 'Juan Perez',
      productos: ['Pastelitos de pollo'],
      total: 10.00,
      estado: 'Lista',
    ),
  ];

  // Guarda que ordenes fueron marcadas como urgentes (IconButton)
  final Set<int> _urgentes = {};

  @override
  void initState() {
    super.initState();
    // 2 pestañas: Activas y Completadas
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ─────────────────────────
  // Filtra las ordenes segun la pestaña
  // ─────────────────────────
  List<Orden> get _ordenesActivas =>
      _ordenes.where((o) => o.estado != 'Lista').toList()
        ..sort((a, b) => a.estado == 'Pendiente' ? -1 : 1);

  List<Orden> get _ordenesCompletadas =>
      _ordenes.where((o) => o.estado == 'Lista').toList();

  // ─────────────────────────
  // Avanza el estado de una orden (boton dentro de OrdenCard)
  // ─────────────────────────
  void _avanzarEstado(Orden orden) {
    setState(() {
      if (orden.estado == 'Pendiente') {
        orden.marcarEnPreparacion();
      } else if (orden.estado == 'En preparacion') {
        orden.marcarComoLista();
      }
    });
  }

  // ─────────────────────────
  // IconButton: marca/desmarca una orden como urgente
  // ─────────────────────────
  void _toggleUrgente(int numeroOrden) {
    setState(() {
      if (_urgentes.contains(numeroOrden)) {
        _urgentes.remove(numeroOrden);
      } else {
        _urgentes.add(numeroOrden);
      }
    });
  }

  void _eliminarOrden(Orden orden) {
    final index = _ordenes.indexOf(orden);

    setState(() {
      _ordenes.remove(orden);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Orden #${orden.numeroOrden} eliminada'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'DESHACER',
          onPressed: () {
            setState(() {
              _ordenes.insert(index, orden);
            });
          },
        ),
      ),
    );
  }

  // Construye la lista de tarjetas para una pestaña
  Widget _construirLista(List<Orden> lista, {bool permiteEliminar = true}) {
    if (lista.isEmpty) {
      return const Center(
        child: Text(
          'No hay ordenes en esta seccion',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: lista.length,
      itemBuilder: (context, index) {
        final orden = lista[index];
        final esUrgente = _urgentes.contains(orden.numeroOrden);

        final tarjeta = Stack(
          children: [
            OrdenCard(
              orden: orden,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetalleOrdenScreen(orden: orden),
                  ),
                );
              },
              onAvanzar: () => _avanzarEstado(orden),
            ),
            // IconButton de urgente, sobrepuesto arriba a la derecha de la tarjeta
            Positioned(
              top: 4,
              right: 4,
              child: IconButton(
                icon: Icon(
                  esUrgente ? Icons.priority_high : Icons.notifications_none,
                  color: esUrgente ? Colors.red : Colors.grey,
                ),
                tooltip: 'Marcar como urgente',
                onPressed: () => _toggleUrgente(orden.numeroOrden),
              ),
            ),
          ],
        );

        if (!permiteEliminar) return tarjeta;

        return Dismissible(
          key: ValueKey(orden.numeroOrden),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (direction) => _eliminarOrden(orden),
          child: tarjeta,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Ordenes'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: 'Activas (${_ordenesActivas.length})'),
            Tab(text: 'Completadas (${_ordenesCompletadas.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _construirLista(_ordenesActivas, permiteEliminar: true),
          _construirLista(_ordenesCompletadas, permiteEliminar: false),
        ],
      ),
      // FloatingActionButton: acceso directo a crear una orden nueva
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        tooltip: 'Nueva orden',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NuevaOrdenScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
