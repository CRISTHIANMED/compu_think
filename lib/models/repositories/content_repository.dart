import 'package:compu_think/models/entities/content_entity.dart';
import 'package:compu_think/models/entities/view_detail_content_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ContentRepository {
  final supabase = Supabase.instance.client;

  // Obtener contenido por tema
  Future<List<ContentEntity>> fetchSubtopicByTemaId(int idTema) async {
    try {
      final response = await supabase
            .from('contenido')
            .select()
            .eq('id_tema', idTema);

      final data = response as List<dynamic>;

      return data
          .map((map) => ContentEntity.fromMap(map as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error al consultar los temas: $e');
    }
  }

  // Obtener contenido por idTema y luego idTipoContenido
  Future<List<ContentEntity>> fetchContentByTemaAndTipo(int idTema, List<int> idTipoContenidoList) async {
    try {
      final response = await supabase
          .from('contenido')
          .select()
          .eq('id_tema', idTema) // Primero filtra por id_tema
          .inFilter('id_tipo_contenido', idTipoContenidoList); // Luego filtra por id_tipo_contenido

      final data = response as List<dynamic>;

      return data
          .map((map) => ContentEntity.fromMap(map as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error al consultar los contenidos por tema y tipo: $e');
    }
  }

    /// Obtiene la lista de contenidos detalle filtrados por idTema
  Future<List<ViewDetailContentEntity>> fetchContenidoDetalleByTemaId(int idTema) async {
    try {
      final response = await supabase
          .from('view_contenido_detalle') // Nombre de la vista
          .select()
          .eq('tema_id', idTema)
          .order('contenido_id', ascending: true);

      final data = response as List<dynamic>;
      return data
          .map((item) => ViewDetailContentEntity.fromMap(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error al consultar los contenidos detalle: $e');
    }
  }


}
