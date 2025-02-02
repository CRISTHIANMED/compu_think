import 'package:flutter/material.dart';

class DebateApp extends StatelessWidget {
  const DebateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DebatePage(),
    );
  }
}

class DebatePage extends StatefulWidget {
  const DebatePage({super.key});

  @override
  _DebatePageState createState() => _DebatePageState();
}

class _DebatePageState extends State<DebatePage> {
  final TextEditingController _controller = TextEditingController();
  List<Comment> comments = [];

  void addComment(String text) {
    setState(() {
      comments.insert(0, Comment(user: "Usuario", text: text, timestamp: DateTime.now()));
      _controller.clear();
    });
  }

  void deleteComment(int index) {
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
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(icon: Icon(Icons.comment), label: "Debate"),
        ],
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
                          deleteComment(index);
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
  String user;
  String text;
  DateTime timestamp;

  Comment({required this.user, required this.text, required this.timestamp});
}
