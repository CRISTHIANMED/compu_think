class ViewDetailUnitEntity {
  final int idPersonaUnidad;
  final int idPersona;
  final int idUnidad;
  final int idTipoEstado;
  final DateTime fechaInicio;
  final String unidadNombre;
  final String unidadDescripcion;
  final int unidadOrden;
  final String unidadVigente;
  final String unidadUrlImagen;
  final String tipoEstadoDescripcion;

  ViewDetailUnitEntity({
    required this.idPersonaUnidad,
    required this.idPersona,
    required this.idUnidad,
    required this.idTipoEstado,
    required this.fechaInicio,
    required this.unidadNombre,
    required this.unidadDescripcion,
    required this.unidadOrden,
    required this.unidadVigente,
    required this.unidadUrlImagen,
    required this.tipoEstadoDescripcion,
  });

  // Método para convertir una entidad Unidad a un mapa (para la base de datos)
  Map<String, dynamic> toMap() {
    return {
      'id_persona_unidad': idPersonaUnidad,
      'id_persona': idPersona,
      'id_unidad': idUnidad,
      'id_tipo_estado': idTipoEstado,
      'fecha_inicio': fechaInicio.toIso8601String(),
      'unidad_nombre': unidadNombre,
      'unidad_descripcion': unidadDescripcion,
      'unidad_orden': unidadOrden,
      'unidad_vigente': unidadVigente,
      'unidad_url_imagen': unidadUrlImagen,
      'tipo_estado_descripcion': tipoEstadoDescripcion,
    };
  }

  // Metodo para convertir un mapa (de la base de datos) a una entidad Unidad
  factory ViewDetailUnitEntity.fromMap(Map<String, dynamic> map) {
    return ViewDetailUnitEntity(
      idPersonaUnidad: map['id_persona_unidad'],
      idPersona: map['id_persona'],
      idUnidad: map['id_unidad'],
      idTipoEstado: map['id_tipo_estado'],
      fechaInicio: DateTime.parse(map['fecha_inicio']),
      unidadNombre: map['unidad_nombre'],
      unidadDescripcion: map['unidad_descripcion'],
      unidadOrden: map['unidad_orden'],
      unidadVigente: map['unidad_vigente'],
      unidadUrlImagen: map['unidad_url_imagen'],
      tipoEstadoDescripcion: map['tipo_estado_descripcion'],
    );
  }
}
