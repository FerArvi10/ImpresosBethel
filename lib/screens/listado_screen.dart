import 'package:flutter/material.dart';
import '../models/orden.dart';
import 'detalle_orden_screen.dart';

class ListadoScreen extends StatefulWidget {
  const ListadoScreen({super.key});

  @override
  State<ListadoScreen> createState() => _ListadoScreenState();
}

class _ListadoScreenState extends State<ListadoScreen> {
  final List<Orden> _ordenes = [
    Orden(
      numeroOrden: 1,
      cliente: 'Carlos Lopez',
      productos: ['Gasolina 5 galones', 'Agua embotellada'],
      total: 285.50,
    ),
    Orden(
      numeroOrden: 2,
      cliente: 'Maria Garcia',
      productos: ['Diesel 10 galones', 'Cafe'],
      total: 620.00,
      estado: 'En preparacion',
    ),
    Orden(
      numeroOrden: 3,
      cliente: 'Juan Perez',
      productos: ['Gasolina 3 galones'],
      total: 171.30,
      estado: 'Lista',
    ),
  ];

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

  void _avanzarEstado(Orden orden) {
    setState(() {
      if (orden.estado == 'Pendiente') {
        orden.marcarEnPreparacion();
      } else if (orden.estado == 'En preparacion') {
        orden.marcarComoLista();
      }
    });
  }

  List<Orden> get _ordenesOrdenadas {
    final prioridad = {'Pendiente': 0, 'En preparacion': 1, 'Lista': 2};

    final copia = List<Orden>.from(_ordenes);
    copia.sort((a, b) {
      return (prioridad[a.estado] ?? 3).compareTo(prioridad[b.estado] ?? 3);
    });
    return copia;
  }

  @override
  Widget build(BuildContext context) {
    final ordenesParaMostrar = _ordenesOrdenadas;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Ordenes activas'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: ordenesParaMostrar.length,
        itemBuilder: (context, index) {
          final orden = ordenesParaMostrar[index];

          return Card(
            color: _colorPorEstado(orden.estado),
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              title: Text(
                'Orden #${orden.numeroOrden} - ${orden.cliente}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Estado: ${orden.estado}\nTotal: L. ${orden.total.toStringAsFixed(2)}',
              ),
              isThreeLine: true,
              trailing: orden.estado != 'Lista'
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => _avanzarEstado(orden),
                      child: const Text('Avanzar'),
                    )
                  : const Icon(Icons.check_circle, color: Colors.green),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetalleOrdenScreen(orden: orden),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
