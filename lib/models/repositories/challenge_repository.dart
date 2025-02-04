import 'package:compu_think/models/entities/challenge_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChallengeRepository {
  final supabase = Supabase.instance.client;

  Future<List<ChallengeEntity>> fetchChallenge() async {
    try {
      final response = await supabase
        .from('reto')
        .select();

      final data = response as List<dynamic>;
      return data
          .map((json) => ChallengeEntity.fromMap(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener los retos: $e');
    }
  }

    Future<List<ChallengeEntity>> fetchChallengeByUnidadId(int idUnidad) async {
    try {
      final response = await supabase
        .from('reto')
        .select()
        .eq('id_unidad', idUnidad);

      final data = response as List<dynamic>;
      return data
          .map((map) => ChallengeEntity.fromMap(map as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener los retos: $e');
    }
  }

  // Método para obtener solo los IDs de todas los retos, ordenados por 'orden'
  Future<List<Map<String, dynamic>>> fetchAllChallengeIds() async {
    try {
      // Realiza la consulta a la tabla 'unidad' y selecciona solo el campo 'id'
      final response = await supabase
              .from('reto')
              .select('id, id_tipo_reto')
              .order('id_unidad', ascending: true)
              .order('id_tipo_reto', ascending: true);
    

      // Mapea los resultados y devuelve solo los IDs como una lista de enteros
      return response;

    } catch (e) {
      // Manejo de errores
      throw Exception('Error al obtener los IDs de las unidades: $e');
    }
  }


}
