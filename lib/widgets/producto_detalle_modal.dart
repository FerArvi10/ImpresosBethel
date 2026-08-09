import 'package:flutter/material.dart';
import '../models/producto.dart';

class ProductoDetalleModal extends StatelessWidget {
  final Producto producto;
  final VoidCallback? onAgregar;

  const ProductoDetalleModal({
    super.key,
    required this.producto,
    this.onAgregar,
  });

  static void mostrar(BuildContext context, Producto producto, {VoidCallback? onAgregar}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProductoDetalleModal(
        producto: producto,
        onAgregar: onAgregar,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Indicador superior para deslizar
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Encabezado con Icono y Categoría
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    producto.icono,
                    size: 38,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          producto.categoria,
                          style: const TextStyle(
                            color: Colors.deepOrange,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        producto.nombre,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Tarjetas de Métricas (Precio, Preparación, Calorías)
            Row(
              children: [
                Expanded(
                  child: _buildMetricaCard(
                    context,
                    icon: Icons.payments_outlined,
                    label: 'Precio',
                    valor: 'L. ${producto.precio.toStringAsFixed(2)}',
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildMetricaCard(
                    context,
                    icon: Icons.timer_outlined,
                    label: 'Tiempo',
                    valor: producto.tiempoPreparacion,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildMetricaCard(
                    context,
                    icon: Icons.local_fire_department_outlined,
                    label: 'Calorías',
                    valor: '${producto.calorias} kcal',
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Descripción Analizada
            const Text(
              'Descripción del producto',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              producto.descripcion,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade800,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 20),

            // Lista de Ingredientes
            const Text(
              'Ingredientes / Contenido',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: producto.ingredientes.map((ingrediente) {
                return Chip(
                  avatar: const Icon(
                    Icons.check_circle_outline,
                    size: 16,
                    color: Colors.orange,
                  ),
                  label: Text(ingrediente),
                  backgroundColor: const Color(0xFFF6F6F6),
                  side: BorderSide(color: Colors.grey.shade300),
                  labelStyle: const TextStyle(fontSize: 13, color: Colors.black87),
                );
              }).toList(),
            ),

            const SizedBox(height: 28),

            // Botón de Acción
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
                onPressed: () {
                  Navigator.pop(context);
                  if (onAgregar != null) {
                    onAgregar!();
                  }
                },
                icon: Icon(onAgregar != null ? Icons.add_shopping_cart : Icons.check),
                label: Text(
                  onAgregar != null ? 'Seleccionar producto' : 'Cerrar detalle',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricaCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String valor,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 2),
          Text(
            valor,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
