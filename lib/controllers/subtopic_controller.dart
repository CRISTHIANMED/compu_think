import 'package:compu_think/models/entities/subtopic_entity.dart';
import 'package:compu_think/models/repositories/subtopic_respository.dart';


class SubtopicController {
  final SubtopicRespository _subtopicRespository = SubtopicRespository();

   // Método para obtener temas por idUnidad
  Future<List<SubtopicEntity>> fetchTemasByUnidadId(int idUnidad) async {
    try {
      return await _subtopicRespository.fetchSubtopicByUnidadId(idUnidad);
    } catch (e) {
      throw Exception('Error al cargar los temas: $e');
    }
  }

  
  
}
