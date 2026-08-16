import 'package:flutter/material.dart';
import '../widgets/mi_status_widget.dart';
import '../widgets/mi_item_card.dart';

class PerfilScreen extends StatelessWidget {
  final String nombreUsuario;

  const PerfilScreen({
    super.key,
    required this.nombreUsuario,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.teal.shade100,
                    child: Icon(Icons.person,
                        size: 40, color: Colors.teal.shade800),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    nombreUsuario,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Cliente — Impresos Bethel',
                    style: TextStyle(
                        fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(bottom: 8.0, left: 4.0),
              child: Text('Estado de Cuenta',
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
          // Uso de MiStatusWidget en PerfilScreen
          const MiStatusWidget(
            estado: 'Activo',
            detalles: 'Cuenta activa desde 2024 — Cliente frecuente',
            progreso: 0.85,
          ),
          const SizedBox(height: 20),

          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(bottom: 8.0, left: 4.0),
              child: Text('Resumen de Pedidos',
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
          // Uso de MiItemCard en PerfilScreen
          MiItemCard(
            titulo: 'Pedidos Realizados',
            subtitulo: 'Historial de compras en Impresos Bethel',
            valor: 890.00,
            estado: 'Completado',
            mostrarBadge: false,
            colorAccento: Colors.teal,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Historial de pedidos'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            onAccionSecundaria: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Reporte generado'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
