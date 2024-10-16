import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/prestamo.dart';

class PrestamoRepository {
  final String apiUrl =
      "http://172.16.212.24:3000/prestamos"; // Cambia la URL según la dirección de tu backend

  // Método para obtener las cuentas de préstamo de un cliente
  Future<List<Prestamo>> obtenerCuentasPrestamo(String token) async {
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer $token", // Se pasa el token JWT en la cabecera
        },
      );

      if (response.statusCode == 200) {
        // Convierte el JSON en una lista de objetos Prestamo
        List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Prestamo.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('No autorizado, token inválido');
      } else {
        throw Exception(
            'Error al obtener las cuentas de préstamo: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error de conexión: ${e.toString()}');
    }
  }

  // Método para solicitar un nuevo préstamo
  Future<Prestamo> solicitarPrestamo(double monto, String token) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer $token", // Se pasa el token JWT en la cabecera
        },
        body: jsonEncode({
          "monto": monto,
        }),
      );

      if (response.statusCode == 201) {
        // Si la solicitud es exitosa, convierte el JSON en un objeto Prestamo
        return Prestamo.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 400) {
        throw Exception('Datos inválidos para la solicitud de préstamo');
      } else {
        throw Exception(
            'Error al solicitar el préstamo: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error de conexión: ${e.toString()}');
    }
  }

  // Método para realizar el pago de un préstamo
  Future<void> pagarPrestamo(
      int cuentaPrestamoId, double montoPago, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/pago'),
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer $token", // Se pasa el token JWT en la cabecera
        },
        body: jsonEncode({
          "cuentaPrestamoId": cuentaPrestamoId,
          "montoPago": montoPago,
        }),
      );

      if (response.statusCode == 200) {
        print('Pago realizado con éxito');
      } else if (response.statusCode == 400) {
        throw Exception('Datos inválidos para el pago de préstamo');
      } else if (response.statusCode == 401) {
        throw Exception('No autorizado, token inválido');
      } else {
        throw Exception('Error al realizar el pago: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error de conexión: ${e.toString()}');
    }
  }
}
