class UserEntity {
  final int id;
  final String email;
  final String nombre1;
  final String? nombre2;
  final String? apellido1;
  final String? apellido2;
  final String contrasena;
  final String? nombreU;
  

  UserEntity( {
    required this.id,
    required this.email,
    required this.nombreU,
    required this.contrasena,
    required this.nombre1,
    required this.nombre2,
    required this.apellido1,
    required this.apellido2,
  });


  // Constructor para un usuario por defecto
  factory UserEntity.defaultUser() {
    return UserEntity(
      id: 0,
      email: "usuario@default.com",
      nombreU: "Usuario",
      contrasena: "default",
      nombre1: "Usuario",
      nombre2: null,
      apellido1: "Predeterminado",
      apellido2: null,
    );
  }

  factory UserEntity.fromMap(Map<String, dynamic> map) {
    return UserEntity(
      id: map['id'],
      email: map['email'],
      nombre1: map['nombre_1'] ,
      nombre2: map['nombre_2'] ?? '',
      apellido1: map['apellido_1'] ?? '',
      apellido2: map['apellido_2'] ?? '',
      contrasena: map['contrasena'] ,
      nombreU: map['name_user'] ?? '',
    );
  }

  // Método para convertir una entidad Unidad a un mapa (para la base de datos)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'nombre_1': nombre1,
      'nombre_2': nombre2,
      'apellido_1': apellido1,
      'apellido_2': apellido2,
      'contrasena': contrasena,
      'name_user': nombreU,
    };
  }
}
