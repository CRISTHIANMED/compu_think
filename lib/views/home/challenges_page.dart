// ignore_for_file: library_private_types_in_public_api

import 'package:compu_think/controllers/challenge_controller.dart';
import 'package:compu_think/models/entities/view_detail_challenge_entity.dart';
import 'package:compu_think/views/home/debate_page.dart';
import 'package:compu_think/views/home/map_page.dart';
import 'package:compu_think/views/home/question_page.dart';
import 'package:flutter/material.dart';
import 'package:compu_think/utils/widgets/custom_bottom_navigation_bar.dart';

class ChallengePage extends StatefulWidget {
  const ChallengePage({super.key});

  @override
  _ChallengePageState createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  final ChallengeController _challengeController = ChallengeController();

  List<ViewDetailChallengeEntity> _retos = [];
  bool _isLoading = true;
  String? _errorMessage;

  late int idUnidad;
  late int idPersona;
  late String titulo;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadArguments();
    _fetchRetos();
  }

  void _loadArguments() {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      idPersona = args['idPersona'] as int;
      idUnidad = args['idUnidad'] as int;
      titulo = args['tituloUnidad'];
    } else {
      idUnidad = 0;
      idPersona = 0;
      titulo = 'Título no disponible';
    }
  }

  Future<void> _fetchRetos() async {
    try {
      final retos = await _challengeController.fetchByIdPersonaAndIdUnidad(
          idPersona, idUnidad);
      if (mounted) {
        // Evita llamar setState() si el widget ya fue eliminado
        setState(() {
          _retos = retos;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error al cargar los retos';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Retos"),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              titulo,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(child: Text(_errorMessage!))
                      : ListView.builder(
                          itemCount: _retos.length,
                          itemBuilder: (context, index) {
                            return _buildRetoCard(context, _retos[index]);
                          },
                        ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 0),
    );
  }

  Widget _buildRetoCard(BuildContext context, ViewDetailChallengeEntity reto) {
    Color cardColor;
    bool isEnabled;
    double opacity;

    switch (reto.estadoDescripcion.toLowerCase()) {
      case 'pendiente':
        cardColor = Colors.yellow;
        isEnabled = true;
        opacity = 1.0;
        break;
      case 'no_completado':
        cardColor = Colors.grey;
        isEnabled = false;
        opacity = 0.5;
        break;
      case 'completado':
        cardColor = Colors.green;
        isEnabled = true;
        opacity = 1.0;
        break;
      default:
        cardColor = Colors.white;
        isEnabled = false;
        opacity = 0.5;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Opacity(
        opacity: opacity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15),
            backgroundColor: cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: isEnabled
              ? () async {
                  if (reto.idTipoReto == 1) {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuestionPage(
                          idUnidad,
                          tipoRetoNombre: reto.tipoRetoNombre,
                          urlReto: reto.urlReto,
                          tipoRetoSubtitulo: reto.tipoRetoSubtitulo,
                        ),
                      ),
                    );
                    // Si result es true, recargar los datos
                    if (result == true) {
                      _fetchRetos(); // Llama nuevamente la función que carga los datos
                      setState(() {}); // Asegura que la UI se actualice
                    }
                  } else if (reto.idTipoReto == 2) {
                    final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DebatePage(
                            idReto: reto.idReto,
                            idPersona: idPersona,
                            tipoRetoNombre: reto.tipoRetoNombre,
                            urlReto: reto.urlReto,
                            tipoRetoSubtitulo: reto.tipoRetoSubtitulo,
                          ),
                        ));
                    // Si result es true, recargar los datos
                    if (result == true) {
                      _fetchRetos(); // Llama nuevamente la función que carga los datos
                      setState(() {}); // Asegura que la UI se actualice
                    }
                  } else if (reto.idTipoReto == 3) {
                    final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapPage(
                            idUnidad,
                            tipoRetoNombre: reto.tipoRetoNombre,
                            urlReto: reto.urlReto,
                            tipoRetoSubtitulo: reto.tipoRetoSubtitulo,
                          ),
                        ));
                    // Si result es true, recargar los datos
                    if (result == true) {
                      _fetchRetos(); // Llama nuevamente la función que carga los datos
                      setState(() {}); // Asegura que la UI se actualice
                      _showCongratulationsDialog();
                    }
                  }
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reto.tipoRetoNombre,
                  style: const TextStyle(
                    fontSize: 18, // Tamaño más grande para el título
                    fontWeight: FontWeight.bold, // Negrita para destacar
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  reto.tipoRetoSubtitulo,
                  style: const TextStyle(
                    fontSize: 16, // Un poco más pequeño que el título
                    fontWeight: FontWeight.w500,
                    color:
                        Colors.black, // Color gris para diferenciar del título
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  reto.tipoRetoDescripcion,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontSize: 12, // Tamaño más pequeño para la descripción
                    fontWeight: FontWeight.normal, // Texto normal
                    color:
                        Colors.black87, // Negro más suave para la descripción
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Función para mostrar el cuadro de diálogo
  void _showCongratulationsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.tag_faces, color: Colors.blue, size: 30),
              SizedBox(width: 15),
              Text("¡Felicidades!"),
            ],
          ),
          content: const Text(
            "Unidad aprobada. ¡Puedes continuar con el siguiente reto!",
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cierra el diálogo
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/Unidad', // Ruta que apunta a la página de unidades
                  (route) => false, // Elimina todas las rutas anteriores
                );
              },
              child: const Text("Continuar"),
            ),
          ],
        );
      },
    );
  }
}
