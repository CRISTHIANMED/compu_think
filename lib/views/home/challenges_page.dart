import 'package:compu_think/utils/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:compu_think/views/home/contents_page.dart';

class ChallengePage extends StatefulWidget {
  const ChallengePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChallengePageState createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  final int _currentIndex = 0; // Índice de la barra de navegación

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Retos de la Unidad 1"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Regresar a la pantalla anterior
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Retos de la Unidad 1",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Lista de retos
            Expanded(
              child: ListView.builder(
                itemCount: 3, // Tres retos
                itemBuilder: (context, index) {
                  return _buildRetoCard(context, index);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
      ),
    );
  }

  // Método para construir los cuadros de texto con los retos
  Widget _buildRetoCard(BuildContext context, int index) {
    String retoNombre = '';
    String retoDescripcion = '';
    String retoPdfUrl = '';

    // Asignación de nombres, descripciones y enlaces para cada reto
    switch (index) {
      case 0:
        retoNombre = 'Reto 1: Test';
        retoDescripcion = 'Un reto en el que pondrás a prueba tus conocimientos mediante un test interactivo.';
        retoPdfUrl = 'https://example.com/reto1_test.pdf'; // Enlace al PDF del reto 1
        break;
      case 1:
        retoNombre = 'Reto 2: Debate';
        retoDescripcion = 'Participa en un debate sobre temas relevantes y presenta tus argumentos de manera clara.';
        retoPdfUrl = 'https://example.com/reto2_debate.pdf'; // Enlace al PDF del reto 2
        break;
      case 2:
        retoNombre = 'Reto 3: Juego';
        retoDescripcion = 'Completa un juego interactivo basado en los conceptos de la unidad.';
        retoPdfUrl = 'https://example.com/reto3_juego.pdf'; // Enlace al PDF del reto 3
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 20),
          backgroundColor: Colors.orangeAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          //_navigateToContentScreen(context, retoNombre, retoDescripcion, retoPdfUrl);
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                retoNombre,
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                retoDescripcion,
                style: const TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para navegar a la pantalla de contenido
  /*void _navigateToContentScreen(
      BuildContext context, String nombreReto, String descripcionReto, String pdfUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContentsPage(
          unidadTitulo: "Unidad 1",
          subtemaNombre: nombreReto, // Nombre del reto
        ),
      ),
    );
  }*/
}
