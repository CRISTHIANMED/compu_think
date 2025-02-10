import 'package:compu_think/models/entities/georeference_entity.dart';
import 'package:compu_think/models/repositories/georeference_repository.dart';
import 'package:compu_think/services/supabase_service.dart';
import 'package:flutter/material.dart';


Future<void> main() async {
  await SupabaseService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GeoreferenceTestPage(),
    );
  }
}

class GeoreferenceTestPage extends StatefulWidget {
  const GeoreferenceTestPage({super.key});

  @override
  State<GeoreferenceTestPage> createState() => _GeoreferenceTestPageState();
}

class _GeoreferenceTestPageState extends State<GeoreferenceTestPage> {
  final GeoreferenceRepository _repository = GeoreferenceRepository();
  List<GeoreferenceEntity> _georeferencias = [];
  bool _isLoading = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetchGeoreferencias();
  }

  Future<void> _fetchGeoreferencias() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      List<GeoreferenceEntity> georeferencias = await _repository.getAllbyIdUnidad(1);
      setState(() {
        _georeferencias = georeferencias;
      });
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prueba de Georeferencias'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(child: Text(_error, style: const TextStyle(color: Colors.red)))
              : ListView.builder(
                  itemCount: _georeferencias.length,
                  itemBuilder: (context, index) {
                    final georef = _georeferencias[index];
                    return ListTile(
                      title: Text('ID: ${georef.id}'),
                      subtitle: Text('Lat: ${georef.latitud}, Lng: ${georef.longitud}'),
                      trailing: Text('Reto Pregunta ID: ${georef.idRetoPregunta}'),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchGeoreferencias,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}



