class SubtopicEntity {
  final int id;
  final int idUnidad;
  final String titulo;
  final int orden;
  //final String vigente;

  SubtopicEntity({
    required this.id,
    required this.idUnidad,
    required this.titulo,
    required this.orden,
    //required this.vigente,
  });

  // Metodo para convertir un mapa (de la base de datos) a una entidad Unidad
  factory SubtopicEntity.fromMap(Map<String, dynamic> map) {
    return SubtopicEntity(
      id: map['id'] as int,
      idUnidad: map['id_unidad'] as int,
      titulo: map['titulo'] as String,
      orden: map['orden'] as int,
      //vigente: json['vigente'] as String,
    );
  }

  // Método para convertir una entidad Unidad a un mapa (para la base de datos)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_unidad': idUnidad,
      'titulo': titulo,
      'orden': orden,
      //'vigente': vigente,
    };
  }
}
