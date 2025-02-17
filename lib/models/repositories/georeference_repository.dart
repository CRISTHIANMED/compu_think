import 'package:compu_think/models/entities/georeference_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GeoreferenceRepository {
  // Obtenemos la instancia del cliente Supabase
  final SupabaseClient _client = Supabase.instance.client;

  /// Obtiene todas las georeferencias de la tabla.
  Future<List<GeoreferenceEntity>> getAll() async {
    final response = await _client
    .from('georeferencia')
    .select();

    if (response.isEmpty) {
      throw Exception('Error al obtener georeferencias:');
    }

    final data = response as List<dynamic>;
    return data.map((map) => GeoreferenceEntity.fromMap(map)).toList();
  }

  /// Obtiene todas las georeferencias de la tabla.
  Future<List<GeoreferenceEntity>> getAllbyIdUnidad(idUnidad) async {
    final response = await _client
        .from('georeferencia')
        .select('id, latitud, longitud, id_reto_pregunta(id, id_reto(id_unidad, id_tipo_reto))')
        .order('id', ascending: true);

    // Filtrar los datos por idTipoReto
    List<Map<String, dynamic>> filteredPreguntas = response
        .where((x) => (x["id_reto_pregunta"]["id_reto"]["id_unidad"] == idUnidad))
        .toList();

    // Mapear cada elemento filtrado a un objeto GeoreferenceEntity
  List<GeoreferenceEntity> georeferences = filteredPreguntas.map((map) {
    return GeoreferenceEntity(
      id: map['id'],
      latitud: map['latitud'],
      longitud: map['longitud'] ,
      idRetoPregunta: map['id_reto_pregunta']['id'],
    );
  }).toList();

  return georeferences;
  }
}
