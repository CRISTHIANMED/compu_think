class UserChallengeEntity {
  final int id;
  final int idReto;
  final int idPersona;
  final int idTipoEstado;
  final DateTime? fechaFin;

  UserChallengeEntity({
    required this.id,
    required this.idReto,
    required this.idPersona,
    required this.idTipoEstado,
    this.fechaFin,
  });

  // Factory para convertir un mapa (de la base de datos) a una entidad Unidad
  factory UserChallengeEntity.fromMap(Map<String, dynamic> map) {
    return UserChallengeEntity(
      id: map['id'] as int,
      idReto: map['id_reto'] as int,
      idPersona: map['id_persona'] as int,
      idTipoEstado: map['id_tipo_estado'] as int,
      fechaFin: map['fecha_fin'] != null
          ? DateTime.parse(map['fecha_fin'] as String)
          : null,
    );
  }

  // Método para convertir una entidad Unidad a un mapa (para la base de datos)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_reto': idReto,
      'id_persona': idPersona,
      'id_tipo_estado': idTipoEstado,
      'fecha_fin': fechaFin?.toIso8601String(),
    };
  }
}
