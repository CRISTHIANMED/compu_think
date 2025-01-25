import 'package:compu_think/models/entities/type_state_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TypeEstateRepository {
  final supabase = Supabase.instance.client;

  // Método para obtener todos los registros de tipo_estado
  Future<List<TypeStateEntity>> fetchAllStates() async {
    try {
      final response = await supabase.from('tipo_estado').select();

      if (response.isEmpty) {
        return [];
      }

      return (response as List<dynamic>)
          .map((map) => TypeStateEntity.fromMap(map))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener los tipos de estado: $e');
    }
  }

  // Método para obtener un tipo_estado por su id
  Future<TypeStateEntity?> fetchStateById(int id) async {
    try {
      final response = await supabase
          .from('tipo_estado')
          .select()
          .eq('id', id)
          .single();

      return TypeStateEntity.fromMap(response);
    } catch (e) {
      throw Exception('Error al obtener el tipo de estado con id $id: $e');
    }
  }
}
