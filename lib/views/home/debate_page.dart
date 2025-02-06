// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously
import 'package:compu_think/controllers/debate_controller.dart';
import 'package:compu_think/utils/widgets/custom_bottom_navigation_bar.dart';
import 'package:compu_think/utils/widgets/expandable_text.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    debateController.loadComments(widget.idReto, () => setState(() {}));
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
      appBar: AppBar(
        title: const Text("Debate"),
        backgroundColor: Colors.blue,
      ),
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
                        ExpandableText(
                          text: comment.texto,
                          maxLines: 4,
                        ),
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
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 150, // Altura máxima opcional
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: "Escribe un comentario...",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: null, // Permite que crezca dinámicamente
                      minLines: 1, // Mínima altura
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    if (_controller.text.isNotEmpty) {
                      // Validar el comentario
                      if (!debateController.isValidComment(_controller.text)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                                'El comentario no tiene suficientes palabras para ser válido.'),
                            action: SnackBarAction(
                              label: 'Cerrar', // Etiqueta del botón para cerrar
                              onPressed: () {
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                              },
                            ),
                            duration: const Duration(
                                seconds: 2), // Duración más corta si se desea
                          ),
                        );
                        return;
                      }
                      try {
                        // Llamar a la función addComment
                        String? resultMessage =
                            await debateController.addComment(
                          widget.idPersona,
                          widget.idReto,
                          _controller.text,
                          () => setState(() {}),
                        );

                        // Limpiar el campo de texto
                        _controller.clear();

                        // Verificar si se completó el reto y mostrar el AlertDialog
                        if (resultMessage != null) {
                          _showCompletionDialog(
                              resultMessage); // Mostrar el mensaje en un AlertDialog
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
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

  void _showCompletionDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('✅ Reto Aprobado'),
          content: Text(message), // Mostrar el mensaje que devuelve addComment
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: const Text('Continuar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cierra el cuadro de diálogo
                Navigator.pop(context,true); // Regresa a la pantalla anterior (retos)
              },
              child: const Text('Ir a Retos'),
            ),
          ],
        );
      },
    );
  }
}
