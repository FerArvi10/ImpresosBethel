import 'package:flutter/material.dart';
import 'listado_screen.dart';
import 'nueva_orden_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('OrderTracker'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.local_gas_station,
              size: 100,
              color: Colors.orange,
            ),
            const SizedBox(height: 16),
            const Text(
              'OrderTracker',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sistema de ordenes para gasolinera',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 50),

            SizedBox(
              width: 250,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ListadoScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.list_alt),
                label: const Text('Ver ordenes'),
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: 250,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.orange,
                  side: const BorderSide(color: Colors.orange),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NuevaOrdenScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Nueva orden'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
