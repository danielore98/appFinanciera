import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cliente.dart';

class ClienteRepository {
  final String apiUrl =
      "http://172.16.212.24:3000/clientes"; // Cambia la URL según tu backend

  // Método para registrar un nuevo cliente
  Future<Cliente> registrarCliente(
      String nombre, String email, String password) async {
    final url = Uri.parse("$apiUrl/register");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "nombre": nombre,
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 201) {
        return Cliente.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 400) {
        throw Exception("Error: Datos inválidos o cliente ya registrado.");
      } else {
        throw Exception("Error al registrar cliente: ${response.reasonPhrase}");
      }
    } catch (e) {
      throw Exception("Error de conexión: $e");
    }
  }

  // Método para hacer login de un cliente
  Future<Cliente> loginCliente(String email, String password) async {
    final url = Uri.parse("$apiUrl/login");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        return Cliente.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw Exception("Credenciales incorrectas.");
      } else {
        throw Exception("Error al iniciar sesión: ${response.reasonPhrase}");
      }
    } catch (e) {
      throw Exception("Error de conexión: $e");
    }
  }
}
