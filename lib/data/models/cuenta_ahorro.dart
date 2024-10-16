// lib/data/models/cuenta_ahorro.dart
class CuentaAhorro {
  final int id;
  final double saldo;

  CuentaAhorro({required this.id, required this.saldo});

  factory CuentaAhorro.fromJson(Map<String, dynamic> json) {
    return CuentaAhorro(
      id: json['id'],
      saldo: json['saldo'].toDouble(),
    );
  }
}
