import 'package:compu_think/models/entities/response_entity.dart';
import 'package:compu_think/models/repositories/response_repository.dart';

class ReponseController {
  final ResponseRepository _reponseRepository = ResponseRepository();

  /// Guarda o actualiza la respuesta de un usuario
  Future<void> saveResponse({
    required int idPersona,
    required int idRetoPregunta,
    required int idRetoPreguntaOpcion,
  }) async {
    try {
      // Buscar si ya existe la respuesta para ese usuario y esa pregunta
      List<ResponseEntity> respuestas =
          await _reponseRepository.fetchByPersonaAndPregunta(
        idPersona,
        idRetoPregunta,
      );

      if (respuestas.isNotEmpty) {
        // Obtener la primera respuesta (suponiendo que solo hay una por usuario y pregunta)
        ResponseEntity respuestaActual = respuestas.first;

        // Validar si la opción ya es la misma
        if (respuestaActual.idRetoPreguntaOpcion != idRetoPreguntaOpcion) {
          // Si la opción es diferente, actualizar
          await _reponseRepository.updateResponse(
            idPersona,
            idRetoPregunta,
            idRetoPreguntaOpcion,
            DateTime.now(),
          );
        }
      } else {
        // Si no existe, insertar una nueva respuesta
        ResponseEntity nuevaRespuesta = ResponseEntity(
          idPersona: idPersona,
          idRetoPregunta: idRetoPregunta,
          idRetoPreguntaOpcion: idRetoPreguntaOpcion,
          fecha: DateTime.now(),
        );

        await _reponseRepository.insertResponse(nuevaRespuesta);
      }
    } catch (e) {
      throw Exception('Error al consultar respuetas: $e');
    }
  }

  // Obtener respuestas por persona y unidad de vista detalles
  Future<List<Map<String, dynamic>>> fetchViewResponceByIdPersonIdUnidad(
      int idPersona, int idUnidad, int idTipoReto) async {
    try {
      final content = _reponseRepository.fetchViewResponceByIdPersonIdUnidad(
          idPersona, idUnidad, idTipoReto);
      return content;
    } catch (e) {
      throw Exception('Error al obtener respuestas: $e');
    }
  }
}
