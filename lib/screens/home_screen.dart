import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'listado_screen.dart';
import 'nueva_orden_screen.dart';
import 'acerca_de_screen.dart';
import 'catalogo_productos_screen.dart';

class HomeScreen extends StatelessWidget {
  final UserRole role;
  final String nombreUsuario;

  const HomeScreen({
    super.key,
    required this.role,
    required this.nombreUsuario,
  });

  @override
  Widget build(BuildContext context) {
    final esCajera = role == UserRole.cajera;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('OrderTracker'),
        centerTitle: true,
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.orange),
              accountName: Text(nombreUsuario),
              accountEmail: Text(esCajera ? 'Cajera' : 'Cocinera'),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.orange),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Inicio'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.list_alt),
              title: const Text('Ordenes activas'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ListadoScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.restaurant_menu),
              title: const Text('Catálogo de productos'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CatalogoProductosScreen(),
                  ),
                );
              },
            ),
            // La opcion de crear orden solo la ve la cajera
            if (esCajera)
              ListTile(
                leading: const Icon(Icons.add_circle_outline),
                title: const Text('Nueva orden'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NuevaOrdenScreen(),
                    ),
                  );
                },
              ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Acerca de'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AcercaDeScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Cerrar sesion',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),

      body: Center(
        child: SingleChildScrollView(
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
              Text(
                'Bienvenido, $nombreUsuario',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 40),

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
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade800,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CatalogoProductosScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.restaurant_menu),
                  label: const Text('Catálogo de productos'),
                ),
              ),
              const SizedBox(height: 16),

              // Boton para crear una orden nueva (solo para la cajera)
              if (esCajera)
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
      ),
    );
  }
}
