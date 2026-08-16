import 'package:flutter/material.dart';
import '../models/producto.dart';

/// Pantalla de detalle de un producto de Impresos Bethel.
class DetalleScreen extends StatelessWidget {
  final Producto producto;

  const DetalleScreen({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(producto.nombre)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(producto.icono,
                    size: 56,
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
            ),
            const SizedBox(height: 20),
            Text(producto.nombre,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Chip(label: Text(producto.categoria)),
            const SizedBox(height: 12),
            Text(
              'L ${producto.precio.toStringAsFixed(2)}',
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.teal),
            ),
            const SizedBox(height: 16),
            Text(producto.descripcion,
                style: const TextStyle(fontSize: 15, height: 1.4)),
            if (producto.esPersonalizable) ...[
              const SizedBox(height: 12),
              const Row(
                children: [
                  Icon(Icons.brush, size: 18, color: Colors.orange),
                  SizedBox(width: 6),
                  Text('Producto personalizable',
                      style: TextStyle(color: Colors.orange)),
                ],
              ),
            ],
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.shopping_cart),
                label: const Text('Agregar al pedido'),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${producto.nombre} agregado al pedido'),
                      action: SnackBarAction(
                        label: 'DESHACER',
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
