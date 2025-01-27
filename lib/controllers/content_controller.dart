import 'package:compu_think/models/entities/content_entity.dart';
import 'package:compu_think/models/entities/view_detail_content_entity.dart';
import 'package:compu_think/models/repositories/content_repository.dart';

class ContentController {
  final ContentRepository contentRepository = ContentRepository();

  // Obtener contenido por idTema
  Future<List<ContentEntity>> getSubtopicsByTema(int idTema) async {
    try {
      final subtopics = await contentRepository.fetchSubtopicByTemaId(idTema);
      return subtopics;
    } catch (e) {
      throw Exception('Error al obtener los subtemas: $e');
    }
  }

  // Obtener contenido por idTema y idTipoContenido
  Future<List<ContentEntity>> getContentByTemaAndTipo(int idTema, List<int> idTipoContenidoList) async {
    try {
      final content = await contentRepository.fetchContentByTemaAndTipo(idTema, idTipoContenidoList);
      return content;
    } catch (e) {
      throw Exception('Error al obtener los contenidos por tema y tipo: $e');
    }
  }

  // Obtener vista contenido detalle por idTema
  Future<List<ViewDetailContentEntity>> getViewSubtopicDetailsByTema(int idTema) async {
    try {
      final subtopics = await contentRepository.fetchContenidoDetalleByTemaId(idTema);
      return subtopics;
    } catch (e) {
      throw Exception('Error al obtener los subtemas: $e');
    }
  }


  
}
