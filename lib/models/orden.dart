class Orden {
  final int numeroOrden;
  final String cliente;
  final List<String> productos;
  final double total;
  String estado;

  Orden({
    required this.numeroOrden,
    required this.cliente,
    required this.productos,
    required this.total,
    this.estado = 'Pendiente',
  });

  void marcarEnPreparacion() {
    estado = 'En preparacion';
  }

  void marcarComoLista() {
    estado = 'Lista';
  }

  int cantidadProductos() {
    return productos.length;
  }

  String listaProductosTexto() {
    return productos.join(', ');
  }
}
