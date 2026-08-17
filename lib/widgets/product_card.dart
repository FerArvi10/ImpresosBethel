import 'package:flutter/material.dart';

/// Tarjeta de producto reutilizable para el catálogo de Impresos Bethel.
class ProductCard extends StatelessWidget {
  final String nombre;
  final String categoria;
  final double precio;
  final IconData icono;
  final bool esFavorito;
  final VoidCallback onTap;
  final VoidCallback? onFavorite;

  const ProductCard({
    super.key,
    required this.nombre,
    required this.categoria,
    required this.precio,
    required this.icono,
    required this.onTap,
    this.esFavorito = false,
    this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icono,
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nombre,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      categoria,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'L ${precio.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.teal),
                    ),
                  ],
                ),
              ),
              // Parte A: IconButton que alterna entre favorite_border y favorite
              if (onFavorite != null)
                IconButton(
                  icon: Icon(
                    esFavorito ? Icons.favorite : Icons.favorite_border,
                    color: esFavorito ? Colors.redAccent : Colors.grey,
                  ),
                  onPressed: onFavorite,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
