// ignore_for_file: file_names
import 'package:compu_think/models/entities/comment_entity.dart';
import 'package:compu_think/models/entities/user_entity.dart';
import 'package:compu_think/models/repositories/comment_repository.dart';
import 'package:compu_think/models/repositories/user_repository.dart';

class DebateController {
  final CommentRepository commentRepository = CommentRepository();
  final UserRepository userRepository = UserRepository();
  List<CommentEntity> comments = [];
  List<UserEntity> users = [];

  Future<void> loadComments(int idReto, Function callback) async {
    try {
      comments =
          (await commentRepository.fetchComments(idReto)).cast<CommentEntity>();
      users = await userRepository.fetchAllUsers();
      callback();
    } catch (e) {
      throw Exception("Error al cargar comentarios: $e");
    }
  }

  Future<void> addComment(
      int idPersona, int idReto, String text, Function callback) async {
    try {
      final newComment =
          await commentRepository.addComment(idPersona, idReto, text);
      comments.insert(0, newComment);
      callback();
    } catch (e) {
      throw Exception("Error al agregar comentario: $e");
    }
  }

  Future<void> removeComment(int id, int index, Function callback) async {
    try {
      await commentRepository.deleteComment(id);
      comments.removeAt(index);
      callback();
    } catch (e) {
      throw Exception("Error al eliminar comentario: $e");
    }
  }

  String getUserName(int idPersona) {
    try {
      final user = users.firstWhere((user) => user.id == idPersona);
      return "${user.nombre1} ${user.apellido1}"
                .replaceAll(RegExp(r'\s+'), ' ')
                .trim();
    } catch (e) {
      throw Exception("Error al obtener usuario: $e");
    }
  }
}
