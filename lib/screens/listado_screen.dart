import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../widgets/product_card.dart';
import '../widgets/mi_status_widget.dart';
import 'detalle_screen.dart';

class ListadoScreen extends StatefulWidget {
  const ListadoScreen({super.key});

  @override
  State<ListadoScreen> createState() => _ListadoScreenState();
}

class _ListadoScreenState extends State<ListadoScreen> {
  final List<Producto> _productos = List.from(catalogoDemo);
  final Set<int> _favoritos = {};

  void _toggleFavorito(int id) {
    setState(() {
      if (_favoritos.contains(id)) {
        _favoritos.remove(id);
      } else {
        _favoritos.add(id);
      }
    });
  }

  void _confirmarEliminacion(Producto producto) {
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red),
              SizedBox(width: 8),
              Expanded(child: Text('¿Desea eliminar este item?')),
            ],
          ),
          content: Text('Se eliminará "${producto.nombre}" del catálogo.'),
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
                _eliminarProducto(producto);
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _eliminarProducto(Producto producto) {
    final index = _productos.indexOf(producto);
    setState(() {
      _productos.remove(producto);
      _favoritos.remove(producto.id);
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${producto.nombre}" eliminado del catálogo'),
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: SnackBarAction(
          label: 'DESHACER',
          textColor: Colors.amber,
          onPressed: () {
            setState(() {
              _productos.insert(index, producto);
            });
          },
        ),
      ),
    );
  }

  void _editarProducto(Producto producto) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Editando "${producto.nombre}"'),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: SnackBarAction(
          label: 'VER',
          textColor: Colors.tealAccent,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetalleScreen(producto: producto),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_productos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            const Text(
              'No hay productos en el catálogo',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: MiStatusWidget(
            estado: 'Activo',
            detalles:
                '${_productos.length} productos disponibles — '
                '${_favoritos.length} marcados como favoritos',
            progreso: _favoritos.length / _productos.length.clamp(1, 100),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 4),
            itemCount: _productos.length,
            itemBuilder: (context, index) {
              final producto = _productos[index];
              final esFav = _favoritos.contains(producto.id);

              // Parte A: Dismissible con dos direcciones
              return Dismissible(
                key: ValueKey(producto.id),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    _editarProducto(producto);
                    return false;
                  } else {
                    _confirmarEliminacion(producto);
                    return false;
                  }
                },

                background: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade600,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.edit, color: Colors.white, size: 28),
                      SizedBox(width: 8),
                      Text(
                        'Editar',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                secondaryBackground: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.shade600,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Eliminar',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.delete, color: Colors.white, size: 28),
                    ],
                  ),
                ),

                child: GestureDetector(
                  onLongPress: () => _confirmarEliminacion(producto),
                  child: ProductCard(
                    nombre: producto.nombre,
                    categoria: producto.categoria,
                    precio: producto.precio,
                    icono: producto.icono,
                    esFavorito: esFav,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetalleScreen(producto: producto),
                        ),
                      );
                    },
                    onFavorite: () => _toggleFavorito(producto.id),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
