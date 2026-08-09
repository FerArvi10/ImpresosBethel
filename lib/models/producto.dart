import 'package:flutter/material.dart';

class Producto {
  final String id;
  final String nombre;
  final String descripcion;
  final double precio;
  final String categoria;
  final List<String> ingredientes;
  final int calorias;
  final String tiempoPreparacion;
  final IconData icono;
  final bool disponible;

  const Producto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.categoria,
    required this.ingredientes,
    required this.calorias,
    required this.tiempoPreparacion,
    required this.icono,
    this.disponible = true,
  });
}
