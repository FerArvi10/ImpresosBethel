import 'package:flutter/material.dart';

/// Modelo de producto para Impresos Bethel.
class Producto {
  final int id;
  final String nombre;
  final String categoria;
  final double precio;
  final bool esPersonalizable;
  final String descripcion;
  final IconData icono;

  const Producto({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.precio,
    required this.esPersonalizable,
    required this.descripcion,
    required this.icono,
  });
}

/// Catálogo demo de Impresos Bethel: imprenta + librería.
final List<Producto> catalogoDemo = [
  const Producto(
    id: 1,
    nombre: 'Talonario de facturas',
    categoria: 'Talonarios',
    precio: 120.00,
    esPersonalizable: true,
    descripcion:
        'Talonario personalizado con el logo y datos de tu negocio. '
        'Disponible en original y copia.',
    icono: Icons.receipt_long,
  ),
  const Producto(
    id: 2,
    nombre: 'Camiseta estampada',
    categoria: 'Camisetas',
    precio: 180.00,
    esPersonalizable: true,
    descripcion:
        'Camiseta 100% algodón con estampado a full color, tallas S a XL.',
    icono: Icons.checkroom,
  ),
  const Producto(
    id: 3,
    nombre: 'Estampado personalizado',
    categoria: 'Estampados',
    precio: 90.00,
    esPersonalizable: true,
    descripcion: 'Estampado de diseño propio para prendas o gorras.',
    icono: Icons.brush,
  ),
  const Producto(
    id: 4,
    nombre: 'Bordado en hilo',
    categoria: 'Bordados',
    precio: 150.00,
    esPersonalizable: true,
    descripcion: 'Bordado a máquina con logo o nombre en la prenda que elijas.',
    icono: Icons.auto_awesome,
  ),
  const Producto(
    id: 5,
    nombre: 'Sticker troquelado',
    categoria: 'Stickers',
    precio: 15.00,
    esPersonalizable: true,
    descripcion: 'Sticker resistente al agua, corte a la medida de tu diseño.',
    icono: Icons.local_offer,
  ),
  const Producto(
    id: 6,
    nombre: 'Cuaderno universitario',
    categoria: 'Útiles escolares',
    precio: 45.00,
    esPersonalizable: false,
    descripcion: '100 hojas, cuadro grande, disponible en varios colores.',
    icono: Icons.menu_book,
  ),
  const Producto(
    id: 7,
    nombre: 'Set de lapiceros',
    categoria: 'Útiles escolares',
    precio: 25.00,
    esPersonalizable: false,
    descripcion: 'Set de 5 lapiceros de tinta negra y azul.',
    icono: Icons.edit,
  ),
];
