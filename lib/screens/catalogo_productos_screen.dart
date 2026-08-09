import 'package:flutter/material.dart';
import '../data/productos_data.dart';
import '../models/producto.dart';
import '../widgets/producto_detalle_modal.dart';

class CatalogoProductosScreen extends StatefulWidget {
  const CatalogoProductosScreen({super.key});

  @override
  State<CatalogoProductosScreen> createState() =>
      _CatalogoProductosScreenState();
}

class _CatalogoProductosScreenState extends State<CatalogoProductosScreen> {
  String _busqueda = '';
  String _categoriaSeleccionada = 'Todos';

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

  @override
  Widget build(BuildContext context) {
    final productos = _productosFiltrados;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Catálogo de Productos'),
        centerTitle: true,
      ),
      body: Column(
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

          // Lista de Productos
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: productos.length,
                    itemBuilder: (context, index) {
                      final prod = productos[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () {
                            ProductoDetalleModal.mostrar(context, prod);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Icono contenedor
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    prod.icono,
                                    size: 32,
                                    color: Colors.orange,
                                  ),
                                ),
                                const SizedBox(width: 14),

                                // Información del producto
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              prod.nombre,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            'L. ${prod.precio.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.orange,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        prod.descripcion,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              prod.categoria,
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Icon(Icons.timer_outlined,
                                              size: 14, color: Colors.grey.shade600),
                                          const SizedBox(width: 2),
                                          Text(
                                            prod.tiempoPreparacion,
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                          const Spacer(),
                                          const Text(
                                            'Ver detalle',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.orange,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Icon(
                                            Icons.chevron_right,
                                            size: 16,
                                            color: Colors.orange,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
