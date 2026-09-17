import 'package:flutter/material.dart';
import '../config/api_config.dart';
import '../models/producto.dart';
import '../models/categoria.dart';
import '../services/producto_service.dart';
import '../widgets/product_grid_card.dart';

/// Pantalla de Catálogo conectada a MySQL mediante API REST (Node.js + Express + Sequelize).
/// Cumple con todos los requerimientos de la actividad:
/// 1. Petición GET asíncrona a /api/productos
/// 2. Creación POST de productos
/// 3. Manejo de los 5 estados: Carga, Éxito, Lista vacía, Error de servidor y Conexión.
class CatalogoScreen extends StatefulWidget {
  final bool mostrarAppBar;

  const CatalogoScreen({
    super.key,
    this.mostrarAppBar = true,
  });

  @override
  State<CatalogoScreen> createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends State<CatalogoScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _categoriaSeleccionada = 'todas';
  String _query = '';
  final Set<int> _favoritos = {};

  // Estados de la API REST
  bool _cargando = true;
  String? _mensajeError;
  bool _esOffline = false;
  List<Producto> _productos = [];

  @override
  void initState() {
    super.initState();
    _cargarProductosApi();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Consulta la lista de productos al backend de Impresos Bethel
  Future<void> _cargarProductosApi() async {
    setState(() {
      _cargando = true;
      _mensajeError = null;
    });

    final resultado = await ProductoService.obtenerProductos(usarMockSiFalla: true);

    if (!mounted) return;

    setState(() {
      _cargando = false;
      _productos = resultado.productos;
      _esOffline = resultado.esOffline;
      if (!resultado.exito && _productos.isEmpty) {
        _mensajeError = resultado.mensaje;
      }
    });
  }

  /// Diálogo para crear un nuevo producto (Demostración de POST /api/productos)
  void _mostrarDialogoNuevoProducto() {
    final nombreCtrl = TextEditingController();
    final categoriaCtrl = TextEditingController(text: 'Talonarios');
    final precioCtrl = TextEditingController(text: '150.00');
    final stockCtrl = TextEditingController(text: '20');
    final descCtrl = TextEditingController();
    bool guardando = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.add_shopping_cart, color: Colors.teal),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Nuevo Producto (POST)',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Se enviará un POST a ${ApiConfig.productos} persistiendo en MySQL con Sequelize.',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: nombreCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del producto',
                        hintText: 'Ej. Talonario de Recibos',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: categoriaCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Categoría',
                        hintText: 'Talonarios, Camisetas, Sellos...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: precioCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Precio (L.)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: stockCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Stock',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: descCtrl,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Descripción',
                        hintText: 'Detalles del trabajo gráfico',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: guardando ? null : () => Navigator.pop(dialogCtx),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: guardando
                      ? null
                      : () async {
                          if (nombreCtrl.text.trim().isEmpty) return;

                          setDialogState(() => guardando = true);

                          final nuevo = Producto(
                            id: 0,
                            nombre: nombreCtrl.text.trim(),
                            categoria: categoriaCtrl.text.trim(),
                            precio: double.tryParse(precioCtrl.text) ?? 100.0,
                            stockDisponible: int.tryParse(stockCtrl.text) ?? 10,
                            descripcion: descCtrl.text.trim(),
                            esPersonalizable: true,
                            icono: Icons.inventory_2_outlined,
                          );

                          final messenger = ScaffoldMessenger.of(context);
                          final nav = Navigator.of(dialogCtx);

                          final exito = await ProductoService.crearProducto(nuevo);

                          if (nav.mounted) {
                            nav.pop();
                          }

                          if (mounted) {
                            messenger.showSnackBar(
                              SnackBar(
                                content: Text(
                                  exito
                                      ? '✅ Producto guardado en MySQL con Sequelize!'
                                      : '⚠️ Error al guardar producto en el servidor.',
                                ),
                                backgroundColor: exito ? Colors.teal : Colors.red,
                              ),
                            );
                            _cargarProductosApi();
                          }
                        },
                  icon: guardando
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.cloud_upload),
                  label: Text(guardando ? 'Guardando...' : 'Crear en MySQL'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  List<Producto> get _productosFiltrados {
    return _productos.where((prod) {
      final coincideCategoria = _categoriaSeleccionada == 'todas' ||
          prod.categoria.toLowerCase() == _categoriaSeleccionada.toLowerCase();

      final coincideTexto = _query.isEmpty ||
          prod.nombre.toLowerCase().contains(_query.toLowerCase()) ||
          prod.descripcion.toLowerCase().contains(_query.toLowerCase());

      return coincideCategoria && coincideTexto;
    }).toList();
  }

  void _toggleFavorito(int id) {
    setState(() {
      if (_favoritos.contains(id)) {
        _favoritos.remove(id);
      } else {
        _favoritos.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final int crossAxisCount = screenWidth > 900
        ? 4
        : screenWidth > 600
            ? 3
            : 2;

    final double childAspectRatio = screenWidth > 600 ? 0.88 : 0.78;

    final contenido = Column(
      children: [
        // Banner indicador de estado de conexión a la API / MySQL
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: _esOffline
              ? Colors.orange.withAlpha((0.15 * 255).round())
              : Colors.teal.withAlpha((0.12 * 255).round()),
          child: Row(
            children: [
              Icon(
                _esOffline ? Icons.cloud_off : Icons.cloud_done,
                size: 18,
                color: _esOffline ? Colors.orange.shade800 : Colors.teal.shade800,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _esOffline
                      ? 'Modo Respaldo • Sin conexión directa con el backend MySQL'
                      : 'Conectado a MySQL con Sequelize • API: /api/productos (${_productos.length} items)',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _esOffline ? Colors.orange.shade900 : Colors.teal.shade900,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh, size: 18),
                color: Colors.teal.shade800,
                tooltip: 'Recargar de la base de datos',
                onPressed: _cargarProductosApi,
              ),
            ],
          ),
        ),

        // Barra de búsqueda reactiva
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
          child: TextField(
            controller: _searchController,
            onChanged: (val) => setState(() => _query = val.trim()),
            decoration: InputDecoration(
              hintText: 'Buscar productos (talonarios, camisetas, sellos...)',
              prefixIcon: const Icon(Icons.search, color: Colors.teal),
              suffixIcon: _query.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _query = '');
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              filled: true,
              fillColor: Theme.of(context).cardTheme.color ?? Theme.of(context).cardColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.withAlpha((0.3 * 255).round())),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.withAlpha((0.3 * 255).round())),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.teal, width: 2),
              ),
            ),
          ),
        ),

        // Selector de categorías
        SizedBox(
          height: 48,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: FilterChip(
                  label: const Text('Todas'),
                  selected: _categoriaSeleccionada == 'todas',
                  onSelected: (selected) {
                    setState(() => _categoriaSeleccionada = 'todas');
                  },
                  selectedColor: Colors.teal.shade100,
                  checkmarkColor: Colors.teal.shade900,
                ),
              ),
              ...categoriasDisponibles.map((cat) {
                final esSeleccionada =
                    _categoriaSeleccionada.toLowerCase() == cat.nombre.toLowerCase();
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    avatar: Icon(cat.icono, size: 16),
                    label: Text(cat.nombre),
                    selected: esSeleccionada,
                    onSelected: (selected) {
                      setState(() {
                        _categoriaSeleccionada =
                            selected ? cat.nombre.toLowerCase() : 'todas';
                      });
                    },
                    selectedColor: Colors.teal.shade100,
                    checkmarkColor: Colors.teal.shade900,
                  ),
                );
              }),
            ],
          ),
        ),

        // Cuerpo: Manejo de los Estados de Carga, Error, Vacío y Éxito
        Expanded(
          child: RefreshIndicator(
            onRefresh: _cargarProductosApi,
            color: Colors.teal,
            child: Builder(
              builder: (context) {
                // 1. ESTADO: INDICADOR DE CARGA
                if (_cargando) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Colors.teal),
                        SizedBox(height: 16),
                        Text(
                          'Consultando base de datos MySQL...',
                          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  );
                }

                // 2. ESTADO: ERROR DE CONEXIÓN O SERVIDOR (sin datos)
                if (_mensajeError != null && _productos.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.cloud_off_rounded, size: 64, color: Colors.redAccent),
                          const SizedBox(height: 16),
                          const Text(
                            'Error al conectar con el servidor',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _mensajeError!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: _cargarProductosApi,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Reintentar conexión'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // 3. ESTADO: LISTA VACÍA
                if (_productosFiltrados.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Text(
                          _query.isNotEmpty
                              ? 'No encontramos productos con "$_query"'
                              : 'No hay productos disponibles en esta categoría.',
                          style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: _mostrarDialogoNuevoProducto,
                          icon: const Icon(Icons.add),
                          label: const Text('Registrar nuevo producto (POST)'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // 4. ESTADO: RESPUESTA EXITOSA CON PRODUCTOS
                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: childAspectRatio,
                  ),
                  itemCount: _productosFiltrados.length,
                  itemBuilder: (context, index) {
                    final producto = _productosFiltrados[index];
                    final esFav = _favoritos.contains(producto.id);

                    return ProductGridCard(
                      producto: producto,
                      esFavorito: esFav,
                      onFavorite: () => _toggleFavorito(producto.id),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/detalle',
                          arguments: producto,
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );

    if (!widget.mostrarAppBar) {
      return Stack(
        children: [
          contenido,
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton.extended(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: const Text('Nuevo (POST)'),
              onPressed: _mostrarDialogoNuevoProducto,
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo — Impresos Bethel'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Crear producto (POST /api/productos)',
            onPressed: _mostrarDialogoNuevoProducto,
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            tooltip: 'Ver Carrito',
            onPressed: () => Navigator.pushNamed(context, '/carrito'),
          ),
        ],
      ),
      body: contenido,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Nuevo (POST)'),
        onPressed: _mostrarDialogoNuevoProducto,
      ),
    );
  }
}
