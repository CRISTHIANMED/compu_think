class GeoreferenceEntity {
  final int id;
  final int idRetoPregunta;
  final double latitud;
  final double longitud;

  GeoreferenceEntity({
    required this.id,
    required this.idRetoPregunta,
    required this.latitud,
    required this.longitud,
  });

  // Metodo para convertir un mapa (de la base de datos) a una entidad Unidad
  factory GeoreferenceEntity.fromMap(Map<String, dynamic> map) {
    return GeoreferenceEntity(
      id: map['id'],
      idRetoPregunta: map['id_reto_pregunta'],
      latitud: map['latitud'],
      longitud: map['longitud'],
    );
  }
}
