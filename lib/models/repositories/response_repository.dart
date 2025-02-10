import 'package:compu_think/models/entities/response_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResponseRepository {
  final supabase = Supabase.instance.client;

  // Insertar una nueva respuesta
  Future<void> insertResponse(ResponseEntity respuesta) async {
    await supabase.from('respuesta').insert(respuesta.toMap());
  }

  // Obtener respuestas por persona
  Future<List<ResponseEntity>> fetchByPersonaAndPregunta(int idPersona, int idRetoPregunta) async {
    final response = await supabase
        .from('respuesta')
        .select()
        .eq('id_persona', idPersona)
        .eq('id_reto_pregunta', idRetoPregunta);

    return (response).map((map) => ResponseEntity.fromMap(map)).toList();
  }

  /// Actualizar la fecha y opcion en la tabla 'respuesta' en id_persona
  Future<void> updateResponse(int idPersona, int idRetoPregunta,
      int idRetoPreguntaOpcion, DateTime fecha) async {

    await supabase
        .from('respuesta')
        .update({
          'fecha': fecha.toIso8601String(),
          'id_reto_pregunta_opcion': idRetoPreguntaOpcion,
        })
        .eq('id_persona', idPersona)
        .eq('id_reto_pregunta', idRetoPregunta);
  }

  // Obtener respuestas por persona y unidad de vista detalles
  Future<List<Map<String, dynamic>>> fetchViewResponceByIdPersonIdUnidad(int idPersona, int idUnidad, int idTipoReto) async {
    final response = await supabase
        .from('view_detail_respuestas')
        .select('id_persona, id_reto_pregunta, id_reto_pregunta_opcion, id_unidad, id_tipo_reto')
        .eq('id_persona', idPersona)
        .eq('id_unidad', idUnidad)
        .eq('id_tipo_reto', idTipoReto);

    return response;
  }

 

}
