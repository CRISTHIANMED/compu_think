class ViewDetailContentEntity {
  final int contenidoId;
  final String contenidoNombre;
  final String contenidoUrl;
  final int tipoContenidoId;
  final String tipoContenidoNombre;
  final int temaId;
  final String temaTitulo;
  final int temaOrden;
  final String temaVigente;
  final int unidadId;

  ViewDetailContentEntity({
    required this.contenidoId,
    required this.contenidoNombre,
    required this.contenidoUrl,
    required this.tipoContenidoId,
    required this.tipoContenidoNombre,
    required this.temaId,
    required this.temaTitulo,
    required this.temaOrden,
    required this.temaVigente,
    required this.unidadId,
  });

  // Método para crear una instancia a partir de un map
  factory ViewDetailContentEntity.fromMap(Map<String, dynamic> map) {
    return ViewDetailContentEntity(
      contenidoId: map['contenido_id'] as int,
      contenidoNombre: map['contenido_nombre'] as String,
      contenidoUrl: map['contenido_url'] as String,
      tipoContenidoId: map['tipo_contenido_id'] as int,
      tipoContenidoNombre: map['tipo_contenido_nombre'] as String,
      temaId: map['tema_id'] as int,
      temaTitulo: map['tema_titulo'] as String,
      temaOrden: map['tema_orden'] as int,
      temaVigente: map['tema_vigente'] as String,
      unidadId: map['unidad_id'] as int,
    );
  }

  // Método para convertir la instancia a un Map
  Map<String, dynamic> toMap() {
    return {
      'contenido_id': contenidoId,
      'contenido_nombre': contenidoNombre,
      'contenido_url': contenidoUrl,
      'tipo_contenido_id': tipoContenidoId,
      'tipo_contenido_nombre': tipoContenidoNombre,
      'tema_id': temaId,
      'tema_titulo': temaTitulo,
      'tema_orden': temaOrden,
      'tema_vigente': temaVigente,
      'unidad_id': unidadId,
    };
  }
}
