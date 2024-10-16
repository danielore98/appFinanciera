import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/cuenta_ahorro.dart'; // Ajusta la ruta según sea necesario

class ApiService {
  final String baseUrl =
      "http://172.16.212.24:3000"; // Cambia según la IP de tu servidor

  // Limpiar el token JWT de SharedPreferences (para logout)
  //Future<void> clearToken() async {
  //SharedPreferences prefs = await SharedPreferences.getInstance();
  //await prefs.remove('jwt_token');
  //}

  // Registrar cliente (POST /clientes/register)
  Future<void> registrarCliente(
      String nombre, String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/clientes/register"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "nombre": nombre,
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception("Error al registrar el cliente");
    }
  }

  // Guardar el token JWT en SharedPreferences
  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
    print(
        "Token guardado en SharedPreferences: $token"); // Asegúrate de que el token se guarda

    // Agregar un print para verificar que el token se ha guardado
    print(
        "Token guardado en SharedPreferences: ${prefs.getString('jwt_token')}");
  }

  // Login cliente (POST /clientes/login)
  Future<void> loginCliente(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/clientes/login"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      String token = jsonResponse['token'];

      print(
          "Token guardado después del login: $token"); // Imprime el token para verificar
      // Guardar el token
      await saveToken(token);
    } else {
      throw Exception("Error al iniciar sesión");
    }
  }

  // Método para obtener el token JWT de SharedPreferences
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');
    print(
        "Token recuperado de SharedPreferences: $token"); // Imprimir para verificar el token
    return token;
    //return prefs.getString('jwt_token');
  }

  // Registrar una nueva cuenta de ahorro (POST /ahorros)
  Future<void> registrarCuentaAhorro(double saldoInicial) async {
    try {
      // Obtener el token almacenado
      final token = await getToken();
      if (token == null) {
        throw Exception("Token no disponible. No se ha iniciado sesión.");
      }

      // Realizar la solicitud POST para registrar la cuenta de ahorro
      final response = await http.post(
        Uri.parse("$baseUrl/ahorros"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // Autorización con JWT
        },
        body: jsonEncode({"saldo_inicial": saldoInicial}),
      );

      // Verificar si la solicitud fue exitosa
      if (response.statusCode == 201) {
        print("Cuenta de ahorro registrada exitosamente.");
      } else if (response.statusCode == 400) {
        throw Exception("Datos no válidos para la cuenta de ahorro.");
      } else if (response.statusCode == 401) {
        throw Exception("No autorizado. Verifique si su sesión ha expirado.");
      } else {
        throw Exception(
            "Error al registrar la cuenta de ahorro: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error al registrar la cuenta de ahorro: $e");
      throw Exception("Error de conexión: $e");
    }
  }

  // Método para obtener las cuentas de ahorro del cliente autenticado (GET /ahorros)
  Future<List<CuentaAhorro>> obtenerCuentasAhorro() async {
    final token = await getToken();

    if (token == null) {
      throw Exception("Token no disponible. No se ha iniciado sesión.");
    }

    print("Token usado en la solicitud para obtener cuentas de ahorro: $token");

    final response = await http.get(
      Uri.parse("$baseUrl/ahorros"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", // Enviar el token en la cabecera
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => CuentaAhorro.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      throw Exception("No autorizado. Verifique si su sesión ha expirado.");
    } else {
      throw Exception(
          "Error al obtener las cuentas de ahorro: ${response.body}");
    }
  }

  // Realizar una transferencia entre cuentas de ahorro (POST /ahorros/transferencia)
  Future<void> realizarTransferencia(
      int cuentaOrigen, int cuentaDestino, double monto) async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception("Token no disponible. No se ha iniciado sesión.");
      }

      final response = await http.post(
        Uri.parse("$baseUrl/ahorros/transferencia"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // Autorización con JWT
        },
        body: jsonEncode({
          "cuentaOrigen": cuentaOrigen,
          "cuentaDestino": cuentaDestino,
          "monto": monto,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception("Error al realizar la transferencia");
      }
    } catch (e) {
      throw Exception("Error de conexión: $e");
    }
  }

  // Solicitar un préstamo (POST /prestamos)
  Future<void> solicitarPrestamo(double monto) async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception("Token no disponible. No se ha iniciado sesión.");
      }

      final response = await http.post(
        Uri.parse("$baseUrl/prestamos"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // Autorización con JWT
        },
        body: jsonEncode({"monto": monto}),
      );

      if (response.statusCode != 201) {
        throw Exception("Error al solicitar el préstamo");
      }
    } catch (e) {
      throw Exception("Error de conexión: $e");
    }
  }

  // Obtener las cuentas de préstamo del cliente (GET /prestamos)
  Future<List<dynamic>> obtenerCuentasPrestamo() async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception("Token no disponible. No se ha iniciado sesión.");
      }

      final response = await http.get(
        Uri.parse("$baseUrl/prestamos"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // Autorización con JWT
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Error al obtener las cuentas de préstamo");
      }
    } catch (e) {
      throw Exception("Error de conexión: $e");
    }
  }

  // Realizar el pago de un préstamo (POST /prestamos/pago)
  Future<void> pagarPrestamo(int cuentaPrestamoId, double montoPago) async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception("Token no disponible. No se ha iniciado sesión.");
      }

      final response = await http.post(
        Uri.parse("$baseUrl/prestamos/pago"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // Autorización con JWT
        },
        body: jsonEncode({
          "cuentaPrestamoId": cuentaPrestamoId,
          "montoPago": montoPago,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception("Error al realizar el pago del préstamo");
      }
    } catch (e) {
      throw Exception("Error de conexión: $e");
    }
  }
}
