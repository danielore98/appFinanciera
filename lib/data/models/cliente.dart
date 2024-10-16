class Cliente {
  final int id;
  final String nombre;
  final String email;

  // Constructor del modelo Cliente
  Cliente({
    required this.id,
    required this.nombre,
    required this.email,
  });

  // Constructor para crear una instancia de Cliente desde un JSON
  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'] ?? 0,  // Si no existe el ID, asigna 0 como valor predeterminado
      nombre: json['nombre'] ?? 'Sin nombre',  // Si el nombre no está presente, asigna 'Sin nombre'
      email: json['email'] ?? 'Sin email',  // Si el email no está presente, asigna 'Sin email'
    );
  }

  // Método para convertir una instancia de Cliente a un JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'email': email,
    };
  }
}
