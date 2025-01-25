class UnitEntity {
  final int id;
  final String nombre;
  final String descripcion;
  final int orden;
  final String? urlImagen;

  UnitEntity({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.orden,
    this.urlImagen,
  });

  // Factory para convertir un mapa (de la base de datos) a una entidad Unidad
  factory UnitEntity.fromMap(Map<String, dynamic> map) {
    return UnitEntity(
      id: map['id'] as int,
      nombre: map['nombre'] as String,
      descripcion: map['descripcion'] as String,
      orden: map['orden'] as int,
      urlImagen: map['url_imagen'],
    );
  }

  // Método para convertir una entidad Unidad a un mapa (para la base de datos)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'orden': orden,
      'url_imagen': urlImagen,
    };
  }
}
