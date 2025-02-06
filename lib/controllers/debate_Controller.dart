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
  Function(String)? showMessage;
  final int nComment = 3;

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

  Future<void> addComment2(
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

  bool isValidComment(String text) {
    // Separar el texto en palabras
    List<String> words =
        text.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).toList();

    // Filtrar las palabras que tienen más de 3 letras
    List<String> validWords = words.where((word) => word.length > 2).toList();

    // Verificar que el comentario tenga exactamente mas de 10 palabras validas
    if (validWords.length < 10) {
      return false;
    }
    
    return true; // Si pasa la validación, es válido
  }

  Future<String?> addComment(
      int idPersona, int idReto, String text, Function callback) async {
    try {
      final newComment =
          await commentRepository.addComment(idPersona, idReto, text);
      comments.insert(0, newComment);
      callback();

      int commentCount =
          await commentRepository.countUserComments(idPersona, idReto);
      int calificacion = commentCount;
      bool isApproved = commentCount >= 3;

      // Actualizar el reto siempre
      await commentRepository.updateRetoPersona(idPersona, idReto, isApproved, calificacion);

      // Retornar mensaje si el reto está completado solo si el comentario alcanza el mínimo de 3
      return commentCount == 3 ? "¡Felicidades! Has completado el reto." : null;

    } catch (e) {
      return "Error al agregar comentario: $e"; // Mensaje de error
    }
  }
}
