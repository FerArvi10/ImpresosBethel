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
  final String tiempoEntrega;
  final int stockDisponible;

  const Producto({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.precio,
    required this.esPersonalizable,
    required this.descripcion,
    required this.icono,
    this.tiempoEntrega = '2 a 3 días hábiles',
    this.stockDisponible = 25,
  });
}

/// Catálogo demo realista de Impresos Bethel: imprenta, serigrafía, bordados y librería.
final List<Producto> catalogoDemo = [
  const Producto(
    id: 1,
    nombre: 'Talonario de Facturas',
    categoria: 'Talonarios',
    precio: 120.00,
    esPersonalizable: true,
    descripcion:
        'Talonario membretado con numeración consecutiva, original y copia autocopiativa. Autorizado según normas fiscales del SAR con logo personalizado.',
    icono: Icons.receipt_long,
    tiempoEntrega: '2 días hábiles',
    stockDisponible: 50,
  ),
  const Producto(
    id: 2,
    nombre: 'Camiseta Polo Bordada',
    categoria: 'Camisetas',
    precio: 220.00,
    esPersonalizable: true,
    descripcion:
        'Camiseta tipo polo de piqué 100% algodón, bordado de alta precisión en pecho izquierdo y manga. Ideal para uniformes empresariales.',
    icono: Icons.checkroom,
    tiempoEntrega: '3 a 4 días hábiles',
    stockDisponible: 30,
  ),
  const Producto(
    id: 3,
    nombre: 'Camiseta Serigrafiada',
    categoria: 'Camisetas',
    precio: 160.00,
    esPersonalizable: true,
    descripcion:
        'Camiseta de algodón suave cuello redondo con estampado serigráfico a full color de alta durabilidad y resistencia al lavado.',
    icono: Icons.dry_cleaning,
    tiempoEntrega: '2 días hábiles',
    stockDisponible: 45,
  ),
  const Producto(
    id: 4,
    nombre: 'Estampado en Vinil Textil',
    categoria: 'Estampados',
    precio: 95.00,
    esPersonalizable: true,
    descripcion:
        'Estampado de diseño tipográfico o vectorial en vinil textil termotransferible con acabado mate o metalizado para prendas oscuras o claras.',
    icono: Icons.brush,
    tiempoEntrega: '24 horas',
    stockDisponible: 60,
  ),
  const Producto(
    id: 5,
    nombre: 'Gorra Bordada Personalizada',
    categoria: 'Bordados',
    precio: 140.00,
    esPersonalizable: true,
    descripcion:
        'Gorra de 6 paneles estilo camionero o cerrada, con bordado 3D o plano en el frontal. Broche ajustable metálico o de velcro.',
    icono: Icons.auto_awesome,
    tiempoEntrega: '3 días hábiles',
    stockDisponible: 35,
  ),
  const Producto(
    id: 6,
    nombre: 'Stickers Troquelados (Pack 50)',
    categoria: 'Stickers',
    precio: 85.00,
    esPersonalizable: true,
    descripcion:
        'Pack de 50 stickers en vinil adhesivo con acabado brillante o mate, resistentes al agua y al sol, cortados con la silueta de tu logotipo.',
    icono: Icons.local_offer,
    tiempoEntrega: '24 a 48 horas',
    stockDisponible: 100,
  ),
  const Producto(
    id: 7,
    nombre: 'Sello Automático Autoentintable',
    categoria: 'Sellos',
    precio: 195.00,
    esPersonalizable: true,
    descripcion:
        'Sello automático de bolsillo o escritorio marca Trodat con almohadilla de tinta azul o negra recargable. Grabado láser de alta nitidez.',
    icono: Icons.approval,
    tiempoEntrega: '24 horas',
    stockDisponible: 20,
  ),
  const Producto(
    id: 8,
    nombre: 'Cuaderno Universitario Espiral',
    categoria: 'Útiles escolares',
    precio: 48.00,
    esPersonalizable: false,
    descripcion:
        'Cuaderno de 100 hojas cuadrícula 5mm, pasta semirrígida plastificada y doble anillo metálico. Ideal para estudiantes y oficina.',
    icono: Icons.menu_book,
    tiempoEntrega: 'Inmediata',
    stockDisponible: 80,
  ),
  const Producto(
    id: 9,
    nombre: 'Set de Lapiceros Gel (Pack 6)',
    categoria: 'Útiles escolares',
    precio: 35.00,
    esPersonalizable: false,
    descripcion:
        'Set de 6 bolígrafos de gel 0.7mm de tinta fluida y secado rápido en tonos negro, azul y rojo con grip ergonómico.',
    icono: Icons.edit,
    tiempoEntrega: 'Inmediata',
    stockDisponible: 65,
  ),
  const Producto(
    id: 10,
    nombre: 'Taza de Cerámica Sublimada',
    categoria: 'Estampados',
    precio: 110.00,
    esPersonalizable: true,
    descripcion:
        'Taza blanca de 11 oz de cerámica de alta calidad con impresión por sublimación panorámica a full color, apta para microondas.',
    icono: Icons.coffee,
    tiempoEntrega: '24 a 48 horas',
    stockDisponible: 40,
  ),
  const Producto(
    id: 11,
    nombre: 'Pendón Publicitario Roll-Up',
    categoria: 'Talonarios',
    precio: 650.00,
    esPersonalizable: true,
    descripcion:
        'Banner publicitario retráctil de 85x200 cm impreso en lona frontlit de alta resolución con estructura de aluminio y bolso de transporte.',
    icono: Icons.view_carousel,
    tiempoEntrega: '2 a 3 días hábiles',
    stockDisponible: 15,
  ),
];
