import 'package:compu_think/utils/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:compu_think/views/home/contents_page.dart';
import 'package:compu_think/views/home/challenges_page.dart';  // Asegúrate de importar RetosScreen

List<Map<String, dynamic>> subtemasData = [
  {
    "id": 1,
    "nombre": "Introducción a Flutter",
    "descripcion":
        "Conceptos básicos de Flutter, estructuras, y widgets principales."
  },
  {
    "id": 2,
    "nombre": "Estructuras de Datos",
    "descripcion":
        "Estudio de estructuras de datos como listas, pilas, colas, árboles, y más."
  },
  {
    "id": 3,
    "nombre": "Desarrollo Web con Dart",
    "descripcion":
        "Introducción a Dart y su uso para desarrollar aplicaciones web."
  },
];

class SubtopicsPage extends StatefulWidget {
  const SubtopicsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SubtopicsPageState createState() => _SubtopicsPageState();
}

class _SubtopicsPageState extends State<SubtopicsPage> {
  final int _currentIndex = 0;
  late List<Subtema> _subtemas;

  @override
  void initState() {
    super.initState();
    _subtemas = _parseJsonData(subtemasData);
  }

  List<Subtema> _parseJsonData(List<Map<String, dynamic>> data) {
    return data.map((json) => Subtema.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Unidad 1"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/Unidad');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Unidad 1",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              "Introducción al Tema",
              style: TextStyle(fontSize: 22, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            Expanded(
              child: ListView.builder(
                itemCount: _subtemas.length,
                itemBuilder: (context, index) {
                  final subtema = _subtemas[index];
                  return _buildSubtemaCard(subtema, context);
                },
              ),
            ),
            
            // Botón "Retos" al final de la lista de subtemas
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  backgroundColor: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  _navigateToRetosScreen(context); // Navegar a la página de retos
                },
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    "Retos",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
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

  Widget _buildSubtemaCard(Subtema subtema, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 20),
          backgroundColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          _navigateToContentScreen(context, subtema);
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subtema.nombre,
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                subtema.descripcion,
                style: const TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToContentScreen(BuildContext context, Subtema subtema) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContentsPage(
          unidadTitulo: "Unidad 1",
          subtemaNombre: subtema.nombre,
          pdfUrl: "https://departamento.us.es/edan/php/asig/LICFIS/LFIPC/Tema2FISPC0809.pdf",
        ),
      ),
    );
  }

  // Método para navegar a la pantalla de retos
  void _navigateToRetosScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChallengePage(),
      ),
    );
  }
}

class Subtema {
  final int id;
  final String nombre;
  final String descripcion;

  Subtema({required this.id, required this.nombre, required this.descripcion});

  factory Subtema.fromJson(Map<String, dynamic> json) {
    return Subtema(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
    );
  }
}
