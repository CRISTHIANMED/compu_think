// ignore_for_file: library_private_types_in_public_api

import 'package:compu_think/controllers/questions_controller.dart';
import 'package:compu_think/models/entities/question_options_entity.dart';
import 'package:compu_think/utils/helper/convert_google_drive_link.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestionPage extends StatefulWidget {
  final int idUnidad; // Define la propiedad que almacenará el idUnidad
  const QuestionPage(this.idUnidad, {super.key});

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  Map<int, int?> selectedAnswers = {};
  List<Question> _questions = [];
  bool _isLoading = true;
  String? _errorMessage;

  final QuestionController _questionController = QuestionController();
  late ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    fetchQuestions(1, widget.idUnidad);
    //_loadAnswers();
  }

  Future<void> fetchQuestions(idTipoReto, idUnidad) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final idString = prefs.getString('id');
      final int idPersona = idString != null ? int.parse(idString) : 0;

      final questions =
          await _questionController.fetchQuestions(idTipoReto, idUnidad);
      if (mounted) {
        setState(() {
          _questions = questions;
          _isLoading = false;
          _errorMessage = null;
          for (var question in _questions) {
            selectedAnswers[question.id] =
                prefs.getInt('answer_${question.id}');
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

  Future<void> _saveAnswer(int questionId, int optionId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('answer_$questionId', optionId);
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

  void showResult() {
    if (!areAllQuestionsAnswered()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Por favor responde todas las preguntas.")));
      return;
    }

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
              onPressed: () {
                Navigator.pop(context); // Cierra el cuadro de diálogo
                Navigator.pop(
                    context); // Regresa a la pantalla anterior (retos)
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
        title: const Text("Preguntas del reto"),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _confirmExit(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 15),
            if (_isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_errorMessage != null)
              Text('Error: $_errorMessage',
                  style: const TextStyle(color: Colors.red))
            else
              Expanded(
                child: ListView.builder(
                  controller: _scrollController, // Asignar el ScrollController
                  itemCount: _questions.length,
                  itemBuilder: (context, index) {
                    final question = _questions[index];
                    return Card(
                      color: const Color.fromARGB(255, 189, 219, 243),
                      margin: const EdgeInsets.all(20),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              //question.title
                              'Pregunta ${index + 1}',
                              textAlign: TextAlign.justify,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
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
                                          groupValue:
                                              selectedAnswers[question.id],
                                          onChanged: (value) {
                                            double currentScroll =
                                                _scrollController
                                                    .position.pixels;
                                            setState(() {
                                              selectedAnswers[question.id] =
                                                  value;
                                            });
                                            _saveAnswer(question.id, value!);
                                            WidgetsBinding.instance
                                                .addPostFrameCallback((_) {
                                              _scrollController
                                                  .jumpTo(currentScroll);
                                            });
                                          },
                                        ),
                                        //Text(option.description),
                                        Expanded(
                                          // <-- Permite que el texto se ajuste al espacio disponible
                                          child: Text(
                                            option.description,
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
              ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            showResult;
          },
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
