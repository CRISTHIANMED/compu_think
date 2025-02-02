// ignore_for_file: library_private_types_in_public_api

import 'package:compu_think/services/supabase_service.dart';
import 'package:compu_think/utils/helper/convert_google_drive_link.dart';
import 'package:compu_think/views/home/challenges_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Question {
  final int id;
  final String title;
  final String questionText;
  final String? imageUrl; // La imagen de la pregunta puede ser null
  final List<Option> options;

  Question({
    required this.id,
    required this.title,
    required this.questionText,
    this.imageUrl, // La imagen de la pregunta es opcional
    required this.options,
  });

  // Método para obtener la opción correcta
  Option? getCorrectOption() {
    return options.firstWhere((option) => option.isCorrect,
        orElse: () =>
            Option(id: -1, description: "", isCorrect: false, imageUrl: ''));
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
    required this.imageUrl,
  });
}

// Simulamos algunas preguntas y opciones
List<Question> questions = [
  Question(
    id: 1,
    title: "Pregunta 1",
    questionText: "¿Cuál es la capital de Francia?",
    imageUrl:
        "https://drive.google.com/file/d/1MDwev-bmO3xk2998q846RqNPnCPhHiPf/view?usp=sharing",
    options: [
      Option(
          id: 1,
          description: "París",
          isCorrect: true,
          imageUrl:
              "https://drive.google.com/file/d/1MDwev-bmO3xk2998q846RqNPnCPhHiPf/view?usp=sharing"),
      Option(
          id: 2,
          description: "Londres",
          isCorrect: false,
          imageUrl:
              "https://drive.google.com/file/d/1MDwev-bmO3xk2998q846RqNPnCPhHiPf/view?usp=sharing"),
      Option(
          id: 3,
          description: "Madrid",
          isCorrect: false,
          imageUrl:
              "https://drive.google.com/file/d/1MDwev-bmO3xk2998q846RqNPnCPhHiPf/view?usp=sharing"),
    ],
  ),
  Question(
    id: 2,
    title: "Pregunta 2",
    questionText:
        "Para formular preguntas abiertas, se pueden considerar los siguientes aspectos: ¿Qué sugerencias tienes, ¿Qué comentarios tienes, ¿Qué ideas tienes, ¿Qué recomendaciones tienes, ¿Qué retroalimentación tienes. ",
    imageUrl:
        "https://drive.google.com/file/d/1MDwev-bmO3xk2998q846RqNPnCPhHiPf/view?usp=sharing",
    options: [
      Option(id: 4, description: "Asia", isCorrect: false, imageUrl: null),
      Option(id: 5, description: "Oceanía", isCorrect: true, imageUrl: null),
      Option(id: 6, description: "Europa", isCorrect: false, imageUrl: null),
    ],
  ),
  Question(
    id: 3,
    title: "Pregunta 3",
    questionText: "¿Qué continente está Australia?",
    imageUrl: null,
    options: [
      Option(
          id: 7,
          description:
              "Para formular preguntas abiertas, se pueden considerar los siguientes aspectos: ¿Qué sugerencias tienes, ¿Qué comentarios tienes, ¿Qué ideas tienes, ¿Qué recomendaciones tienes, ¿Qué retroalimentación tienes. ",
          isCorrect: false,
          imageUrl: null),
      Option(id: 8, description: "Oceanía", isCorrect: true, imageUrl: null),
      Option(id: 9, description: "Europa", isCorrect: false, imageUrl: null),
    ],
  ),
];

class QuestionPage2 extends StatefulWidget {
  const QuestionPage2({super.key});


  @override
  _QuestionPage2State createState() => _QuestionPage2State();
}

class _QuestionPage2State extends State<QuestionPage2> {
  Map<int, int?> selectedAnswers = {};

  late ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _loadAnswers();
  }

  

  Future<void> _loadAnswers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      for (var question in questions) {
        selectedAnswers[question.id] = prefs.getInt('answer_${question.id}');
      }
    });
  }

  Future<void> _saveAnswer(int questionId, int optionId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('answer_$questionId', optionId);
  }

  double calculatePercentage() {
    int correctAnswers = 0;
    for (var question in questions) {
      if (selectedAnswers[question.id] != null) {
        final selectedOptionId = selectedAnswers[question.id]!;
        final correctOption = question.getCorrectOption();
        if (correctOption?.id == selectedOptionId) {
          correctAnswers++;
        }
      }
    }
    return (correctAnswers / questions.length) * 100;
  }

  bool areAllQuestionsAnswered() {
    return questions.every((question) => selectedAnswers[question.id] != null);
  }

  void showResult() {
    if (!areAllQuestionsAnswered()) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Por favor responde todas las preguntas.")));
      return;
    }

    final percentage = calculatePercentage();

    final correctAnswers = questions.where((question) {
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
              Text("$correctAnswers/${questions.length} preguntas acertadas."),
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
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const ChallengePage()), // Reemplaza con tu widget
                );
                //Navigator.pop(context); // Cierra el cuadro de diálogo
                //Navigator.pop(context); // Regresa a la pantalla anterior (retos)
              },
              child: const Text("Continuar"),
            ),
          ],
        );
      },
    );
  }

  void _confirmExit(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("¿Salir sin enviar?"),
          content: const Text(
              "Si sales ahora, tus respuestas no se guardarán. ¿Estás seguro?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Cierra el diálogo
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Cierra el diálogo
                Navigator.pop(context); // Regresa a la pantalla anterior
              },
              child: const Text("Salir"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildImage(String url) {
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
        title: const Text("Preguntas del reto"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _confirmExit(context);
          },
        ),
      ),
      body: ListView.builder(
        controller: _scrollController, // Asignar el ScrollController
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final question = questions[index];
          return Card(
            color: const Color.fromARGB(255, 189, 219, 243),
            margin: const EdgeInsets.all(25),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question.title,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    question.questionText,
                    textAlign: TextAlign.justify,
                    softWrap:
                        true, // Permite que el texto se divida en varias líneas
                  ),
                  if (question.imageUrl != null) ...[
                    const SizedBox(height: 8),
                    //Image.network(question.imageUrl!),
                    _buildImage(question.imageUrl!),
                  ],
                  const SizedBox(height: 8),
                  ...question.options.map(
                    (option) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Radio<int>(
                                value: option.id,
                                groupValue: selectedAnswers[question.id],
                                onChanged: (value) {
                                  double currentScroll =
                                      _scrollController.position.pixels;
                                  setState(() {
                                    selectedAnswers[question.id] = value;
                                  });
                                  _saveAnswer(question.id, value!);
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    _scrollController.jumpTo(currentScroll);
                                  });
                                },
                              ),
                              //Text(option.description),
                              Expanded(
                                // <-- Permite que el texto se ajuste al espacio disponible
                                child: Text(
                                  option.description,
                                  textAlign: TextAlign.justify,
                                  softWrap:
                                      true, // Permite que el texto se divida en varias líneas
                                ),
                              ),
                            ],
                          ),
                          if (option.imageUrl != null) ...[
                            const SizedBox(height: 8),
                            //Image.network(option.imageUrl!, width: 100, height: 100),
                            _buildImage(option.imageUrl!),
                          ],
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: showResult,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Colors.orangeAccent,
          ),
          child: const Text(
            "Enviar respuestas",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

Future<void> main() async {
  await SupabaseService.init();
  runApp(MaterialApp(home: QuestionPage2()));
}
