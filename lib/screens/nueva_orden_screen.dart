import 'package:flutter/material.dart';
import '../data/productos_data.dart';
import '../widgets/producto_card.dart';
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

  void _toggleProducto(String productoId, bool valor) {
    setState(() {
      _seleccionados[productoId] = valor;
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

  int get _cantidadProductosSeleccionados {
    return _seleccionados.values.where((v) => v).length;
  }

  void _enviarOrden() {
    final cliente = _clienteController.text.trim();
    if (cliente.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor ingresa el nombre del cliente'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_cantidadProductosSeleccionados == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona al menos un producto'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Orden para "$cliente" enviada a cocina'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'DESHACER',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Envío de orden cancelado'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Nueva Orden'),
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
                prefixIcon:
                    const Icon(Icons.person_outline, color: Colors.orange),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Selecciona los productos',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  'Seleccionados: $_cantidadProductosSeleccionados',
                  style: const TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: ProductosData.listaProductos.length,
              itemBuilder: (context, index) {
                final producto = ProductosData.listaProductos[index];
                final esSeleccionado = _seleccionados[producto.id] ?? false;

                return ProductoCard(
                  producto: producto,
                  isSeleccionado: esSeleccionado,
                  onTap: () {
                    ProductoDetalleModal.mostrar(
                      context,
                      producto,
                      onAgregar: () {
                        _toggleProducto(producto.id, !esSeleccionado);
                      },
                    );
                  },
                  onAgregar: () {
                    _toggleProducto(producto.id, !esSeleccionado);
                  },
                );
              },
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
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _enviarOrden,
                    icon: const Icon(Icons.send),
                    label: const Text(
                      'Enviar orden a cocina',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
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
