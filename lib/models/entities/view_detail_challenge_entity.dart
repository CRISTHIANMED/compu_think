class ViewDetailChallengeEntity {
  final int idRetoPersona;
  final int idPersona;
  final int idReto;
  final int idUnidad;
  final int idTipoReto;
  final String? urlReto;
  final String retoVigente;
  final int idTipoEstado;
  final String estadoDescripcion;
  final DateTime? fechaFin;
  final double calificacion;
  final String tipoRetoDescripcion;
  final String tipoRetoNombre;
  final String tipoRetoSubtitulo;

  ViewDetailChallengeEntity({
    required this.idRetoPersona,
    required this.idPersona,
    required this.idReto,
    required this.idUnidad,
    required this.idTipoReto,
    this.urlReto,
    required this.retoVigente,
    required this.idTipoEstado,
    required this.estadoDescripcion,
    this.fechaFin,
    required this.calificacion,
    required this.tipoRetoDescripcion,
    required this.tipoRetoNombre,
    required this.tipoRetoSubtitulo
  });

  factory ViewDetailChallengeEntity.fromMap(Map<String, dynamic> map) {
    return ViewDetailChallengeEntity(
      idRetoPersona: map['id_reto_persona'],
      idPersona: map['id_persona'],
      idReto: map['id_reto'],
      idUnidad: map['id_unidad'],
      idTipoReto: map['id_tipo_reto'],
      urlReto: map['url_reto'],
      retoVigente: map['reto_vigente'],
      idTipoEstado: map['id_tipo_estado'],
      estadoDescripcion: map['estado_descripcion'],
      fechaFin: map['fecha_fin'] != null ? DateTime.parse(map['fecha_fin']) : null,
      calificacion: map['calificacion'].toDouble(),
      tipoRetoDescripcion: map['tipo_reto_descripcion'] ?? '',
      tipoRetoNombre: map['tipo_reto_nombre'] ?? '',
      tipoRetoSubtitulo: map['tipo_reto_subtitulo'] ?? '',
    );
  }
}
