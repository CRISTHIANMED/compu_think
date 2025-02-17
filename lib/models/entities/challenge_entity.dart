class ChallengeEntity {
  final int? id;
  final int idUnidad;
  final int idTipoReto;
  final String? nombre;
  final String? url;
  final String vigente;

  ChallengeEntity({
    this.id,
    required this.idUnidad,
    required this.idTipoReto,
    this.nombre,
    this.url,
    this.vigente = 'S',
  });

  // Metodo para convertir un mapa (de la base de datos) a una entidad Unidad
  factory ChallengeEntity.fromMap(Map<String, dynamic> map) {
    return ChallengeEntity(
      id: map['id'] as int?,
      idUnidad: map['id_unidad'] as int,
      idTipoReto: map['id_tipo_reto'] as int,
      nombre: map['nombre'] as String?,
      url: map['url'] as String?,
      vigente: map['vigente'] as String? ?? 'S',
    );
  }

  // Método para convertir una entidad Unidad a un mapa (para la base de datos)
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'id_unidad': idUnidad,
      'id_tipo_reto': idTipoReto,
      'nombre': nombre,
      'url': url,
      'vigente': vigente,
    };
  }
}
