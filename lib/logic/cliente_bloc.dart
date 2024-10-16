import 'package:flutter/material.dart';
import '../data/models/cliente.dart';
import '../data/repositories/cliente_repository.dart';

class ClienteBloc with ChangeNotifier {
  final ClienteRepository _clienteRepository = ClienteRepository();
  
  Cliente? _cliente;
  String? _error;
  bool _isLoading = false;
  bool _isLoggedIn = false;

  // Getters
  Cliente? get cliente => _cliente;
  String? get error => _error;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;

  // Login del cliente
  Future<void> loginCliente(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _cliente = await _clienteRepository.loginCliente(email, password);
      _isLoggedIn = true;
      _error = null;
    } catch (e) {
      _error = e.toString();
      _isLoggedIn = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Registrar un nuevo cliente
  Future<void> registrarCliente(String nombre, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _cliente = await _clienteRepository.registrarCliente(nombre, email, password);
      _isLoggedIn = true;
      _error = null;
    } catch (e) {
      _error = e.toString();
      _isLoggedIn = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Limpiar el estado (cuando el cliente se desloguea o se restablece el estado)
  void logoutCliente() {
    _cliente = null;
    _isLoggedIn = false;
    _error = null;
    notifyListeners();
  }

  // Limpiar el estado de error (útil para reiniciar el estado de error en la UI)
  void limpiarError() {
    _error = null;
    notifyListeners();
  }
}
