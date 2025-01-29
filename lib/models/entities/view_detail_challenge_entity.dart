class ViewDetailChallengeEntity {
  final int idRetoPersona;
  final int idPersona;
  final int idReto;
  final int idUnidad;
  final int idTipoReto;
  final String nombreReto;
  final String? urlReto;
  final String retoVigente;
  final int idTipoEstado;
  final String estadoDescripcion;
  final DateTime? fechaFin;
  final double calificacion;
  final String tipoRetoDescripcion;

  ViewDetailChallengeEntity({
    required this.idRetoPersona,
    required this.idPersona,
    required this.idReto,
    required this.idUnidad,
    required this.idTipoReto,
    required this.nombreReto,
    this.urlReto,
    required this.retoVigente,
    required this.idTipoEstado,
    required this.estadoDescripcion,
    this.fechaFin,
    required this.calificacion,
    required this.tipoRetoDescripcion
  });

  factory ViewDetailChallengeEntity.fromMap(Map<String, dynamic> map) {
    return ViewDetailChallengeEntity(
      idRetoPersona: map['id_reto_persona'],
      idPersona: map['id_persona'],
      idReto: map['id_reto'],
      idUnidad: map['id_unidad'],
      idTipoReto: map['id_tipo_reto'],
      nombreReto: map['nombre_reto'],
      urlReto: map['url_reto'],
      retoVigente: map['reto_vigente'],
      idTipoEstado: map['id_tipo_estado'],
      estadoDescripcion: map['estado_descripcion'],
      fechaFin: map['fecha_fin'] != null ? DateTime.parse(map['fecha_fin']) : null,
      calificacion: map['calificacion'].toDouble(),
      tipoRetoDescripcion: map['tipo_reto_descripcion'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_reto_persona': idRetoPersona,
      'id_persona': idPersona,
      'id_reto': idReto,
      'id_unidad': idUnidad,
      'id_tipo_reto': idTipoReto,
      'nombre_reto': nombreReto,
      'url_reto': urlReto,
      'reto_vigente': retoVigente,
      'id_tipo_estado': idTipoEstado,
      'estado_descripcion': estadoDescripcion,
      'fecha_fin': fechaFin,
      'calificacion': calificacion,
      'tipo_reto_descripcion': tipoRetoDescripcion
    };
  }
}
