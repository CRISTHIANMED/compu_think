import 'package:compu_think/models/entities/unit_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UnitRepository {
  final supabase = Supabase.instance.client;

  // Método para obtener todas las unidades
  Future<List<UnitEntity>> fetchAll() async {
    try {
      // Realiza la consulta a la tabla 'unidad'
      final response = await supabase.from('unidad').select();

      // Verifica si la respuesta no está vacía
      if (response.isNotEmpty) {
        // Convierte la respuesta a una lista de objetos UnitEntity
        return response.map((map) => UnitEntity.fromMap(map)).toList();
      }
      // Si la respuesta está vacía, devuelve una lista vacía
      return [];
    } catch (e) {
      // Manejo de errores, si algo falla en la consulta o en el mapeo
      throw Exception(e);
    }
  }
}
