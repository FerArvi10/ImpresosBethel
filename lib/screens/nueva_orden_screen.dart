import 'package:flutter/material.dart';

class NuevaOrdenScreen extends StatefulWidget {
  const NuevaOrdenScreen({super.key});

  @override
  State<NuevaOrdenScreen> createState() => _NuevaOrdenScreenState();
}

class _NuevaOrdenScreenState extends State<NuevaOrdenScreen> {
  final Map<String, double> _productosDisponibles = {
    'Baleada con huevo': 20.10,
    'Arroz con pollo': 50.00,
    'Agua embotellada': 20.00,
    'Cafe': 35.00,
    'Snack': 25.00,
    'Pastelitos de pollo': 10.00,
    'Pollo chuco': 100.00,
    'Coca Cola Personal': 25.00,
  };

  final Map<String, bool> _seleccionados = {};

  final TextEditingController _clienteController = TextEditingController();

  @override
  void initState() {
    super.initState();

    for (var producto in _productosDisponibles.keys) {
      _seleccionados[producto] = false;
    }
  }

  void _toggleProducto(String producto, bool? valor) {
    setState(() {
      _seleccionados[producto] = valor ?? false;
    });
  }

  double _calcularTotal() {
    double total = 0;
    _seleccionados.forEach((producto, seleccionado) {
      if (seleccionado) {
        total += _productosDisponibles[producto]!;
      }
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Nueva orden'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _clienteController,
              decoration: InputDecoration(
                labelText: 'Nombre del cliente',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Selecciona los productos',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: _productosDisponibles.keys.map((producto) {
                final precio = _productosDisponibles[producto]!;
                return Card(
                  child: CheckboxListTile(
                    activeColor: Colors.orange,
                    title: Text(producto),
                    subtitle: Text('L. ${precio.toStringAsFixed(2)}'),
                    value: _seleccionados[producto],
                    onChanged: (valor) => _toggleProducto(producto, valor),
                  ),
                );
              }).toList(),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total:', style: TextStyle(fontSize: 18)),
                    Text(
                      'L. ${_calcularTotal().toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Orden enviada a cocina')),
                      );
                      Navigator.pop(context);
                    },
                    child: const Text('Enviar orden a cocina'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
