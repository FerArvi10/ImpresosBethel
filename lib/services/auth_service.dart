import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';


class AuthResult {
  final bool success;
  final String message;
  final String? token;
  final Map<String, dynamic>? usuario;
  final bool bloqueado;
  final int? intentosRestantes;

  const AuthResult({
    required this.success,
    required this.message,
    this.token,
    this.usuario,
    this.bloqueado = false,
    this.intentosRestantes,
  });
}

class AuthService {
  
  static Future<AuthResult> register({
    required String nombre,
    required String apellido,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse(ApiConfig.authRegister);

    final payload = jsonEncode({
      'nombre': nombre.trim(),
      'apellido': apellido.trim(),
      'email': email.trim().toLowerCase(),
      'password': password,
      'rol': 'cliente',
    });

    try {
      final response = await http
          .post(
            url,
            headers: ApiConfig.headersJson,
            body: payload,
          )
          .timeout(ApiConfig.timeout);

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return AuthResult(
          success: true,
          message: data['message'] ?? 'Usuario registrado exitosamente',
          token: data['token'] as String?,
          usuario: data['usuario'] as Map<String, dynamic>?,
        );
      } else if (response.statusCode == 400) {
        return AuthResult(
          success: false,
          message: data['message'] ?? 'Error de validación o correo duplicado',
        );
      } else {
        return AuthResult(
          success: false,
          message: data['message'] ?? 'Error del servidor (${response.statusCode})',
        );
      }
    } on SocketException {
      return const AuthResult(
        success: false,
        message: 'No se pudo conectar con el backend. Verifica que el servidor esté activo.',
      );
    } on TimeoutException {
      return const AuthResult(
        success: false,
        message: 'Tiempo de espera agotado al conectar con el backend.',
      );
    } on FormatException {
      return const AuthResult(
        success: false,
        message: 'Respuesta inválida del servidor.',
      );
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'Error inesperado: ${e.toString()}',
      );
    }
  }

  /// Inicia sesión con correo y contraseña.
  /// POST /api/auth/login
  static Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse(ApiConfig.authLogin);

    final payload = jsonEncode({
      'email': email.trim().toLowerCase(),
      'password': password,
    });

    try {
      final response = await http
          .post(
            url,
            headers: ApiConfig.headersJson,
            body: payload,
          )
          .timeout(ApiConfig.timeout);

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return AuthResult(
          success: true,
          message: data['message'] ?? 'Sesión iniciada con éxito',
          token: data['token'] as String?,
          usuario: data['usuario'] as Map<String, dynamic>?,
          bloqueado: false,
        );
      } else {
        return AuthResult(
          success: false,
          message: data['message'] ?? 'Credenciales inválidas',
          bloqueado: data['bloqueado'] == true,
          intentosRestantes: data['intentosRestantes'] as int?,
        );
      }
    } on SocketException {
      return const AuthResult(
        success: false,
        message: 'No se pudo conectar con el servidor.',
      );
    } on TimeoutException {
      return const AuthResult(
        success: false,
        message: 'Tiempo de espera agotado al conectar con el servidor.',
      );
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'Error al iniciar sesión: ${e.toString()}',
      );
    }
  }
}
