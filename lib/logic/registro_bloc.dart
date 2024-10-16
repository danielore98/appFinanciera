import 'package:flutter/material.dart';
import '../data/models/cliente.dart';
import '../data/repositories/cliente_repository.dart';

class RegistroBloc with ChangeNotifier {
  final ClienteRepository _clienteRepository = ClienteRepository();
  Cliente? _cliente;
  String? _error;
  bool _isLoading = false;

  Cliente? get cliente => _cliente;
  String? get error => _error;
  bool get isLoading => _isLoading;

  // Método para registrar un nuevo cliente
  Future<void> registrarCliente(String nombre, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _cliente = await _clienteRepository.registrarCliente(nombre, email, password);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Método para limpiar los errores (en caso de usarse)
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
