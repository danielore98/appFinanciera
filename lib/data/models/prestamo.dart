class Prestamo {
  final int id;
  final double montoPrestamo;
  final double saldoPendiente;
  final DateTime fechaAprobacion;

  // Constructor del modelo Prestamo
  Prestamo({
    required this.id,
    required this.montoPrestamo,
    required this.saldoPendiente,
    required this.fechaAprobacion,
  });

  // Constructor para crear una instancia de Prestamo desde un JSON
  factory Prestamo.fromJson(Map<String, dynamic> json) {
    return Prestamo(
      id: json['id'] ?? 0, // Si no existe el ID, asigna 0 como valor predeterminado
      montoPrestamo: (json['monto_prestamo'] ?? 0.0).toDouble(), // Convertir el monto a double
      saldoPendiente: (json['saldo_pendiente'] ?? 0.0).toDouble(), // Convertir el saldo pendiente a double
      fechaAprobacion: DateTime.parse(json['fecha_aprobacion']), // Convertir fecha a DateTime
    );
  }

  // Método para convertir una instancia de Prestamo a un JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'monto_prestamo': montoPrestamo,
      'saldo_pendiente': saldoPendiente,
      'fecha_aprobacion': fechaAprobacion.toIso8601String(), // Convertir DateTime a string en formato ISO
    };
  }
}
