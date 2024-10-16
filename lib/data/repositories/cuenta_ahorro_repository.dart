import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cuenta_ahorro.dart';

class CuentaAhorroRepository {
  final String apiUrl =
      "http://172.16.212.24:3000/ahorros"; // Cambia la URL según sea necesario

  // Método para registrar una nueva cuenta de ahorro (POST /ahorros)
  Future<CuentaAhorro> registrarCuentaAhorro(
      double saldoInicial, String token) async {
    final url = Uri.parse(apiUrl);

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer $token", // Se envía el token JWT para autenticación
        },
        body: jsonEncode({
          "saldo_inicial":
              saldoInicial, // Envía el saldo inicial en el cuerpo de la solicitud
        }),
      );

      if (response.statusCode == 201) {
        // Procesar la respuesta si se creó exitosamente la cuenta
        return CuentaAhorro.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 400) {
        throw Exception(
            "Datos inválidos proporcionados para la cuenta de ahorro.");
      } else if (response.statusCode == 401) {
        throw Exception(
            "No autorizado. Verifica si el token es correcto o ha expirado.");
      } else {
        throw Exception(
            "Error al registrar la cuenta de ahorro: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error de conexión al registrar la cuenta de ahorro: $e");
    }
  }

  // Método para obtener las cuentas de ahorro del cliente autenticado (GET /ahorros)
  Future<List<CuentaAhorro>> obtenerCuentasAhorro(String token) async {
    final url = Uri.parse(apiUrl);

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // Se envía el token JWT
        },
      );

      if (response.statusCode == 200) {
        // Procesar la respuesta si se obtuvieron las cuentas exitosamente
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => CuentaAhorro.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw Exception(
            "No autorizado. Verifica si el token es correcto o ha expirado.");
      } else {
        throw Exception(
            "Error al obtener las cuentas de ahorro: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error de conexión al obtener las cuentas de ahorro: $e");
    }
  }
}
