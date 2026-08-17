import 'producto.dart';

/// Elemento dentro del carrito de compras de Impresos Bethel.
class CarritoItem {
  final Producto producto;
  int cantidad;
  String notasPersonalizacion;

  CarritoItem({
    required this.producto,
    this.cantidad = 1,
    this.notasPersonalizacion = '',
  });

  double get subtotal => producto.precio * cantidad;
}

/// Carrito demo precargado con items para visualización inmediata.
final List<CarritoItem> carritoDemo = [
  CarritoItem(
    producto: catalogoDemo[0], // Talonario de Facturas
    cantidad: 2,
    notasPersonalizacion: 'Numeración 001 a 100, membretado a nombre de Inversiones Beta',
  ),
  CarritoItem(
    producto: catalogoDemo[1], // Camiseta Polo Bordada
    cantidad: 4,
    notasPersonalizacion: '2 Tallas M y 2 Tallas L, color Azul Marino con logo blanco',
  ),
  CarritoItem(
    producto: catalogoDemo[5], // Stickers Troquelados
    cantidad: 1,
    notasPersonalizacion: 'Acabado brillante, corte silueta circular 5cm',
  ),
];
