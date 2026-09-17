import 'producto.dart';


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
  String get personalizacion => notasPersonalizacion;
}

final List<CarritoItem> carritoDemo = [
  CarritoItem(
    producto: catalogoDemo[0], 
    cantidad: 2,
    notasPersonalizacion:
        'Numeración 001 a 100, membretado a nombre de Inversiones Beta',
  ),
  CarritoItem(
    producto: catalogoDemo[1], 
    cantidad: 4,
    notasPersonalizacion:
        '2 Tallas M y 2 Tallas L, color Azul Marino con logo blanco',
  ),
  CarritoItem(
    producto: catalogoDemo[5], 
    cantidad: 1,
    notasPersonalizacion: 'Acabado brillante, corte silueta circular 5cm',
  ),
];
