import 'package:flutter/material.dart';

/// Estados posibles de un pedido en Impresos Bethel.
enum EstadoPedido {
  pendiente,
  enProceso,
  listo,
  entregado,
  cancelado,
}

/// Modelo de pedido detallado para el historial de la aplicación.
class Pedido {
  final String codigo;
  final String cliente;
  final String fecha;
  final String tipoTrabajo;
  final String descripcion;
  final double total;
  final EstadoPedido estado;
  final int cantidad;
  final IconData icono;

  const Pedido({
    required this.codigo,
    required this.cliente,
    required this.fecha,
    required this.tipoTrabajo,
    required this.descripcion,
    required this.total,
    required this.estado,
    required this.cantidad,
    required this.icono,
  });

  String get estadoTexto {
    switch (estado) {
      case EstadoPedido.pendiente:
        return 'Pendiente';
      case EstadoPedido.enProceso:
        return 'En Proceso';
      case EstadoPedido.listo:
        return 'Listo para Entrega';
      case EstadoPedido.entregado:
        return 'Entregado';
      case EstadoPedido.cancelado:
        return 'Cancelado';
    }
  }

  Color get estadoColor {
    switch (estado) {
      case EstadoPedido.pendiente:
        return Colors.orange;
      case EstadoPedido.enProceso:
        return Colors.blue;
      case EstadoPedido.listo:
        return Colors.teal;
      case EstadoPedido.entregado:
        return Colors.green;
      case EstadoPedido.cancelado:
        return Colors.red;
    }
  }
}

/// Lista realista con 12 pedidos en historial para Impresos Bethel.
final List<Pedido> historialPedidosDemo = [
  const Pedido(
    codigo: 'BET-1048',
    cliente: 'Distribuidora San José',
    fecha: '16 Ago 2026',
    tipoTrabajo: 'Talonarios',
    descripcion: '5 Talonarios de facturas membretadas SAR con numeración 001-500',
    total: 600.00,
    estado: EstadoPedido.enProceso,
    cantidad: 5,
    icono: Icons.receipt_long,
  ),
  const Pedido(
    codigo: 'BET-1047',
    cliente: 'Farmacia El Ahorro',
    fecha: '15 Ago 2026',
    tipoTrabajo: 'Stickers',
    descripcion: '200 Stickers troquelados con laminado brillante para etiquetado',
    total: 340.00,
    estado: EstadoPedido.listo,
    cantidad: 200,
    icono: Icons.local_offer,
  ),
  const Pedido(
    codigo: 'BET-1046',
    cliente: 'Academia de Fútbol Los Leones',
    fecha: '14 Ago 2026',
    tipoTrabajo: 'Camisetas',
    descripcion: '18 Camisetas deportivas estampadas con nombre y dorsal',
    total: 2880.00,
    estado: EstadoPedido.enProceso,
    cantidad: 18,
    icono: Icons.checkroom,
  ),
  const Pedido(
    codigo: 'BET-1045',
    cliente: 'Bufete Jurídico Méndez',
    fecha: '13 Ago 2026',
    tipoTrabajo: 'Sellos',
    descripcion: '2 Sellos automáticos Trodat para firmas y visto bueno',
    total: 390.00,
    estado: EstadoPedido.entregado,
    cantidad: 2,
    icono: Icons.approval,
  ),
  const Pedido(
    codigo: 'BET-1044',
    cliente: 'Cafetería Aroma Real',
    fecha: '11 Ago 2026',
    tipoTrabajo: 'Estampados',
    descripcion: '24 Tazas de cerámica sublimadas con logo e ilustración vintage',
    total: 2640.00,
    estado: EstadoPedido.entregado,
    cantidad: 24,
    icono: Icons.coffee,
  ),
  const Pedido(
    codigo: 'BET-1043',
    cliente: 'Constructora del Valle',
    fecha: '09 Ago 2026',
    tipoTrabajo: 'Bordados',
    descripcion: '15 Gorras bordadas con logotipo 3D en hilo color oro',
    total: 2100.00,
    estado: EstadoPedido.entregado,
    cantidad: 15,
    icono: Icons.auto_awesome,
  ),
  const Pedido(
    codigo: 'BET-1042',
    cliente: 'Colegio Cristiano Betania',
    fecha: '07 Ago 2026',
    tipoTrabajo: 'Útiles escolares',
    descripcion: '50 Cuadernos universitarios personalizados con portada institucional',
    total: 2400.00,
    estado: EstadoPedido.entregado,
    cantidad: 50,
    icono: Icons.menu_book,
  ),
  const Pedido(
    codigo: 'BET-1041',
    cliente: 'Taller Mecánico Rápido',
    fecha: '04 Ago 2026',
    tipoTrabajo: 'Talonarios',
    descripcion: '3 Talonarios de orden de servicio en papel autocopiativo',
    total: 360.00,
    estado: EstadoPedido.entregado,
    cantidad: 3,
    icono: Icons.receipt_long,
  ),
  const Pedido(
    codigo: 'BET-1040',
    cliente: 'Restaurante Sabor Criollo',
    fecha: '01 Ago 2026',
    tipoTrabajo: 'Camisetas',
    descripcion: '10 Camisetas polo bordadas para personal de meseros',
    total: 2200.00,
    estado: EstadoPedido.entregado,
    cantidad: 10,
    icono: Icons.checkroom,
  ),
  const Pedido(
    codigo: 'BET-1039',
    cliente: 'Librería y Papelería Éxito',
    fecha: '28 Jul 2026',
    tipoTrabajo: 'Útiles escolares',
    descripcion: '30 Sets de lapiceros y marcadores para inventario',
    total: 1050.00,
    estado: EstadoPedido.entregado,
    cantidad: 30,
    icono: Icons.edit,
  ),
  const Pedido(
    codigo: 'BET-1038',
    cliente: 'Gimnasio FitZone',
    fecha: '25 Jul 2026',
    tipoTrabajo: 'Estampados',
    descripcion: '35 Camisetas de licra estampadas con vinil reflectivo',
    total: 3325.00,
    estado: EstadoPedido.entregado,
    cantidad: 35,
    icono: Icons.brush,
  ),
  const Pedido(
    codigo: 'BET-1037',
    cliente: 'Inmobiliaria Los Pinos',
    fecha: '20 Jul 2026',
    tipoTrabajo: 'Talonarios',
    descripcion: '2 Roll-Ups publicitarios de 85x200cm con estructura de aluminio',
    total: 1300.00,
    estado: EstadoPedido.entregado,
    cantidad: 2,
    icono: Icons.view_carousel,
  ),
];
