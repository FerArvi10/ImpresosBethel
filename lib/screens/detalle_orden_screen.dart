import 'package:flutter/material.dart';
import '../data/productos_data.dart';
import '../models/orden.dart';
import '../widgets/producto_detalle_modal.dart';

class DetalleOrdenScreen extends StatelessWidget {
  final Orden orden;

  const DetalleOrdenScreen({super.key, required this.orden});

  Color _colorPorEstado(String estado) {
    switch (estado) {
      case 'Pendiente':
        return Colors.red;
      case 'En preparacion':
        return Colors.orange;
      case 'Lista':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Orden #${orden.numeroOrden}'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: _colorPorEstado(orden.estado),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                orden.estado,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'Cliente',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Text(
              orden.cliente,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Productos',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  'Toca un producto para ver detalle',
                  style: TextStyle(fontSize: 12, color: Colors.orange, fontStyle: FontStyle.italic),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Muestra cada producto de la lista interactivo
            ...orden.productos.map(
              (nombreProducto) {
                final productoInfo = ProductosData.obtenerPorNombre(nombreProducto);
                final icono = productoInfo?.icono ?? Icons.fastfood_outlined;

                return Card(
                  elevation: 1,
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: Icon(
                      icono,
                      color: Colors.orange,
                    ),
                    title: Text(
                      nombreProducto.trim(),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    subtitle: productoInfo != null
                        ? Text(
                            '${productoInfo.categoria} • ${productoInfo.tiempoPreparacion}',
                            style: const TextStyle(fontSize: 12),
                          )
                        : null,
                    trailing: const Icon(Icons.info_outline, size: 20, color: Colors.orange),
                    onTap: () {
                      if (productoInfo != null) {
                        ProductoDetalleModal.mostrar(context, productoInfo);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Detalle de "$nombreProducto" no encontrado en el catálogo.'),
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            ),

            const Divider(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'L. ${orden.total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
