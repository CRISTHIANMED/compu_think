class ResponseEntity {
  //final int id;
  final int idPersona;
  final int idRetoPregunta;
  final int idRetoPreguntaOpcion;
  final DateTime? fecha;

  ResponseEntity({
    //required this.id,
    required this.idPersona,
    required this.idRetoPregunta,
    required this.idRetoPreguntaOpcion,
    this.fecha,
  });

  // Factory para convertir un Map en una instancia de la entidad
  factory ResponseEntity.fromMap(Map<String, dynamic> map) {
    return ResponseEntity(
      //id: map['id'] as int,
      idPersona: map['id_persona'] as int,
      idRetoPregunta: map['id_reto_pregunta'] as int,
      idRetoPreguntaOpcion: map['id_reto_pregunta_opcion'] as int,
      fecha: map['fecha'] != null ? DateTime.parse(map['fecha']) : null,
    );
  }

  // Método para convertir una entidad Unidad a un mapa (para la base de datos)
  Map<String, dynamic> toMap() {
    return {
      //'id': id,
      'id_persona': idPersona,
      'id_reto_pregunta': idRetoPregunta,
      'id_reto_pregunta_opcion': idRetoPreguntaOpcion,
      'fecha': fecha?.toIso8601String(),
    };
  }
}
