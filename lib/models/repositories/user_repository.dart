// ignore_for_file: avoid_print

import 'package:compu_think/models/entities/user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserRepository {
  final supabase = Supabase.instance.client;

  Future<List<UserEntity>> fetchAllUsers() async {
    try {
      final response = await supabase
        .from('persona')
        .select();

      return response.map((data) => UserEntity.fromMap(data)).toList();
      
    } catch (e) {
      throw Exception("Error al obtener usuarios: $e");
    }
  }

  Future<UserEntity?> fetchUserByEmailOrUsername(
      String input, String contrasena) async {
    try {
      // Realiza la consulta en la tabla 'persona'
      final response = await supabase
          .from('persona')
          .select()
          .or('name_user.eq.$input, email.eq.$input');

      // Verifica si no se encuentra el usuario
      if (response.isEmpty) {
        throw Exception('Usuario no encontrado');
      }
      
      // Si la respuesta no está vacía, obtiene el primer usuario
      if (response.isNotEmpty) {
        final UserEntity persona = UserEntity.fromMap(response[0]);
        return persona;
      }
      return null;
      
    } catch (e) {
      // Manejo de errores, si algo falla en la consulta o el proceso
      throw Exception(e);
    }
  }
   
}
