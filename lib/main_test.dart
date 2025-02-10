import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Map Quiz',
      home: MapScreen(),
    );
  }
}

class Question {
  final int id;
  final String title;
  final String questionText;
  final String? imageUrl;
  final List<Option> options;

  Question({
    required this.id,
    required this.title,
    required this.questionText,
    this.imageUrl,
    required this.options,
  });

  Option? getCorrectOption() {
    return options.firstWhere(
      (option) => option.isCorrect,
      orElse: () =>
          Option(id: -1, description: "", isCorrect: false, imageUrl: ''),
    );
  }
}

class Option {
  final int id;
  final String description;
  final bool isCorrect;
  final String? imageUrl;

  Option({
    required this.id,
    required this.description,
    required this.isCorrect,
    this.imageUrl,
  });
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng currentLocation = const LatLng(1.2136, -77.2811);
  late final MapController _mapController;
  int mapMode = 1; // 1: gps_fixed, 3: gps_not_fixed

  bool alignOnUpdate = false;
  bool alignDirection = false;
  Option? selectedOption;

  List<Question> questions = [
    Question(
      id: 1,
      title: "Historia de Pasto",
      questionText:
          "¿Qué representa la etapa de entrada en un sistema de procesamiento de información?",
      options: [
        Option(
            id: 1,
            description: "La generación automática de resultados.",
            isCorrect: true),
        Option(
            id: 2,
            description:
                "La transformación de datos mediante cálculos y operaciones.",
            isCorrect: false),
        Option(
            id: 3,
            description: "La recolección de datos iniciales que se procesarán",
            isCorrect: false),
      ],
    ),
    Question(
      id: 2,
      title: "Geografía",
      questionText: "¿Cuál es la altitud aproximada de Pasto?",
      options: [
        Option(id: 1, description: "2500 m", isCorrect: false),
        Option(id: 2, description: "2900 m", isCorrect: true),
        Option(id: 3, description: "3200 m", isCorrect: false),
      ],
    ),
  ];

  List<LatLng> questionLocations = [
    const LatLng(1.214, -77.281),
    const LatLng(1.210, -77.280),
  ];

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _checkPermissions();
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

  void _setMode1() async {
    Position position = await Geolocator.getCurrentPosition();
    LatLng newLocation = LatLng(position.latitude, position.longitude);
    setState(() {
      mapMode = 1;
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(question.title,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(question.questionText),
                  const SizedBox(height: 10),
                  ...question.options.map((option) {
                    return RadioListTile<Option>(
                      title: Text(option.description),
                      value: option,
                      groupValue: selectedOption,
                      onChanged: (Option? value) {
                        setState(() {
                          selectedOption = value;
                        });
                      },
                    );
                  }),
                  ElevatedButton(
                    onPressed: selectedOption == null
                        ? null
                        : () {
                            Navigator.pop(context);
                            _showAnswerDialog(selectedOption!.isCorrect);
                          },
                    child: const Text("Enviar Respuesta"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showAnswerDialog(bool isCorrect) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isCorrect ? "Correcto!" : "Incorrecto"),
          content: Text(isCorrect ? "¡Bien hecho!" : "Intenta de nuevo."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cerrar"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mapa de Preguntas")),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(1.2136, -77.2811),
              initialZoom: 18.0,
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
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                //urlTemplate: "https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png",
                //subdomains: const ['a', 'b', 'c'],
                retinaMode: RetinaMode.isHighDensity(context), // Habilita Retina si la pantalla lo necesita
              ),
              MarkerLayer(
                markers: [
                  ...List.generate(questions.length, (index) {
                    return Marker(
                      width: 40.0,
                      height: 40.0,
                      point: questionLocations[index],
                      child: GestureDetector(
                        onTap: () => _showQuestionDialog(questions[index]),
                        child: const Icon(Icons.location_on_rounded,
                            color: Colors.red, size: 50),
                      ),
                    );
                  }),
                ],
              ),
              CurrentLocationLayer(
                positionStream: _positionStream(),
                alignPositionOnUpdate:
                    mapMode == 1 ? AlignOnUpdate.always : AlignOnUpdate.never,
                alignDirectionOnUpdate:
                    AlignOnUpdate.never, // No forzar alineación de dirección
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
    );
  }
}
