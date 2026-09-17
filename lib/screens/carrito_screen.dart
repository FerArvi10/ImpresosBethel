import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/carrito_item.dart';
import '../models/pedido.dart';
import 'factura_screen.dart';

/// Pantalla de Carrito / Resumen de Pedido (Layout obligatorio 4: Column + Expanded + Footer fijo).
class CarritoScreen extends StatefulWidget {
  const CarritoScreen({super.key});

  @override
  State<CarritoScreen> createState() => _CarritoScreenState();
}

class _CarritoScreenState extends State<CarritoScreen> {
  final List<CarritoItem> _items = carritoDemo;
  bool _enviando = false;

  double get _subtotal {
    return _items.fold(0.0, (acc, item) => acc + item.subtotal);
  }

  double get _isv => _subtotal * 0.15;
  double get _total => _subtotal + _isv;

  Future<void> _procesarOrdenBackend() async {
    setState(() => _enviando = true);

    final itemsCopia = List<CarritoItem>.from(_items);
    final totalCalculado = _total;
    final int cantidadTotal = _items.fold(0, (acc, i) => acc + i.cantidad);
    final String descripcionTrabajos =
        _items.map((i) => '${i.cantidad}x ${i.producto.nombre}').join(', ');
    final String tipoTrabajo =
        _items.isNotEmpty ? _items.first.producto.categoria : 'Impresión';

    String codigoGenerado = 'BET-${1049 + historialPedidosDemo.length}';

    try {
      final response = await http
          .post(
            Uri.parse(ApiConfig.pedidos),
            headers: ApiConfig.headersJson,
            body: jsonEncode({
              'cliente': 'Cliente Impresos Bethel',
              'tipoTrabajo': tipoTrabajo,
              'descripcion': descripcionTrabajos,
              'total': totalCalculado,
              'cantidad': cantidadTotal,
              'estado': 'enProceso',
              'items': itemsCopia
                  .map((i) => {
                        'nombre': i.producto.nombre,
                        'cantidad': i.cantidad,
                        'precio': i.producto.precio,
                        'subtotal': i.subtotal,
                        'personalizacion': i.personalizacion,
                      })
                  .toList(),
            }),
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['data'] != null && data['data']['codigo'] != null) {
          codigoGenerado = data['data']['codigo'];
        }
      }
    } catch (_) {
      // Modo offline resiliente: se mantiene el código local
    }

    final nuevoPedido = Pedido(
      codigo: codigoGenerado,
      cliente: 'Cliente Impresos Bethel',
      fecha: 'Hoy',
      tipoTrabajo: tipoTrabajo,
      descripcion: descripcionTrabajos,
      total: totalCalculado,
      estado: EstadoPedido.enProceso,
      cantidad: cantidadTotal,
      icono: Icons.print,
    );

    historialPedidosDemo.insert(0, nuevoPedido);

    setState(() {
      _items.clear();
      _enviando = false;
    });

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (ctx) => FacturaScreen(
            pedido: nuevoPedido,
            items: itemsCopia,
          ),
        ),
      );
    }
  }

  void _confirmarPedido() {
    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tu carrito está vacío. Agrega productos del catálogo.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.teal),
            SizedBox(width: 8),
            Text('Confirmar Pedido'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('¿Deseas enviar este pedido a producción en Impresos Bethel?'),
            const SizedBox(height: 12),
            Text('• Artículos: ${_items.length}',
                style: const TextStyle(fontWeight: FontWeight.w600)),
            Text('• Total a pagar: L ${_total.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
            const SizedBox(height: 8),
            const Text(
              'Al confirmar, se guardará en la base de datos y se generará tu Factura Fiscal SAR.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.receipt_long, size: 18),
            label: const Text('Generar Factura'),
            onPressed: () {
              Navigator.pop(dialogCtx);
              _procesarOrdenBackend();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrito de Pedidos'),
        centerTitle: true,
        actions: [
          if (_items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              tooltip: 'Vaciar carrito',
              onPressed: () {
                setState(() => _items.clear());
              },
            ),
        ],
      ),
      // 5.2 Layout Obligatorio: Column con Expanded(ListView) + Container fijo abajo
      body: _items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 72, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'Tu carrito está vacío',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Explora nuestro catálogo para agregar productos',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.grid_view),
                    label: const Text('Ir al Catálogo'),
                    onPressed: () => Navigator.pushNamed(context, '/catalogo'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // 1. Área expandida y scrolleable para los items del carrito
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final item = _items[index];

                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Icono del producto
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.teal.shade50,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(item.producto.icono,
                                    color: Colors.teal, size: 28),
                              ),
                              const SizedBox(width: 12),

                              // Info del producto
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.producto.nombre,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'L ${item.producto.precio.toStringAsFixed(2)} c/u',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 12,
                                      ),
                                    ),
                                    if (item.notasPersonalizacion.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        'Nota: ${item.notasPersonalizacion}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.teal.shade800,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                    const SizedBox(height: 8),

                                    // Controles de cantidad
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              if (item.cantidad > 1) {
                                                item.cantidad--;
                                              } else {
                                                _items.removeAt(index);
                                              }
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: const Icon(Icons.remove, size: 16),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 12),
                                          child: Text(
                                            '${item.cantidad}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              item.cantidad++;
                                            });
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade200,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: const Icon(Icons.add, size: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Subtotal y botón eliminar
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                                    onPressed: () {
                                      setState(() {
                                        _items.removeAt(index);
                                      });
                                    },
                                  ),
                                  Text(
                                    'L ${item.subtotal.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Colors.teal,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // 2. Footer fijo inferior con resumen financiero y botón de confirmación
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color ?? Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha((0.15 * 255).round()),
                        blurRadius: 10,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Subtotal', style: TextStyle(color: Colors.grey)),
                            Text('L ${_subtotal.toStringAsFixed(2)}',
                                style: const TextStyle(fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('ISV (15%)', style: TextStyle(color: Colors.grey)),
                            Text('L ${_isv.toStringAsFixed(2)}',
                                style: const TextStyle(fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const Divider(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total a Pagar',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'L ${_total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: _enviando
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.receipt_long_outlined),
                            label: Text(
                              _enviando
                                  ? 'Procesando en Servidor...'
                                  : 'Confirmar y Facturar',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            onPressed: _enviando ? null : _confirmarPedido,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
