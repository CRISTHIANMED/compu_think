import 'package:compu_think/models/entities/unit_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UnitRepository {
  final supabase = Supabase.instance.client;

  // Método para obtener todas las unidades
  Future<List<UnitEntity>> fetchAll() async {
    try {
      // Realiza la consulta a la tabla 'unidad'
      final response = await supabase
          .from('unidad')
          .select()
          .order('orden', ascending: true); 

      if (response.isEmpty) {
        return [];
      }

      return response
        .map((map) => UnitEntity.fromMap(map))
        .toList();

    } catch (e) {
      // Manejo de errores, si algo falla en la consulta o en el mapeo
      throw Exception(e);
    }
  }

  // Método para obtener solo los IDs de todas las unidades, ordenados por 'orden'
  Future<List<int>> fetchAllUnitIds() async {
    try {
      // Realiza la consulta a la tabla 'unidad' y selecciona solo el campo 'id'
      final response = await supabase
          .from('unidad')
          .select('id')
          .order('orden', ascending: true); 

      if (response.isEmpty) {
        return [];
      }

      // Mapea los resultados y devuelve solo los IDs como una lista de enteros
      return (response as List)
          .map((map) => map['id'] as int)
          .toList();

    } catch (e) {
      // Manejo de errores
      throw Exception('Error al obtener los IDs de las unidades: $e');
    }
  }

  /// Obtiene una unidad específica por su ID
  Future<UnitEntity?> fetchUnitById(int id) async {
    try {
      final response = await supabase
        .from('unidad')
        .select()
        .eq('id', id)
        .single();

      return UnitEntity.fromMap(response);
      
    } catch (e) {
      throw Exception('Error al obtener la unidad con id $id: $e');
    }
  }
}
