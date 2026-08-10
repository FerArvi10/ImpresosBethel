import 'package:flutter/material.dart';
import '../data/productos_data.dart';
import '../models/producto.dart';
import '../widgets/producto_card.dart';
import '../widgets/producto_detalle_modal.dart';

class CatalogoProductosScreen extends StatefulWidget {
  const CatalogoProductosScreen({super.key});

  @override
  State<CatalogoProductosScreen> createState() =>
      _CatalogoProductosScreenState();
}

class _CatalogoProductosScreenState extends State<CatalogoProductosScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _busqueda = '';
  String _categoriaSeleccionada = 'Todos';

  // Conjunto de IDs de productos marcados como favoritos
  final Set<String> _favoritos = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<String> get _categorias {
    final categoriasUnicas = ProductosData.listaProductos
        .map((p) => p.categoria)
        .toSet()
        .toList();
    return ['Todos', ...categoriasUnicas];
  }

  List<Producto> get _productosFiltrados {
    return ProductosData.listaProductos.where((producto) {
      final coincideBusqueda = producto.nombre
              .toLowerCase()
              .contains(_busqueda.toLowerCase()) ||
          producto.descripcion
              .toLowerCase()
              .contains(_busqueda.toLowerCase()) ||
          producto.ingredientes.any((ing) =>
              ing.toLowerCase().contains(_busqueda.toLowerCase()));

      final coincideCategoria = _categoriaSeleccionada == 'Todos' ||
          producto.categoria == _categoriaSeleccionada;

      return coincideBusqueda && coincideCategoria;
    }).toList();
  }

  List<Producto> get _productosFavoritos {
    return ProductosData.listaProductos
        .where((p) => _favoritos.contains(p.id))
        .toList();
  }

  void _toggleFavorito(Producto producto) {
    final esFav = _favoritos.contains(producto.id);
    setState(() {
      if (esFav) {
        _favoritos.remove(producto.id);
      } else {
        _favoritos.add(producto.id);
      }
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          esFav
              ? '${producto.nombre} removido de favoritos'
              : '${producto.nombre} agregado a favoritos',
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'DESHACER',
          onPressed: () {
            setState(() {
              if (esFav) {
                _favoritos.add(producto.id);
              } else {
                _favoritos.remove(producto.id);
              }
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productos = _productosFiltrados;
    final favoritos = _productosFavoritos;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Catálogo de Productos'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            const Tab(
              icon: Icon(Icons.restaurant_menu),
              text: 'Catálogo',
            ),
            Tab(
              icon: const Icon(Icons.favorite),
              text: 'Favoritos (${favoritos.length})',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Pestaña 1: Catálogo Completo con búsqueda y filtros
          Column(
            children: [
              // Campo de búsqueda
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: TextField(
                  onChanged: (val) => setState(() => _busqueda = val),
                  decoration: InputDecoration(
                    hintText: 'Buscar producto o ingrediente...',
                    prefixIcon: const Icon(Icons.search, color: Colors.orange),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
              ),

              // Filtro por categorías
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Row(
                  children: _categorias.map((cat) {
                    final seleccionada = cat == _categoriaSeleccionada;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(cat),
                        selected: seleccionada,
                        selectedColor: Colors.orange,
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(
                          color: seleccionada ? Colors.white : Colors.black87,
                          fontWeight:
                              seleccionada ? FontWeight.bold : FontWeight.normal,
                        ),
                        onSelected: (val) {
                          setState(() {
                            _categoriaSeleccionada = cat;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 8),

              // Lista de Productos usando el widget personalizado reutilizable ProductoCard
              Expanded(
                child: productos.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off,
                                size: 64, color: Colors.grey.shade400),
                            const SizedBox(height: 12),
                            Text(
                              'No se encontraron productos',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        itemCount: productos.length,
                        itemBuilder: (context, index) {
                          final prod = productos[index];
                          return ProductoCard(
                            producto: prod,
                            isFavorite: _favoritos.contains(prod.id),
                            onTap: () {
                              ProductoDetalleModal.mostrar(context, prod);
                            },
                            onFavorite: () => _toggleFavorito(prod),
                          );
                        },
                      ),
              ),
            ],
          ),

          // Pestaña 2: Lista de Favoritos usando ProductoCard
          favoritos.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite_border,
                          size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 12),
                      Text(
                        'Aún no has agregado productos a favoritos',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Toca el ícono de corazón en cualquier producto para guardarlo aquí.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 16),
                  itemCount: favoritos.length,
                  itemBuilder: (context, index) {
                    final prod = favoritos[index];
                    return ProductoCard(
                      producto: prod,
                      isFavorite: true,
                      onTap: () {
                        ProductoDetalleModal.mostrar(context, prod);
                      },
                      onFavorite: () => _toggleFavorito(prod),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
