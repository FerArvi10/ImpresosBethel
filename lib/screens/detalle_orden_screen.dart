import 'package:flutter/material.dart';
import '../models/orden.dart';

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
      body: Padding(
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

            const Text(
              'Productos',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),

            // Muestra cada producto de la lista
            ...orden.productos.map(
              (producto) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    const Icon(
                      Icons.local_gas_station,
                      size: 18,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    Text(producto, style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
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
