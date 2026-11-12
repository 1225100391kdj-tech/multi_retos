
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServicio {
  static Future<Map<String, dynamic>> obtenerDatos(
    Uri url, {
    Map<String, String>? headers,
  }) async {
    final respuesta = await http.get(
      url,
      headers: headers,
    ).timeout(const Duration(seconds: 15));

    if (respuesta.statusCode != 200) {
      throw Exception(
        'Error de conexión: ${respuesta.statusCode}',
      );
    }

    final datos = jsonDecode(respuesta.body);

    if (datos is! Map<String, dynamic>) {
      throw Exception('Respuesta JSON no válida');
    }

    return datos;
  }
}
