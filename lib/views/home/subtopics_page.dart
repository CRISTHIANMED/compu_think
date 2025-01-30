import 'package:compu_think/controllers/subtopic_controller.dart';
import 'package:compu_think/models/entities/subtopic_entity.dart';
import 'package:compu_think/utils/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class SubtopicsPage extends StatefulWidget {
  const SubtopicsPage({super.key});

  @override
  SubtopicsPageState createState() => SubtopicsPageState();
}

class SubtopicsPageState extends State<SubtopicsPage> {
  final SubtopicController _controller = SubtopicController();

  List<SubtopicEntity> _subtemas = [];
  bool _isLoading = true;
  String? _errorMessage;

  late int idUnidad;
  late int idPersona;
  late String nombre;
  late String descripcion;
  late String titulo;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadArguments();
    _fetchSubtemas();
  }

  // Cargar los argumentos de la navegación
  void _loadArguments() {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      idPersona = args['id_persona'] as int;
      idUnidad = args['id_unidad'] as int;
      nombre = args['nombre'] as String;
      descripcion = args['descripcion'] as String;
      titulo = args['tituloUnidad'];
    } else {
      idPersona = 0;
      idUnidad = 0;
      nombre = 'Nombre no disponible';
      descripcion = 'Descripción no disponible';
      titulo = 'Título no disponible';
    }
  }

  // Cargar los subtemas desde el controlador
  Future<void> _fetchSubtemas() async {
    try {
      final subtemas = await _controller.fetchTemasByUnidadId(idUnidad);
      if (mounted) {
        setState(() {
          _subtemas = subtemas;
          _isLoading = false;
          _errorMessage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error al cargar los subtemas: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text("Temas"),
          ],
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  )
                : _buildSubtopicsList(),
      ),
      
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 0),
    );
  }

  Widget _buildSubtopicsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          titulo,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          nombre,
          style: const TextStyle(fontSize: 18, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: _subtemas.length,
            itemBuilder: (context, index) {
              final subtema = _subtemas[index];
              return _buildSubtemaCard(subtema, context);
            },
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orangeAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            _navigateToRetosScreen(context, idPersona, idUnidad);
          },
          child: const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              "Retos",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubtemaCard(SubtopicEntity subtema, BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(
          subtema.titulo,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        /*subtitle: Text(
          "Orden: ${subtema.orden}",
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),*/
        onTap: () {
          _navigateToContentScreen(context, subtema);
        },
      ),
    );
  }

  void _navigateToContentScreen(BuildContext context, SubtopicEntity subtema) {
    Navigator.pushNamed(
      context,
      '/Contenido',
      arguments: {
        'idTema': subtema.id,
        'idUnidad': subtema.idUnidad,
        'titulo': subtema.titulo,
      },
    );
  }

  void _navigateToRetosScreen(BuildContext context, idPersona, idUnidad) {
    Navigator.pushNamed(
      context,
      '/retos',
      arguments: {
        'idPersona': idPersona,
        'idUnidad': idUnidad,
        'tituloUnidad': titulo
      }
    );
  }
}
