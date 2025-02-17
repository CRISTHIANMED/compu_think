import 'package:compu_think/models/entities/question_options_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class QuestionOptionsRepository {
  final supabase = Supabase.instance.client;

  Future<List<Question>> getPreguntasByTipoUnidad(
      int idTipoReto, int idUnidad) async {
    try {
      final response = await supabase
          .from('reto_pregunta')
          .select('id, titulo, pregunta, url_imagen,'
              'reto_pregunta_opcion(id, descripcion, correcta, url_imagen),'
              'reto(id_unidad, id_tipo_reto)')
          .order('id', ascending: true);

      // Filtrar las preguntas que pertenecen a la unidad y al tipo de reto
      List<Map<String, dynamic>> filteredPreguntas = response
          .where((x) => (x["reto"]["id_unidad"] == idUnidad &&
              x["reto"]["id_tipo_reto"] == idTipoReto))
          .toList();

    // Mapear los datos a objetos de tipo Question
    List<Question> questions = filteredPreguntas.map((pregunta) {
      // Convertir opciones a una lista de objetos Option
      List<Option> options = (pregunta['reto_pregunta_opcion'] as List<dynamic>)
          .map((opcion) => Option(
                id: opcion['id'],
                description: opcion['descripcion'],
                isCorrect: opcion['correcta'],
                imageUrl: opcion['url_imagen'],
              ))
          .toList();

      // Ordenar opciones por id en orden ascendente
      options.sort((a, b) => a.id.compareTo(b.id));

      return Question(
        id: pregunta['id'],
        title: pregunta['titulo'],
        questionText: pregunta['pregunta'],
        imageUrl: pregunta['url_imagen'],
        options: options, // Asignar la lista ordenada
      );
    }).toList();

      return questions;
    } catch (e) {
      throw Exception('No se pudieron cargar las preguntas: $e');
    }
  }
}