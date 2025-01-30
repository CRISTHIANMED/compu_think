

import 'package:compu_think/models/entities/question_options_entity.dart';
import 'package:compu_think/models/repositories/question_options_repository.dart';

class QuestionController {
  final QuestionOptionsRepository _questionOptionsRepository = QuestionOptionsRepository();

  Future<List<Question>> fetchQuestions(int idTipoReto, int idUnidad) {
    try {
      return _questionOptionsRepository.getPreguntasByTipoUnidad(idTipoReto, idUnidad);
    } catch (e) {
      throw Exception('Error al cargar los preguntas: $e');
    }
  }


}
