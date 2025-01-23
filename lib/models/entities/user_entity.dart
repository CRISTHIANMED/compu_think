class UserEntity {
  final String id;
  final String email;
  final String nombre1;
  final String nombre2;
  final String apellido1;
  final String apellido2;
  final String rol;

  UserEntity({
    required this.id,
    required this.email,
    required this.nombre1,
    required this.nombre2,
    required this.apellido1,
    required this.apellido2,
    required this.rol,
  });

  // Método para crear una instancia a partir de un mapa
  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      id: map['id'],
      email: map['email'],
      nombre1: map['nombre1'],
      nombre2: map['nombre2'],
      apellido1: map['apellido1'],
      apellido2: map['apellido2'],
      rol: map['rol'],
    );
  }

  // Método para convertir la instancia en un mapa (útil para enviar a Supabase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'nombre1': nombre1,
      'nombre2': nombre2,
      'apellido1': apellido1,
      'apellido2': apellido2,
      'rol': rol,
    };
  }
}
