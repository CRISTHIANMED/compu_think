import 'package:compu_think/utils/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DebatePage extends StatefulWidget {
  final int idReto;
  final int idPersona;

  const DebatePage({super.key, required this.idReto, required this.idPersona});

  @override
  _DebatePageState createState() => _DebatePageState();
}

class _DebatePageState extends State<DebatePage> {
  final TextEditingController _controller = TextEditingController();
  final SupabaseClient supabase = Supabase.instance.client;
  List<Comment> comments = [];

  @override
  void initState() {
    super.initState();
    fetchComments();
  }

  Future<void> fetchComments() async {
    final response = await supabase
        .from('reto_comentario')
        .select()
        .eq('id_reto', widget.idReto)
        .order('fecha', ascending: false);

    setState(() {
      comments = response.map((data) => Comment.fromMap(data)).toList();
    });
  }

  Future<void> addComment(String text) async {
    final newComment = {
      'id_persona': widget.idPersona,
      'id_reto': widget.idReto,
      'texto': text,
      'fecha': DateTime.now().toUtc().toIso8601String(),
    };

    final response = await supabase.from('reto_comentario').insert(newComment).select().single();

    setState(() {
      comments.insert(0, Comment.fromMap(response));
      _controller.clear();
    });
  }

  Future<void> deleteComment(int id, int index) async {
    await supabase.from('reto_comentario').delete().eq('id', id);
    setState(() {
      comments.removeAt(index);
    });
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
      bottomNavigationBar: const CustomBottomNavigationBar(
        currentIndex: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile(
                    title: Text(comments[index].user, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(comments[index].text),
                        const SizedBox(height: 5),
                        Text(timeAgo(comments[index].timestamp), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'Eliminar') {
                          deleteComment(comments[index].id, index);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'Eliminar', child: Text('Eliminar')),
                      ],
                    ),
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
                    decoration: const InputDecoration(
                      hintText: "Escribe un comentario...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      addComment(_controller.text);
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

class Comment {
  int id;
  String user;
  String text;
  DateTime timestamp;

  Comment({required this.id, required this.user, required this.text, required this.timestamp});

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'],
      user: 'Usuario ${map['id_persona']}',
      text: map['texto'],
      timestamp: DateTime.parse(map['fecha']).toLocal(),
    );
  }
}
