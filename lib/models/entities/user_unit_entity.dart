class UserUnitEntity {
  //final int id;
  final int idPersona;
  final int idUnidad;
  final int idTipoEstado;
  final DateTime? fechaInicio;

  UserUnitEntity({
    //required this.id,
    required this.idPersona,
    required this.idUnidad,
    required this.idTipoEstado,
    this.fechaInicio,
  });

  // Método para crear una instancia a partir de un map
  factory UserUnitEntity.fromMap(Map<String, dynamic> map) {
    return UserUnitEntity(
      //id: map['id'],
      idPersona: map['id_persona'],
      idUnidad: map['id_unidad'],
      idTipoEstado: map['id_tipo_estado'],
      fechaInicio: map['fecha_inicio'] != null ? DateTime.parse(map['fecha_inicio']) : null,
    );
  }

  // Método para convertir la instancia a un Map
  Map<String, dynamic> toMap() {
    return {
      //'id': id,
      'id_persona': idPersona,
      'id_unidad': idUnidad,
      'id_tipo_estado': idTipoEstado,
      'fecha_inicio': fechaInicio,
    };
  }
}
