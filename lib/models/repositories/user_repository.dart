import 'package:compu_think/models/entities/user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserRepository {

  // Obtener un usuario por email y contraseña
  Future<UserEntity?> getUserByEmailAndPassword(String email, String password) async {
    try {
      final response = await Supabase.instance.client
          .from('persona')
          .select()
          .eq('email', email)
          .single();

      if (response['contraseña'] == password) {
        return UserEntity.fromMap(response);
      } else {
        throw Exception('Contraseña incorrecta.');
      }
        } catch (e) {
      print('Error al obtener el usuario: $e');
      return null;
    }
  }

  /*// Enviar (crear) un nuevo usuario a la base de datos
  Future<bool> createUser(UserEntity user) async {
    try {
      final response = await Supabase.instance.client
          .from('persona')
          .insert(user.toMap());

      if (response.error == null) {
        return true;
      } else {
        print('Error al crear el usuario: ${response.error!.message}');
        return false;
      }
    } catch (e) {
      print('Error al crear el usuario: $e');
      return false;
    }
  }

  // Actualizar un usuario existente en la base de datos
  Future<bool> updateUser(UserEntity user) async {
    try {
      final response = await Supabase.instance.client
          .from('persona')
          .update(user.toMap())
          .eq('id', user.id);

      if (response.error == null) {
        return true;
      } else {
        print('Error al actualizar el usuario: ${response.error!.message}');
        return false;
      }
    } catch (e) {
      print('Error al actualizar el usuario: $e');
      return false;
    }
  }*/
}
