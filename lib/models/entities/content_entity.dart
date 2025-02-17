class ContentEntity {
  final int? id;
  final int idTipoContenido;
  final int idTema;
  final String? nombre;
  final String? url;

  ContentEntity({
    this.id,
    required this.idTipoContenido,
    required this.idTema,
    this.nombre,
    this.url,
  });

  // Metodo para convertir un mapa (de la base de datos) a una entidad Unidad
  factory ContentEntity.fromMap(Map<String, dynamic> map) {
    return ContentEntity(
      id: map['id'] as int?,
      idTipoContenido: map['id_tipo_contenido'] as int,
      idTema: map['id_tema'] as int,
      nombre: map['nombre'] as String?,
      url: map['url'] as String?,
    );
  }

  // Método para convertir una entidad Unidad a un mapa (para la base de datos)
  Map<String, dynamic> toMap() {
    return {
      'id_tipo_contenido': idTipoContenido,
      'id_tema': idTema,
      'nombre': nombre,
      'url': url,
    };
  }
}
