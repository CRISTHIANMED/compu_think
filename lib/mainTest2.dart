import 'package:compu_think/services/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SupabaseService.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final SupabaseServiceRepository supabaseServiceRepository =
      SupabaseServiceRepository();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Actualizar Supabase')),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              var r = await supabaseServiceRepository.actualizarFecha(
                  1, DateTime.now());
            },
            child: const Text('Actualizar Fecha'),
          ),
        ),
      ),
    );
  }
}

class SupabaseServiceRepository {
  final SupabaseClient supabase = Supabase.instance.client;
  dynamic response;

  /// Actualizar la fecha en la tabla 'respuesta' donde id = 1
  Future<List<Map<String, dynamic>>?> actualizarFecha(
      int id, DateTime nuevaFecha) async {
    try {
      final response2 = await supabase
          .from('respuesta')
          .select(
              'id_persona, id_reto_pregunta(id, id_reto(id_unidad, id_tipo_reto)), id_reto_pregunta_opcion')
          .eq('id_persona', 1);

      // Filtrar las preguntas que pertenecen a la unidad y al tipo de reto
      List<Map<String, dynamic>> filteredPreguntas = response2
          .where((x) => (x["id_reto_pregunta"]["id_reto"]["id_unidad"] == 1 &&
              x["id_reto_pregunta"]["id_reto"]["id_tipo_reto"] == 1))
          .toList();

      return filteredPreguntas;
    } catch (e) {
      print('Error al actualizar: $e');
    }
    return null;
  }
}
