import 'package:flutter/material.dart';

class AcercaDeScreen extends StatelessWidget {
  const AcercaDeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Acerca de'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.local_gas_station, size: 60, color: Colors.orange),
            const SizedBox(height: 16),
            const Text(
              'OrderTracker',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              'App para agilizar el manejo de órdenes de comida en '
              'Texaco Satuye, conectando a la cajera con la cocina en '
              'tiempo real.',
            ),
            const SizedBox(height: 24),
            const Text(
              'Equipo (Grupo 7)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.person_outline),
              title: Text('Sol España'),
            ),
            const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.person_outline),
              title: Text('Fernando Arvizu'),
            ),
          ],
        ),
      ),
    );
  }
}
