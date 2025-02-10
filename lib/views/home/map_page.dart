// ignore_for_file: library_private_types_in_public_api, unused_field
import 'package:compu_think/controllers/challenge_controller.dart';
import 'package:compu_think/controllers/geo_controller.dart';
import 'package:compu_think/controllers/questions_controller.dart';
import 'package:compu_think/controllers/reponse_controller.dart';
import 'package:compu_think/models/entities/question_options_entity.dart';
import 'package:compu_think/utils/helper/convert_google_drive_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapPage extends StatefulWidget {
  final int idUnidad;
  final String? urlReto;
  final String tipoRetoNombre;
  final String tipoRetoSubtitulo;

  const MapPage(
    this.idUnidad, {
    super.key,
    required this.urlReto,
    required this.tipoRetoNombre,
    required this.tipoRetoSubtitulo,
  });

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Map<int, int?> selectedAnswers = {};
  List<Question> _questions = [];
  Map<int, LatLng> _questionLocations = {};
  bool _isLoading = true;
  String? _errorMessage;
  late int _idPersona;

  LatLng currentLocation = const LatLng(1.2136, -77.2811);
  LatLng locationPasto = const LatLng(1.2136, -77.2811);
  int mapMode = 1; // 1: gps_fixed, 3: gps_not_fixed
  bool alignOnUpdate = false;
  bool alignDirection = false;
  Option? selectedOption;
  LatLng? centroMapa; // Guarda el centro calculado
  bool centrarUsuario =
      false; // 📌 Nuevo flag para evitar mover el mapa al usuario automáticamente

  late final MapController _mapController;
  final GeoController _geoController = GeoController();
  final ReponseController _reponseController = ReponseController();
  final QuestionController _questionController = QuestionController();
  final ChallengeController _challengeController = ChallengeController();

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _checkPermissions();
    fetchQuestions(3, widget.idUnidad);
    fetchLocations(widget.idUnidad);
  }

  Future<void> fetchLocations(idUnidad) async {
    try {
      final questionLocations =
          await _geoController.fetchGeoreferencesByTipoReto(idUnidad);
      if (mounted) {
        setState(() {
          _questionLocations = questionLocations;
        });
      }
      _initMap();
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
        });
      }
    }
  }

  Future<void> fetchQuestions(idTipoReto, idUnidad) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final idString = prefs.getString('id');
      final int idPersona = idString != null ? int.parse(idString) : 0;

      final questions =
          await _questionController.fetchQuestions(idTipoReto, idUnidad);

      final responses = await _reponseController
          .fetchViewResponceByIdPersonIdUnidad(idPersona, idUnidad, 3);

      _saveAnswerDataBase(responses);

      if (mounted) {
        setState(() {
          _questions = questions;
          _isLoading = false;
          _errorMessage = null;
          _idPersona = idPersona;

          for (var question in _questions) {
            selectedAnswers[question.id] = prefs.getInt('${question.id}');
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  Future<void> _saveAnswerDataBase(List<Map<String, dynamic>> responses) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (responses.isNotEmpty) {
      for (var response in responses) {
        prefs.setInt('${response['id_reto_pregunta']}',
            response['id_reto_pregunta_opcion']);
        selectedAnswers[response['id_reto_pregunta']] =
            prefs.getInt('${response['id_reto_pregunta']}');
      }
    }
    return;
  }

  Future<void> _saveAnswer(int questionId, int optionId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('$questionId', optionId);
  }

  double calculatePercentage() {
    int correctAnswers = 0;
    for (var question in _questions) {
      if (selectedAnswers[question.id] != null) {
        final selectedOptionId = selectedAnswers[question.id]!;
        final correctOption = question.getCorrectOption();
        if (correctOption?.id == selectedOptionId) {
          correctAnswers++;
        }
      }
    }
    return (correctAnswers / _questions.length) * 100;
  }

  bool areAllQuestionsAnswered() {
    return _questions.every((question) => selectedAnswers[question.id] != null);
  }

  Future<void> _checkPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return;
    }
  }

  void _toggleGpsMode() async {
    if (mapMode == 1) {
      setState(() {
        mapMode = 3; // Permite mover manualmente
      });
    } else {
      _setMode1();
    }
  }

  void _initMap() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LatLng centro = _calculateCenter(_questionLocations);
      setState(() {
        centroMapa = centro;
      });
      _mapController.move(centro, 19.0);
    });
  }

  void _setMode1() async {
    Position position = await Geolocator.getCurrentPosition();
    LatLng newLocation = LatLng(position.latitude, position.longitude);
    setState(() {
      mapMode = 1;
      centrarUsuario =
          true; // 📌 Activa la alineación solo cuando el usuario presiona el botón
    });
    _mapController.rotate(0);
    _mapController.move(newLocation, 18.0);
  }

  Stream<LocationMarkerPosition?> _positionStream() {
    return Geolocator.getPositionStream().map((Position position) {
      return LocationMarkerPosition(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
      );
    });
  }

  void _showQuestionDialog(Question question) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                // Agregar SingleChildScrollView
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      question.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(question.questionText),
                    if (question.imageUrl != null) ...[
                      const SizedBox(height: 8),
                      _buildImage(question.imageUrl!),
                    ],
                    const SizedBox(height: 10),
                    ...question.options.map((option) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RadioListTile<int>(
                            title: Text(option.description),
                            value: option.id,
                            groupValue: selectedAnswers[question.id],
                            onChanged: (value) {
                              setState(() {
                                selectedAnswers[question.id] = value;
                              });
                              _saveAnswer(question.id, value!);
                            },
                          ),
                          if (option.imageUrl != null) ...[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16.0), // Alinear con el texto
                              child: _buildImage(option.imageUrl!),
                            ),
                          ],
                        ],
                      );
                    }),
                    ElevatedButton(
                      onPressed: selectedAnswers[question.id] == null
                          ? null
                          : () {
                              Navigator.pop(context);
                              _checkAnswer(question, question.id,
                                  selectedAnswers[question.id]);
                            },
                      child: const Text("Enviar Respuesta"),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void showResult() {
    final percentage = calculatePercentage();

    final correctAnswers = _questions.where((question) {
      final selectedOptionId = selectedAnswers[question.id];
      final correctOption = question.getCorrectOption();

      return selectedOptionId != null && correctOption?.id == selectedOptionId;
    }).length;

    bool isApproved = percentage >= 50;

    String resultMessage =
        isApproved ? "✅ Reto Aprobado" : "❌ Reto No Aprobado";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(resultMessage, textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Porcentaje de aciertos: ${percentage.toStringAsFixed(2)}%"),
              const SizedBox(height: 8),
              Text("$correctAnswers/${_questions.length} preguntas acertadas."),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cierra el cuadro de diálogo
              },
              child: const Text("Intentar de nuevo"),
            ),
            ElevatedButton(
              onPressed: () async {
                await _challengeController.updateCalificacion(
                    _idPersona, widget.idUnidad, 3, isApproved, percentage);
                if (mounted) {
                  Navigator.pop(context); // Cierra el cuadro de diálogo
                  Navigator.pop(
                      context, true); // Regresa a la pantalla anterior (retos)
                }
              },
              child: const Text("Continuar"),
            ),
          ],
        );
      },
    );
  }

  // Mostrar el resultado de la respuesta
  void _checkAnswer(Question question, idRetoPregunta, idRetoPreguntaOpcion) {
    int? selectedOptionId = selectedAnswers[question.id];

    if (selectedOptionId == null) return; // No hacer nada si no hay selección

    // Buscar la opción seleccionada en las opciones de la pregunta
    Option? selectedOption = question.options.firstWhere(
      (option) => option.id == selectedOptionId,
      orElse: () =>
          Option(id: -1, description: "Opción inválida", isCorrect: false),
    );

    // Verificar si la opción es correcta o incorrecta
    bool isCorrect = selectedOption.isCorrect;

    // Mostrar el resultado en un diálogo
    _showAnswerDialog(isCorrect);

    _reponseController.saveResponse(
        idPersona: _idPersona,
        idRetoPregunta: idRetoPregunta,
        idRetoPreguntaOpcion: idRetoPreguntaOpcion!);
  }

  void _showAnswerDialog(bool isCorrect) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isCorrect ? "✅ Correcto!" : "❌ Incorrecto"),
          content: Text(isCorrect ? "¡Bien hecho!" : "Intenta de nuevo."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);

                // Después de cerrar el diálogo, verificar si todas las preguntas han sido respondidas
                Future.delayed(const Duration(milliseconds: 300), () {
                  if (areAllQuestionsAnswered()) {
                    showResult();
                  }
                });
              },
              child: const Text("Cerrar"),
            )
          ],
        );
      },
    );
  }

  LatLng _calculateCenter(Map<int, LatLng> locations) {
    if (locations.isEmpty) {
      return locationPasto; // Si no hay datos, retorna (0,0)
    }

    double sumLat = 0;
    double sumLng = 0;
    int total = locations.length;

    for (var latLng in locations.values) {
      sumLat += latLng.latitude;
      sumLng += latLng.longitude;
    }

    return LatLng(sumLat / total, sumLng / total);
  }

  Widget _buildImage(String? url) {
    if (url == null || url.isEmpty) {
      return const SizedBox(); // Retorna un widget vacío si la URL es null o está vacía
    }

    String imageUrl = convertGoogleDriveLink(url);

    return FutureBuilder(
      future: precacheImage(NetworkImage(imageUrl), context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Icon(Icons.error, size: 50, color: Colors.red);
        } else {
          return Image.network(imageUrl);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mapa de Preguntas"),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          // Mapa y contenido
          Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _calculateCenter(_questionLocations),
                  initialZoom: 15.0,
                  onPositionChanged: (position, hasGesture) {
                    if (hasGesture) {
                      setState(() {
                        mapMode =
                            3; // Activa modo manual cuando el usuario mueve el mapa
                      });
                    }
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                    retinaMode: RetinaMode.isHighDensity(context),
                  ),
                  MarkerLayer(
                    markers: [
                      ..._questions.map((question) {
                        LatLng? location = _questionLocations[question.id];
                        if (location == null) {
                          return null; // Ignorar si no hay ubicación
                        }
                        return Marker(
                          width: 40.0,
                          height: 40.0,
                          point: location,
                          child: GestureDetector(
                            onTap: () => _showQuestionDialog(question),
                            child: const Icon(
                              Icons.location_on_rounded,
                              color: Colors.red,
                              size: 50,
                            ),
                          ),
                        );
                      }).whereType<Marker>(), // Filtra los valores nulos
                    ],
                  ),
                  CurrentLocationLayer(
                    positionStream: _positionStream(),
                    alignPositionOnUpdate: (mapMode == 1 && centrarUsuario)
                        ? AlignOnUpdate.always
                        : AlignOnUpdate.never,
                    alignDirectionOnUpdate: AlignOnUpdate.never,
                    style: const LocationMarkerStyle(
                      marker: DefaultLocationMarker(color: Colors.blue),
                      showAccuracyCircle: true,
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton(
                  onPressed: _toggleGpsMode,
                  child: Icon(
                    mapMode == 1 ? Icons.gps_fixed : Icons.gps_not_fixed,
                  ),
                ),
              ),
            ],
          ),

          // Indicador de carga
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withAlpha(77), // Fondo semitransparente
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
