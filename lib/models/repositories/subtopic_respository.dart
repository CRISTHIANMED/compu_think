

import 'package:compu_think/models/entities/subtopic_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SubtopicRespository {
  final supabase = Supabase.instance.client;

  // Obtener temas por idUnidad
  Future<List<SubtopicEntity>> fetchSubtopicByUnidadId(int idUnidad) async {
    try {
      final response = await supabase
          .from('tema')
          .select()
          .eq('id_unidad', idUnidad)
          .order('orden', ascending: true);

      return response.map((map) => SubtopicEntity.fromMap(map)).toList();

    } catch (e) {
      throw Exception('Error al consultar los temas: $e');
    }
  }
}
