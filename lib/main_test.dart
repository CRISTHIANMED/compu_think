import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
  LatLng currentLocation = const LatLng(1.2136, -77.2811); // Pasto, Nariño
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
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
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
                      style:
                          const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                            _showAnswerDialog(
                                selectedOption!.isCorrect, question);
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

  void _showAnswerDialog(bool isCorrect, Question question) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isCorrect ? "¡Correcto!" : "Incorrecto"),
          content: Text(isCorrect ? "¡Bien hecho!" : "Intenta de nuevo."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cerrar"),
            ),
            if (!isCorrect)
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Cierra el diálogo de respuesta
                  _showQuestionDialog(question); // Vuelve a mostrar la pregunta
                },
                child: const Text("Intentar de nuevo"),
              ),
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
            options: MapOptions(
              initialCenter: currentLocation,
              initialZoom: 15.0,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
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
                        child: const Icon(Icons.location_on,
                            color: Colors.red, size: 40),
                      ),
                    );
                  }),
                  Marker(
                    width: 40.0,
                    height: 40.0,
                    point: currentLocation,
                    child: const Icon(Icons.person_pin_circle,
                        color: Colors.blue, size: 40),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: _determinePosition,
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}
