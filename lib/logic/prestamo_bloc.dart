import 'package:flutter/material.dart';
import '../data/models/prestamo.dart';
import '../data/repositories/prestamo_repository.dart';

class PrestamoBloc with ChangeNotifier {
  final PrestamoRepository _prestamoRepository = PrestamoRepository();
  
  List<Prestamo> _prestamos = [];
  String? _error;
  bool _isLoading = false;
  bool _isPagoExitoso = false;

  // Getters
  List<Prestamo> get prestamos => _prestamos;
  String? get error => _error;
  bool get isLoading => _isLoading;
  bool get isPagoExitoso => _isPagoExitoso;

  // Obtener las cuentas de préstamo del cliente
  Future<void> obtenerCuentasPrestamo(String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _prestamos = await _prestamoRepository.obtenerCuentasPrestamo(token);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Solicitar un nuevo préstamo
  Future<void> solicitarPrestamo(double monto, String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      Prestamo nuevoPrestamo = await _prestamoRepository.solicitarPrestamo(monto, token);
      _prestamos.add(nuevoPrestamo);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Realizar el pago de un préstamo
  Future<void> pagarPrestamo(int cuentaPrestamoId, double montoPago, String token) async {
    _isLoading = true;
    _error = null;
    _isPagoExitoso = false;
    notifyListeners();

    try {
      await _prestamoRepository.pagarPrestamo(cuentaPrestamoId, montoPago, token);
      _isPagoExitoso = true;  // Indica que el pago fue exitoso
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Limpiar el estado de error y éxito
  void limpiarEstado() {
    _error = null;
    _isPagoExitoso = false;
    notifyListeners();
  }
}
