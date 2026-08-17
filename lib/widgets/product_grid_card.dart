import 'package:flutter/material.dart';
import '../models/producto.dart';

/// Tarjeta de producto optimizada para GridView.builder (Layout obligatorio 2).
class ProductGridCard extends StatelessWidget {
  final Producto producto;
  final bool esFavorito;
  final VoidCallback onTap;
  final VoidCallback? onFavorite;

  const ProductGridCard({
    super.key,
    required this.producto,
    required this.onTap,
    this.esFavorito = false,
    this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.teal.withAlpha((0.15 * 255).round()),
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabecera de la tarjeta: Icono centrado + botón de favorito
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Center(
                    child: Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.teal.shade100,
                            Colors.teal.shade50,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        producto.icono,
                        size: 34,
                        color: Colors.teal.shade800,
                      ),
                    ),
                  ),
                  if (onFavorite != null)
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: onFavorite,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Icon(
                          esFavorito ? Icons.favorite : Icons.favorite_border,
                          size: 20,
                          color: esFavorito ? Colors.red : Colors.grey.shade500,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),

              // Chip de categoría pequeño
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  producto.categoria,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 6),

              // Nombre del producto
              Text(
                producto.nombre,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),

              // Precio y Badge de Personalizable
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'L ${producto.precio.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  if (producto.esPersonalizable)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.orange.shade300),
                      ),
                      child: const Icon(
                        Icons.brush,
                        size: 12,
                        color: Colors.orange,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
