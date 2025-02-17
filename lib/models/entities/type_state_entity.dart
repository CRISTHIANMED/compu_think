class TypeStateEntity {
  final int id;
  final String descripcion;

  TypeStateEntity({
    required this.id,
    required this.descripcion,
  });

  // Método para convertir un Map (de la base de datos) a la entidad
  factory TypeStateEntity.fromMap(Map<String, dynamic> map) {
    return TypeStateEntity(
      id: map['id'] as int,
      descripcion: map['descripcion'] as String,
    );
  }

  // Método para convertir la entidad a un Map (para guardar en la base de datos)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'descripcion': descripcion,
    };
  }
}
