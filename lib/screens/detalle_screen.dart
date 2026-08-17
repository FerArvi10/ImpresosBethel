import 'package:flutter/material.dart';
import '../models/producto.dart';
import '../models/carrito_item.dart';

/// Pantalla de detalle de producto de Impresos Bethel.
/// Recibe argumentos mediante [ModalRoute.of(context)!.settings.arguments].
class DetalleScreen extends StatefulWidget {
  final Producto? producto;

  const DetalleScreen({super.key, this.producto});

  @override
  State<DetalleScreen> createState() => _DetalleScreenState();
}

class _DetalleScreenState extends State<DetalleScreen> {
  int _cantidad = 1;
  final TextEditingController _notasController = TextEditingController();

  @override
  void dispose() {
    _notasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 5.1 Recibir argumentos de navegación por ruta con nombre
    final producto = widget.producto ??
        (ModalRoute.of(context)?.settings.arguments as Producto?) ??
        catalogoDemo.first;

    final theme = Theme.of(context);
    final totalCalculado = producto.precio * _cantidad;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F9),
      appBar: AppBar(
        title: Text(producto.nombre),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            tooltip: 'Ir al Carrito',
            onPressed: () => Navigator.pushNamed(context, '/carrito'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabecera con imagen/icono decorativa destacada
            Center(
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.teal.shade200,
                      Colors.teal.shade50,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal.withAlpha((0.2 * 255).round()),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Icon(
                  producto.icono,
                  size: 68,
                  color: Colors.teal.shade800,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Categoría y Badge de Personalización
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  avatar: const Icon(Icons.category_outlined, size: 16, color: Colors.teal),
                  label: Text(producto.categoria),
                  backgroundColor: Colors.teal.shade50,
                  side: BorderSide(color: Colors.teal.shade200),
                ),
                if (producto.esPersonalizable)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.orange.shade400),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.brush, size: 14, color: Colors.orange),
                        SizedBox(width: 4),
                        Text(
                          'Personalizable',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Nombre y Precio
            Text(
              producto.nombre,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'L ${producto.precio.toStringAsFixed(2)} c/u',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),

            // Tarjeta de información adicional (Entrega + Stock)
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.timer_outlined, size: 20, color: Colors.teal),
                        const SizedBox(width: 6),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Entrega estimada',
                                style: TextStyle(fontSize: 11, color: Colors.grey)),
                            Text(producto.tiempoEntrega,
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    Container(height: 28, width: 1, color: Colors.grey.shade300),
                    Row(
                      children: [
                        const Icon(Icons.inventory_2_outlined, size: 20, color: Colors.teal),
                        const SizedBox(width: 6),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Disponibilidad',
                                style: TextStyle(fontSize: 11, color: Colors.grey)),
                            Text('${producto.stockDisponible} unidades',
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Descripción detallada
            const Text(
              'Descripción del Producto',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              producto.descripcion,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade800, height: 1.45),
            ),
            const SizedBox(height: 20),

            // Selector de Cantidad
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Cantidad:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: _cantidad > 1
                            ? () => setState(() => _cantidad--)
                            : null,
                      ),
                      Text(
                        '$_cantidad',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => setState(() => _cantidad++),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Campo de especificaciones o personalización
            if (producto.esPersonalizable) ...[
              TextField(
                controller: _notasController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Notas de Personalización',
                  hintText: 'Ej. Nombre o logo a imprimir, tallas o numeración...',
                  prefixIcon: Icon(Icons.edit_note),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
            ],

            const SizedBox(height: 10),

            // Botón de acción principal
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.add_shopping_cart),
                label: Text(
                  'Agregar al Pedido (L ${totalCalculado.toStringAsFixed(2)})',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  // Agregar item al carrito demo
                  carritoDemo.add(
                    CarritoItem(
                      producto: producto,
                      cantidad: _cantidad,
                      notasPersonalizacion: _notasController.text.trim(),
                    ),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('¡${producto.nombre} agregado al pedido!'),
                      behavior: SnackBarBehavior.floating,
                      action: SnackBarAction(
                        label: 'VER CARRITO',
                        textColor: Colors.amber,
                        onPressed: () => Navigator.pushNamed(context, '/carrito'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
