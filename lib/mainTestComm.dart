// ignore_for_file: library_private_types_in_public_api

import 'package:compu_think/utils/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: 'YOUR_SUPABASE_URL', anonKey: 'YOUR_SUPABASE_ANON_KEY');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Debate Test',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const DebatePage(idReto: 1, idPersona: 1),
    );
  }
}

class CommentEntity {
  final int id;
  final int idPersona;
  final int idReto;
  final String text;
  final DateTime timestamp;

  CommentEntity({
    required this.id,
    required this.idPersona,
    required this.idReto,
    required this.text,
    required this.timestamp,
  });

  factory CommentEntity.fromMap(Map<String, dynamic> map) {
    return CommentEntity(
      id: map['id'],
      idPersona: map['id_persona'],
      idReto: map['id_reto'],
      text: map['texto'],
      timestamp: DateTime.parse(map['fecha']).toLocal(),
    );
  }
}

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

  Future<CommentEntity> addComment(int idPersona, int idReto, String text) async {
    try {
      final newComment = {
        'id_persona': idPersona,
        'id_reto': idReto,
        'texto': text,
        'fecha': DateTime.now().toUtc().toIso8601String(),
      };

      final response = await supabase.from('reto_comentario').insert(newComment).select().single();
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
}

class DebateController {
  final CommentRepository repository;
  List<CommentEntity> comments = [];

  DebateController(this.repository);

  Future<void> loadComments(int idReto, Function callback) async {
    try {
      comments = await repository.fetchComments(idReto);
      callback();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> addComment(int idPersona, int idReto, String text, Function callback) async {
    try {
      final newComment = await repository.addComment(idPersona, idReto, text);
      comments.insert(0, newComment);
      callback();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> removeComment(int id, int index, Function callback) async {
    try {
      await repository.deleteComment(id);
      comments.removeAt(index);
      callback();
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

class DebatePage extends StatefulWidget {
  final int idReto;
  final int idPersona;

  const DebatePage({super.key, required this.idReto, required this.idPersona});

  @override
  _DebatePageState createState() => _DebatePageState();
}

class _DebatePageState extends State<DebatePage> {
  final TextEditingController _controller = TextEditingController();
  final DebateController controller = DebateController(CommentRepository());

  @override
  void initState() {
    super.initState();
    controller.loadComments(widget.idReto, () => setState(() {}));
  }

  String timeAgo(DateTime timestamp) {
    final Duration difference = DateTime.now().difference(timestamp);
    if (difference.inDays > 0) {
      return 'Hace ${difference.inDays} días';
    } else if (difference.inHours > 0) {
      return 'Hace ${difference.inHours} horas';
    } else if (difference.inMinutes > 0) {
      return 'Hace ${difference.inMinutes} minutos';
    } else {
      return 'Justo ahora';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Debate")),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 0),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: controller.comments.length,
              itemBuilder: (context, index) {
                final comment = controller.comments[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile(
                    title: Text("Usuario ${comment.idPersona}", style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(comment.text),
                        const SizedBox(height: 5),
                        Text(timeAgo(comment.timestamp), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                    trailing: comment.idPersona == widget.idPersona
                        ? PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'Eliminar') {
                                controller.removeComment(comment.id, index, () => setState(() {}));
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(value: 'Eliminar', child: Text('Eliminar')),
                            ],
                          )
                        : null,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(hintText: "Escribe un comentario...", border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      controller.addComment(widget.idPersona, widget.idReto, _controller.text, () => setState(() {}));
                      _controller.clear();
                    }
                  },
                  child: const Text("Enviar"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
