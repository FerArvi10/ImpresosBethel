import 'package:flutter/material.dart';
import '../models/orden.dart';

class OrdenCard extends StatelessWidget {
  final Orden orden;
  final VoidCallback onTap;
  final VoidCallback? onAvanzar;

  const OrdenCard({
    super.key,
    required this.orden,
    required this.onTap,
    this.onAvanzar,
  });

  Color _colorPorEstado(String estado) {
    switch (estado) {
      case 'Pendiente':
        return Colors.red.shade100;
      case 'En preparacion':
        return Colors.yellow.shade100;
      case 'Lista':
        return Colors.green.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _colorPorEstado(orden.estado),
      margin: const EdgeInsets.only(bottom: 12),

      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Orden #${orden.numeroOrden} - ${orden.cliente}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text('Estado: ${orden.estado}'),
                    Text('Total: L. ${orden.total.toStringAsFixed(2)}'),
                  ],
                ),
              ),

              if (orden.estado != 'Lista' && onAvanzar != null)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: onAvanzar,
                  child: const Text('Avanzar'),
                )
              else if (orden.estado == 'Lista')
                const Icon(Icons.check_circle, color: Colors.green),
            ],
          ),
        ),
      ),
    );
  }
}
