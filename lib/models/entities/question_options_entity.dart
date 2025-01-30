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
    this.imageUrl,
  });
}
