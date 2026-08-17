import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../models/categoria.dart';
import '../widgets/product_grid_card.dart';

/// Pantalla de Catálogo con GridView.builder, Responsive y Filtros (Layout obligatorio 2).
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Producto> get _productosFiltrados {
    return catalogoDemo.where((prod) {
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
    // 5.3 Responsive básico: calcula el número de columnas según el ancho de pantalla
    final screenWidth = MediaQuery.of(context).size.width;
    final int crossAxisCount = screenWidth > 900
        ? 4
        : screenWidth > 600
            ? 3
            : 2;

    final double childAspectRatio = screenWidth > 600 ? 0.88 : 0.78;

    final contenido = Column(
      children: [
        // 5.4 Filtro / Búsqueda funcional: Barra de búsqueda reactiva con TextField
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            controller: _searchController,
            onChanged: (val) => setState(() => _query = val.trim()),
            decoration: InputDecoration(
              hintText: 'Buscar en catálogo (talonarios, camisetas, sellos...)',
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
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.teal, width: 1.5),
              ),
            ),
          ),
        ),

        // 5.4 Filtro por categoría: Barra horizontal de ChoiceChips
        SizedBox(
          height: 48,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: categoriasDisponibles.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final cat = categoriasDisponibles[index];
              final isSelected = _categoriaSeleccionada == cat.id;

              return ChoiceChip(
                avatar: Icon(
                  cat.icono,
                  size: 16,
                  color: isSelected ? Colors.white : Colors.teal.shade700,
                ),
                label: Text(cat.nombre),
                selected: isSelected,
                selectedColor: Colors.teal,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade800,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12,
                ),
                onSelected: (selected) {
                  setState(() {
                    _categoriaSeleccionada = selected ? cat.id : 'todas';
                  });
                },
              );
            },
          ),
        ),

        // Contador de resultados
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_productosFiltrados.length} productos encontrados',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (_categoriaSeleccionada != 'todas' || _query.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    _searchController.clear();
                    setState(() {
                      _categoriaSeleccionada = 'todas';
                      _query = '';
                    });
                  },
                  child: const Text(
                    'Limpiar filtros',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),

        // 5.2 Layout Obligatorio: GridView.builder con lazy loading
        Expanded(
          child: _productosFiltrados.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 12),
                      Text(
                        'No encontramos productos con "$_query"',
                        style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Intenta buscando otra categoría o palabra clave',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
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
                      // 5.1 Navegación con rutas con nombre y envío de argumentos tipados
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/detalle',
                          arguments: producto,
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );

    if (!widget.mostrarAppBar) {
      return contenido;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F8),
      appBar: AppBar(
        title: const Text('Catálogo de Productos'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            tooltip: 'Ver Carrito',
            onPressed: () => Navigator.pushNamed(context, '/carrito'),
          ),
        ],
      ),
      body: contenido,
    );
  }
}
