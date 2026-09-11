import 'categoria.dart';

// Perfil de negocio de un proveedor, tal como lo devuelve GET /proveedores.
// Los campos "precioDesde" y "calificacion" son DECIMAL en la base de
// datos (MySQL) y Sequelize los serializa como String (ej. "350.00"),
// no como número -- por eso el parseo es tolerante a String o num.
class Proveedor {
  final int id;
  final String nombreNegocio;
  final String? descripcion;
  final String? telefono;
  final String? ciudad;
  final String? departamento;
  final double? precioDesde;
  final double calificacion;
  final int totalResenas;
  final bool verificado;
  final bool destacado;
  final bool disponible;
  final String? fotoUrl;
  final int categoriaId;
  final Categoria? categoria;

  Proveedor({
    required this.id,
    required this.nombreNegocio,
    this.descripcion,
    this.telefono,
    this.ciudad,
    this.departamento,
    this.precioDesde,
    required this.calificacion,
    required this.totalResenas,
    required this.verificado,
    required this.destacado,
    required this.disponible,
    this.fotoUrl,
    required this.categoriaId,
    this.categoria,
  });

  factory Proveedor.fromJson(Map<String, dynamic> json) {
    return Proveedor(
      id: json["id"],
      nombreNegocio: json["nombreNegocio"] ?? "",
      descripcion: json["descripcion"],
      telefono: json["telefono"],
      ciudad: json["ciudad"],
      departamento: json["departamento"],
      precioDesde: _parseDouble(json["precioDesde"]),
      calificacion: _parseDouble(json["calificacion"]) ?? 0,
      totalResenas: json["totalResenas"] ?? 0,
      verificado: json["verificado"] ?? false,
      destacado: json["destacado"] ?? false,
      disponible: json["disponible"] ?? true,
      fotoUrl: json["fotoUrl"],
      categoriaId: json["categoriaId"],
      categoria: json["Categoria"] != null
          ? Categoria.fromJson(json["Categoria"])
          : null,
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  // "Desde L. 350" o "Consultar" si el proveedor no publicó precio.
  String get precioDesdeTexto {
    if (precioDesde == null) return "Consultar";
    final esEntero = precioDesde == precioDesde!.roundToDouble();
    final monto = esEntero
        ? precioDesde!.toStringAsFixed(0)
        : precioDesde!.toStringAsFixed(2);
    return "Desde L. $monto";
  }
}
