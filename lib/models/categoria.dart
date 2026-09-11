import 'package:flutter/material.dart';

/// Modelo de categoría para clasificar productos en Impresos Bethel.
class Categoria {
  final String id;
  final String nombre;
  final IconData icono;

  const Categoria({
    required this.id,
    required this.nombre,
    required this.icono,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      icono: _obtenerIcono(json['nombre']?.toString() ?? ''),
    );
  }

  static IconData _obtenerIcono(String nombre) {
    final lower = nombre.toLowerCase();
    if (lower.contains('talonario')) return Icons.receipt_long;
    if (lower.contains('camiseta')) return Icons.checkroom;
    if (lower.contains('estampado')) return Icons.brush;
    if (lower.contains('bordado')) return Icons.auto_awesome;
    if (lower.contains('sticker')) return Icons.local_offer;
    if (lower.contains('sello')) return Icons.approval;
    if (lower.contains('útil') || lower.contains('util') || lower.contains('escolar')) return Icons.menu_book;
    return Icons.category;
  }
}

/// Lista de categorías disponibles en el catálogo.
const List<Categoria> categoriasDisponibles = [
  Categoria(id: 'todas', nombre: 'Todas', icono: Icons.grid_view),
  Categoria(id: 'Talonarios', nombre: 'Talonarios', icono: Icons.receipt_long),
  Categoria(id: 'Camisetas', nombre: 'Camisetas', icono: Icons.checkroom),
  Categoria(id: 'Estampados', nombre: 'Estampados', icono: Icons.brush),
  Categoria(id: 'Bordados', nombre: 'Bordados', icono: Icons.auto_awesome),
  Categoria(id: 'Stickers', nombre: 'Stickers', icono: Icons.local_offer),
  Categoria(id: 'Sellos', nombre: 'Sellos', icono: Icons.approval),
  Categoria(id: 'Útiles escolares', nombre: 'Útiles', icono: Icons.menu_book),
];
