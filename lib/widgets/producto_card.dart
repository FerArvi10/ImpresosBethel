import 'package:flutter/material.dart';
import '../models/producto.dart';

/// Widget personalizado reutilizable que muestra la tarjeta de un producto.
/// Recibe datos por parámetro y callbacks para manejar interacciones.
class ProductoCard extends StatelessWidget {
  final Producto producto;
  final VoidCallback onTap;
  final VoidCallback? onFavorite;
  final bool isFavorite;
  final VoidCallback? onAgregar;
  final bool isSeleccionado;

  const ProductoCard({
    super.key,
    required this.producto,
    required this.onTap,
    this.onFavorite,
    this.isFavorite = false,
    this.onAgregar,
    this.isSeleccionado = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: isSeleccionado
              ? const BorderSide(color: Colors.orange, width: 2)
              : BorderSide.none,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icono contenedor con color de fondo
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isSeleccionado
                      ? Colors.orange.shade100
                      : Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  producto.icono,
                  size: 30,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 14),

              // Información principal del producto
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            producto.nombre,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          'L. ${producto.precio.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      producto.descripcion,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            producto.categoria,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.timer_outlined,
                            size: 14, color: Colors.grey.shade600),
                        const SizedBox(width: 2),
                        Text(
                          producto.tiempoPreparacion,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // IconButton de favorito (si se proporciona callback)
              if (onFavorite != null)
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                  ),
                  tooltip: isFavorite
                      ? 'Quitar de favoritos'
                      : 'Agregar a favoritos',
                  onPressed: onFavorite,
                ),

              // Botón o Checkbox de agregar/seleccionar (si se proporciona callback)
              if (onAgregar != null)
                IconButton(
                  icon: Icon(
                    isSeleccionado
                        ? Icons.check_circle
                        : Icons.add_circle_outline,
                    color: isSeleccionado ? Colors.orange : Colors.grey,
                  ),
                  tooltip: isSeleccionado ? 'Quitar de la orden' : 'Agregar a la orden',
                  onPressed: onAgregar,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
