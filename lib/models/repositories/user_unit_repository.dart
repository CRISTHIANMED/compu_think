import 'package:compu_think/models/entities/user_unit_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserUnitRepository {
  final supabase = Supabase.instance.client;

  /// Obtiene todos los registros de la tabla 'user_unit'
  Future<List<UserUnitEntity>> fetchAllUserUnits() async {
    try {
      final response = await supabase.from('user_unit').select();

      if (response.isEmpty) {
        return [];
      }

      return (response as List<dynamic>)
          .map((userUnit) => UserUnitEntity.fromMap(userUnit))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener los registros de user_unit: $e');
    }
  }

  /// Obtiene los registros de 'user_unit' por el ID de la persona
  Future<List<UserUnitEntity>> fetchUserUnitsByPersonaId(int idPersona) async {
    try {
      final response = await supabase
          .from('persona_unidad')
          .select()
          .eq('id_persona', idPersona);

      if (response.isEmpty) {
        return [];
      }

      return (response as List<dynamic>)
          .map((userUnit) => UserUnitEntity.fromMap(userUnit))
          .toList();
    } catch (e) {
      throw Exception('Error al obtener registros para la persona con id $idPersona: $e');
    }
  }

  /// Inserta un nuevo registro en la tabla 'persona_unidad'
  Future<void> insertUserUnit(List<Map<String, dynamic>> list) async {
    try {
      await supabase.from('persona_unidad').insert(list);

    } catch (e) {
      throw Exception('Error al insertar el registro en user_unit: $e');
    }
  }


  /// Actualiza un registro existente en 'persona_unidad'
  /*Future<void> updateUserUnit(UserUnitEntity userUnit) async {
    try {
      await supabase
          .from('persona_unidad')
          .update(userUnit.toMap())
          .eq('id', userUnit.id);
    } catch (e) {
      throw Exception('Error al actualizar el registro con id ${userUnit.id}: $e');
    }
  }*/

  /// Elimina un registro de 'user_unit' por su ID
  Future<void> deleteUserUnit(int id) async {
    try {
      await supabase.from('persona_unidad').delete().eq('id', id);
    } catch (e) {
      throw Exception('Error al eliminar el registro con id $id: $e');
    }
  }
}
