import 'package:compu_think/services/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  // Inicializa Supabase
    await SupabaseService.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PreguntasPage(),
    );
  }
}

class PreguntasPage extends StatefulWidget {
  @override
  _PreguntasPageState createState() => _PreguntasPageState();
}

class _PreguntasPageState extends State<PreguntasPage> {
  final SupabaseClient _supabase = Supabase.instance.client;
  late Future<List<Map<String, dynamic>>> _preguntas;

  @override
  void initState() {
    super.initState();
    // Realizar la consulta al cargar la página
    _preguntas = getPreguntasByTipoUnidad(1, 1); // Consulta con id_tipo_reto = 1 y id_unidad = 1
  }

  // Método para realizar la consulta
  Future<List<Map<String, dynamic>>> getPreguntasByTipoUnidad(int idTipoReto, int idUnidad) async {
    try {
      final response = await _supabase
          .from('reto_pregunta')
          .select('id, titulo, pregunta, url_imagen,' 
                  'reto_pregunta_opcion(id, descripcion, correcta, url_imagen),' 
                  'reto(id_unidad, id_tipo_reto)');

      List<Map<String, dynamic>> filteredPreguntas = response.where(
        (x) => (x["reto"]["id_unidad"] == idUnidad && x["reto"]["id_tipo_reto"] == idTipoReto)).toList();

      return List<Map<String, dynamic>>.from(filteredPreguntas);

    } catch (e) {
      throw Exception('No se pudieron cargar las preguntas: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preguntas del Reto'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _preguntas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No se encontraron preguntas'));
          }

          // Mostrar los resultados
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var pregunta = snapshot.data![index];
              return ListTile(
                title: Text(pregunta['titulo']),
                subtitle: Text(pregunta['pregunta']),
                leading: pregunta['url_imagen'] != null
                    ? Image.network(pregunta['url_imagen'])
                    : null,
              );
            },
          );
        },
      ),
    );
  }
}
