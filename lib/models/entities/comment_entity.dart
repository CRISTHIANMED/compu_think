class CommentEntity {
  final int id;
  final int idPersona;
  final int idReto;
  String texto;
  DateTime fecha;

  CommentEntity({
    required this.id,
    required this.idPersona,
    required this.idReto,
    required this.texto,
    required this.fecha,
  });

  // Metodo para convertir un mapa (de la base de datos) a una entidad Unidad
  factory CommentEntity.fromMap(Map<String, dynamic> map) {
    return CommentEntity(
      id: map['id'] as int,
      idPersona: map['id_persona'] as int,
      idReto: map['id_reto'] as int,
      texto: map['texto'] as String,
      fecha: DateTime.parse(map['fecha'] as String),
    );
  }

  // Método para convertir una entidad Unidad a un mapa (para la base de datos)
  Map<String, dynamic> toMap() {
    return {
      'id_persona': idPersona,
      'id_reto': idReto,
      'texto': texto,
      'fecha': fecha.toIso8601String(),
    };
  }
}
