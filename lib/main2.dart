import 'package:compu_think/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
    await SupabaseService.init();

  final SupabaseClient client = Supabase.instance.client;
  final int idTipoReto = 3; // Cambia el valor según lo necesario
  final int idUnidad = 1;   // Cambia el valor según lo necesario
  
  try {
    final response = await client
        .from('georeferencia')
        .select('id, latitud, longitud, id_reto_pregunta(id, id_reto(id_unidad, id_tipo_reto))')
        .order('id', ascending: true);

    // Filtrar los datos por idTipoReto
    List<Map<String, dynamic>> filteredPreguntas = response
        .where((x) => (x["id_reto_pregunta"]["id_reto"]["id_unidad"] == idUnidad))
        .toList();

    print("Datos obtenidos: $filteredPreguntas");

    if (filteredPreguntas.isEmpty) {
      print("No se encontraron registros con idTipoReto = $idTipoReto");
    } else {
      for (var item in filteredPreguntas) {
        print("ID: ${item['id']}, Latitud: ${item['latitud']}, Longitud: ${item['longitud']}");
      }
    }
  } catch (e) {
    print("Error al obtener datos: $e");
  }
}
