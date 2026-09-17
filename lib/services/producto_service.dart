import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/producto.dart';

/// Resultado de consulta con metadata para la UI
class ResultadoProductos {
  final bool exito;
  final List<Producto> productos;
  final String mensaje;
  final bool esOffline;

  const ResultadoProductos({
    required this.exito,
    this.productos = const [],
    this.mensaje = '',
    this.esOffline = false,
  });
}

/// Servicio encargado del consumo de la API REST para Productos (MySQL + Sequelize).
class ProductoService {
  /// Obtiene los productos desde el backend (GET /api/productos)
  static Future<ResultadoProductos> obtenerProductos({
    bool usarMockSiFalla = true,
  }) async {
    try {
      final url = Uri.parse(ApiConfig.productos);
      debugPrint('[ProductoService] Solicitando GET $url');

      final response = await http
          .get(url, headers: ApiConfig.headersJson)
          .timeout(ApiConfig.timeout);

      debugPrint('[ProductoService] Respuesta HTTP: ${response.statusCode}');

      if (response.statusCode == 200) {
        final dynamic decoded = jsonDecode(response.body);

        List<dynamic> listaRaw = [];
        if (decoded is Map<String, dynamic>) {
          if (decoded['data'] is List) {
            listaRaw = decoded['data'];
          } else if (decoded['productos'] is List) {
            listaRaw = decoded['productos'];
          }
        } else if (decoded is List) {
          listaRaw = decoded;
        }

        final productos = listaRaw
            .map((item) => Producto.fromJson(item as Map<String, dynamic>))
            .toList();

        return ResultadoProductos(
          exito: true,
          productos: productos,
          mensaje: 'Se cargaron ${productos.length} productos desde MySQL.',
          esOffline: false,
        );
      } else {
        throw Exception(
          'Error del servidor (${response.statusCode}): ${response.reasonPhrase}',
        );
      }
    } on SocketException catch (e) {
      debugPrint('[ProductoService] Error de conexión (SocketException): $e');
      if (usarMockSiFalla) {
        return ResultadoProductos(
          exito: true,
          productos: catalogoDemo,
          mensaje: 'Modo respaldo: Sin conexión con el servidor MySQL.',
          esOffline: true,
        );
      }
      return const ResultadoProductos(
        exito: false,
        mensaje: 'No se pudo conectar con el servidor. Revisa tu conexión a internet o el backend.',
      );
    } catch (e) {
      debugPrint('[ProductoService] Excepción al consultar productos: $e');
      if (usarMockSiFalla) {
        return ResultadoProductos(
          exito: true,
          productos: catalogoDemo,
          mensaje: 'Modo respaldo: Ocurrió un error en el servidor.',
          esOffline: true,
        );
      }
      return ResultadoProductos(
        exito: false,
        mensaje: 'Error al procesar los datos: $e',
      );
    }
  }

  /// Registra un nuevo producto en el backend (POST /api/productos)
  static Future<bool> crearProducto(Producto producto) async {
    try {
      final url = Uri.parse(ApiConfig.productos);
      debugPrint('[ProductoService] Enviando POST a $url');

      final response = await http
          .post(
            url,
            headers: ApiConfig.headersJson,
            body: jsonEncode(producto.toJson()),
          )
          .timeout(ApiConfig.timeout);

      debugPrint('[ProductoService] Respuesta creación: ${response.statusCode}');
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      debugPrint('[ProductoService] Error al crear producto: $e');
      return false;
    }
  }
}
