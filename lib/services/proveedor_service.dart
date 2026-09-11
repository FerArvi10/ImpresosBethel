import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/categoria.dart';
import '../models/proveedor.dart';


class ProveedorService {
 
  static Future<List<Proveedor>> obtenerProveedores({
    bool usarMockSiFalla = true,
  }) async {
    try {
      final url = Uri.parse(ApiConfig.proveedores);
      debugPrint('[ProveedorService] Solicitando GET $url');

      final response = await http
          .get(url, headers: ApiConfig.headersJson)
          .timeout(ApiConfig.timeout);

      debugPrint(
        '[ProveedorService] Respuesta: ${response.statusCode} (${response.body.length} bytes)',
      );

      if (response.statusCode == 200) {
        final dynamic decoded = jsonDecode(response.body);

        List<dynamic> listaJson;
        if (decoded is List) {
          listaJson = decoded;
        } else if (decoded is Map<String, dynamic> && decoded['data'] is List) {
          listaJson = decoded['data'];
        } else if (decoded is Map<String, dynamic> &&
            decoded['proveedores'] is List) {
          listaJson = decoded['proveedores'];
        } else {
          listaJson = [];
        }

        return listaJson.map((item) => Proveedor.fromJson(item)).toList();
      } else {
        throw Exception(
          'Error del servidor (${response.statusCode}): ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      debugPrint('[ProveedorService] Error al conectar con la API: $e');

      if (usarMockSiFalla) {
        debugPrint(
          '[ProveedorService] Usando catálogo demo de respaldo por falla de conexión.',
        );
        return _proveedoresDemo;
      }
      rethrow;
    }
  }

  /// Obtiene el detalle de un proveedor por su ID (GET /api/proveedores/:id).
  static Future<Proveedor?> obtenerProveedorPorId(int id) async {
    try {
      final url = Uri.parse(ApiConfig.proveedorDetalle(id));
      final response = await http
          .get(url, headers: ApiConfig.headersJson)
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        final dynamic decoded = jsonDecode(response.body);
        final Map<String, dynamic> data =
            (decoded is Map<String, dynamic> && decoded['data'] != null)
                ? decoded['data']
                : decoded;
        return Proveedor.fromJson(data);
      }
      return null;
    } catch (e) {
      debugPrint('[ProveedorService] Error al obtener proveedor #$id: $e');
      // Buscar en los de prueba si falla
      try {
        return _proveedoresDemo.firstWhere((p) => p.id == id);
      } catch (_) {
        return null;
      }
    }
  }

  /// Proveedores de respaldo realistas en caso de que el backend local no esté encendido.
  static final List<Proveedor> _proveedoresDemo = [
    Proveedor(
      id: 1,
      nombreNegocio: 'Textiles & Bordados Cortés',
      descripcion:
          'Especialistas en bordados computarizados de alta densidad, gorras, camisas tipo polo y uniformes industriales.',
      telefono: '+504 9876-5432',
      ciudad: 'San Pedro Sula',
      departamento: 'Cortés',
      precioDesde: 180.0,
      calificacion: 4.8,
      totalResenas: 34,
      verificado: true,
      destacado: true,
      disponible: true,
      categoriaId: 1,
      categoria: const Categoria(
        id: '1',
        nombre: 'Bordados',
        icono: Icons.auto_awesome,
      ),
    ),
    Proveedor(
      id: 2,
      nombreNegocio: 'Imprenta y Serigrafía La Central',
      descripcion:
          'Talonarios fiscales autorizados por el SAR, facturación continua, stickers troquelados y empaques.',
      telefono: '+504 9555-1234',
      ciudad: 'Tegucigalpa',
      departamento: 'Francisco Morazán',
      precioDesde: 120.0,
      calificacion: 4.9,
      totalResenas: 58,
      verificado: true,
      destacado: true,
      disponible: true,
      categoriaId: 2,
      categoria: const Categoria(
        id: '2',
        nombre: 'Talonarios',
        icono: Icons.receipt_long,
      ),
    ),
    Proveedor(
      id: 3,
      nombreNegocio: 'Papelería & Suministros Bethel',
      descripcion:
          'Materiales escolares y de oficina, papel bond membretado, sellos automáticos y tintas de serigrafía.',
      telefono: '+504 8888-9900',
      ciudad: 'La Ceiba',
      departamento: 'Atlántida',
      precioDesde: 45.0,
      calificacion: 4.6,
      totalResenas: 19,
      verificado: true,
      destacado: false,
      disponible: true,
      categoriaId: 3,
      categoria: const Categoria(
        id: '3',
        nombre: 'Sellos',
        icono: Icons.approval,
      ),
    ),
  ];
}
