import 'package:compu_think/models/entities/comment_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommentRepository {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<CommentEntity>> fetchComments(int idReto) async {
    try {
      final response = await supabase
          .from('reto_comentario')
          .select()
          .eq('id_reto', idReto)
          .order('fecha', ascending: false);
      return response.map((data) => CommentEntity.fromMap(data)).toList();
    } catch (e) {
      throw Exception("Error al obtener comentarios: $e");
    }
  }

  Future<CommentEntity> addComment(
      int idPersona, int idReto, String text) async {
    try {
      final newComment = {
        'id_persona': idPersona,
        'id_reto': idReto,
        'texto': text,
        'fecha': DateTime.now().toUtc().toIso8601String(),
      };

      final response = await supabase
          .from('reto_comentario')
          .insert(newComment)
          .select()
          .single();

      return CommentEntity.fromMap(response);
    } catch (e) {
      throw Exception("Error al agregar comentario: $e");
    }
  }

  Future<void> deleteComment(int id) async {
    try {
      await supabase.from('reto_comentario').delete().eq('id', id);
    } catch (e) {
      throw Exception("Error al eliminar comentario: $e");
    }
  }

  Future<int> countUserComments(int idPersona, int idReto) async {
    try {
      final response = await supabase
          .from('reto_comentario')
          .select()
          .eq('id_persona', idPersona)
          .eq('id_reto', idReto);
      return response.length;
    } catch (e) {
      throw Exception("Error al contar comentarios: $e");
    }
  }

  Future<void> updateRetoPersona(int idPersona, int idReto, bool aprobado, int calificacion) async {
    try {
      await supabase.from('reto_persona').update({
        'aprobado': aprobado,
        'calificacion': calificacion,
      }).match({
        'id_persona': idPersona,
        'id_reto': idReto,
      });
    } catch (e) {
      throw Exception("Error al actualizar reto_persona: $e");
    }
  }
}
