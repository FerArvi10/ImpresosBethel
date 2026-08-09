import 'package:flutter/material.dart';
import '../data/productos_data.dart';
import '../widgets/producto_detalle_modal.dart';

class NuevaOrdenScreen extends StatefulWidget {
  const NuevaOrdenScreen({super.key});

  @override
  State<NuevaOrdenScreen> createState() => _NuevaOrdenScreenState();
}

class _NuevaOrdenScreenState extends State<NuevaOrdenScreen> {
  final Map<String, bool> _seleccionados = {};
  final TextEditingController _clienteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    for (var producto in ProductosData.listaProductos) {
      _seleccionados[producto.id] = false;
    }
  }

  @override
  void dispose() {
    _clienteController.dispose();
    super.dispose();
  }

  void _toggleProducto(String productoId, bool? valor) {
    setState(() {
      _seleccionados[productoId] = valor ?? false;
    });
  }

  double _calcularTotal() {
    double total = 0;
    for (var producto in ProductosData.listaProductos) {
      if (_seleccionados[producto.id] == true) {
        total += producto.precio;
      }
    }
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
                prefixIcon: const Icon(Icons.person_outline, color: Colors.orange),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Selecciona los productos (toca (i) para ver detalles)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: ProductosData.listaProductos.map((producto) {
                final esSeleccionado = _seleccionados[producto.id] ?? false;
                return Card(
                  elevation: 1,
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.orange.shade50,
                      child: Icon(producto.icono, color: Colors.orange),
                    ),
                    title: Text(
                      producto.nombre,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'L. ${producto.precio.toStringAsFixed(2)} • ${producto.categoria}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.info_outline, color: Colors.orange),
                          tooltip: 'Ver detalle de ${producto.nombre}',
                          onPressed: () {
                            ProductoDetalleModal.mostrar(
                              context,
                              producto,
                              onAgregar: () {
                                _toggleProducto(producto.id, true);
                              },
                            );
                          },
                        ),
                        Checkbox(
                          activeColor: Colors.orange,
                          value: esSeleccionado,
                          onChanged: (valor) =>
                              _toggleProducto(producto.id, valor),
                        ),
                      ],
                    ),
                    onTap: () {
                      _toggleProducto(producto.id, !esSeleccionado);
                    },
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
                      final cliente = _clienteController.text.trim();
                      if (cliente.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Por favor ingresa el nombre del cliente'),
                          ),
                        );
                        return;
                      }
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
