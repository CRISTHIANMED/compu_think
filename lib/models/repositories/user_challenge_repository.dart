import 'package:compu_think/models/entities/user_challenge_entity.dart';
import 'package:compu_think/models/entities/view_detail_challenge_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserChallengeRepository {
  final supabase = Supabase.instance.client;

  /// Consultar todos los registros de la tabla `reto_persona`
  Future<List<UserChallengeEntity>> fetchAll() async {
    final response = await supabase
        .from('reto_persona')
        .select()
        .order('id', ascending: true);

    return (response as List)
        .map((map) => UserChallengeEntity.fromMap(map))
        .toList();
  }

  /// Consultar registros por 'id_persona'
  Future<List<UserChallengeEntity>> fetchByPersonaId(int idPersona) async {
    final response = await supabase
        .from('reto_persona')
        .select()
        .eq('id_persona', idPersona)
        .order('id_reto', ascending: true);

    if (response.isEmpty) {
      return [];
    }

    return response.map((map) => UserChallengeEntity.fromMap(map)).toList();
  }

  // Método para obtener solo los IDs de todas las unidades, ordenados por 'tipo_reto'
  Future<List<int>> fetchAllCallengeIds(int idUnidad) async {
    final response = await supabase
        .from('reto')
        .select('id')
        .eq('id_unidad', idUnidad)
        .order('id_tipo_reto', ascending: true);

    if (response.isEmpty) {
      return [];
    }

    // Mapea los resultados y devuelve solo los IDs como una lista de enteros
    return (response as List).map((map) => map['id'] as int).toList();
  }

  /// Insertar registros en la tabla 'reto_persona'
  Future<void> insert(List<Map<String, dynamic>> list) async {
    await supabase.from('reto_persona').insert(list);
  }

  /// Actualiza el campo 'id_tipo_estado' basado en los valores de 'id_reto' y 'id_persona'
  Future<void> updateTipoEstado(
      int idReto, int idPersona, int idTipoEstado) async {
    await supabase
        .from('reto_persona')
        .update({'id_tipo_estado': idTipoEstado}) // Campo a actualizar
        .eq('id_reto', idReto) // Condición para 'id_reto'
        .eq('id_persona', idPersona); // Condición para 'id_persona'
  }

  Future<List<ViewDetailChallengeEntity>> fetchDetailChallengeAll() async {
    final response = await supabase.from('vista_reto_persona').select();

    return response
        .map((data) => ViewDetailChallengeEntity.fromMap(data))
        .toList();
  }

  Future<List<ViewDetailChallengeEntity>> fetchByIdPersonaAndIdUnidad(
      int idPersona, int idUnidad) async {
    final response = await supabase
        .from('view_detail_reto_persona')
        .select()
        .eq('id_persona', idPersona)
        .eq('id_unidad', idUnidad);

    return response
        .map((data) => ViewDetailChallengeEntity.fromMap(data))
        .toList();
  }
}
