// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously
import 'package:compu_think/controllers/debate_Controller.dart';
import 'package:compu_think/utils/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DebatePage extends StatefulWidget {
  final int idReto;
  final int idPersona;

  const DebatePage({super.key, required this.idReto, required this.idPersona});

  @override
  _DebatePageState createState() => _DebatePageState();
}

class _DebatePageState extends State<DebatePage> {
  final TextEditingController _controller = TextEditingController();
  final DebateController debateController = DebateController();
  String nombre = ""; // Nombre completo
  String userName = ""; // Nombre cusuario
  String userEmail = ""; // Correo electrónico

  @override
  void initState() {
    super.initState();
    debateController.loadComments(widget.idReto, () => setState(() {}));
    _loadUserNameUser();
  }

  // Método para cargar los datos del usuario desde SharedPreferences
  Future<void> _loadUserNameUser() async {
    final prefs = await SharedPreferences.getInstance();
    final nombre1 = prefs.getString('nombre1') ?? '';
    final apellido1 = prefs.getString('apellido1') ?? '';
    final nUsuario = prefs.getString('nUsuario') ?? '';

    // Construir el nombre completo y asignar el correo
    setState(() {
      nombre = "$nombre1 $apellido1 ".replaceAll(RegExp(r'\s+'), ' ').trim();
      userName = nUsuario;
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
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 0),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: debateController.comments.length,
              itemBuilder: (context, index) {
                final comment = debateController.comments[index];
                final userName =
                    debateController.getUserName(comment.idPersona);
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile(
                    title: Text(
                      userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14, // Tamaño más pequeño para la descripción
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(comment.texto),
                        const SizedBox(height: 5),
                        Text(timeAgo(comment.fecha),
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                    trailing: comment.idPersona == widget.idPersona
                        ? PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'Eliminar') {
                                debateController.removeComment(
                                  comment.id,
                                  index,
                                  () => setState(() {}),
                                );
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'Eliminar',
                                child: Text('Eliminar'),
                              ),
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
                    decoration: const InputDecoration(
                        hintText: "Escribe un comentario...",
                        border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    if (_controller.text.isNotEmpty) {
                      try {
                        await debateController.addComment(
                            widget.idPersona,
                            widget.idReto,
                            _controller.text,
                            () => setState(() {}));

                        _controller.clear();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())));
                      }
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
