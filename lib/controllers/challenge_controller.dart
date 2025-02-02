

import 'package:compu_think/models/entities/view_detail_challenge_entity.dart';
import 'package:compu_think/models/repositories/challenge_repository.dart';
import 'package:compu_think/models/repositories/user_challenge_repository.dart';

class ChallengeController {

  final ChallengeRepository _challengeRepository = ChallengeRepository();
  final UserChallengeRepository _userChallengeRepository = UserChallengeRepository();

  // Método para obtener las ids unidades
  Future<List<Map<String, dynamic>>> fetchAllChallengeIds() {
    try {
      return _challengeRepository.fetchAllChallengeIds();
    } catch (e) {
      // Manejar el error (se puede lanzar una excepción o devolver una lista vacía)
      throw Exception('Error al obtener las ids de unidades: $e');
    }
  }

  Future<List<ViewDetailChallengeEntity>> fetchByIdPersonaAndIdUnidad(int idPersona, int idUnidad) async {
    try {
      return await _userChallengeRepository.fetchByIdPersonaAndIdUnidad(idPersona, idUnidad);
    } catch (e) {
      throw Exception('Error al ontener la vista reto por persona and unidad: $e');
    }
  }

  Future<void> updateCalificacion(int idPersona, int idUnidad, int idTipoReto, double calificacion) async {
    try {
      await _userChallengeRepository.updateCalificacion(idPersona, idUnidad, idTipoReto, calificacion);
    } catch (e) {
      // Manejar el error (se puede lanzar una excepción o devolver una lista vacía)
      throw Exception('Error al actualizar la tabla: $e');
    }


  }
}