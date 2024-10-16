import 'package:flutter/material.dart';
import '../data/models/cuenta_ahorro.dart';
//import '../data/repositories/cuenta_ahorro_repository.dart';
import '../services/api_service.dart';

class CuentaAhorroBloc with ChangeNotifier {
   final ApiService _apiService = ApiService(); // Instancia de ApiService
 // final CuentaAhorroRepository _cuentaAhorroRepository = CuentaAhorroRepository();

  List<CuentaAhorro> _cuentasAhorro = [];
  bool _isLoading = false;
  String? _error;

  List<CuentaAhorro> get cuentasAhorro => _cuentasAhorro;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Método para obtener las cuentas de ahorro (GET /ahorros)
  //Future<void> obtenerCuentasAhorro(String token) async {
  Future<void> obtenerCuentasAhorro() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Llamada al repositorio para obtener las cuentas de ahorro
      //final cuentas = await _cuentaAhorroRepository.obtenerCuentasAhorro(token);
      final cuentas = await _apiService.obtenerCuentasAhorro();
      _cuentasAhorro = cuentas;  // Actualiza la lista de cuentas si la operación es exitosa
      _error = null;  // Limpia cualquier error previo si la operación es exitosa
    } catch (e) {
      _error = "Error al obtener las cuentas de ahorro: ${e.toString()}";  // Manejo de errores
    } finally {
      _isLoading = false;
      notifyListeners();  // Notifica a los listeners que se ha actualizado el estado
    }
  }

  // Método para registrar una nueva cuenta de ahorro (POST /ahorros)
  Future<void> registrarCuentaAhorro(double saldoInicial) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
       // Obtener el token almacenado
      final token = await _apiService.getToken();
      if (token == null) {
        throw Exception("No se ha iniciado sesión. Token no disponible.");
      }

      // Llamada al repositorio para registrar una nueva cuenta de ahorro
      //await _cuentaAhorroRepository.registrarCuentaAhorro(saldoInicial, token);
      await _apiService.registrarCuentaAhorro(saldoInicial);
      await obtenerCuentasAhorro();  // Actualiza la lista de cuentas de ahorro después de registrar una nueva
    } catch (e) {
      _error = "Error al registrar la cuenta de ahorro: ${e.toString()}";  // Manejo de errores
    } finally {
      _isLoading = false;
      notifyListeners();  // Notifica a los listeners que se ha actualizado el estado
    }
  }
}
