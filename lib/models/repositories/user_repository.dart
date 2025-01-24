import 'package:compu_think/models/entities/user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class UserRepository {

  final SupabaseClient supabase = Supabase.instance.client;

  Future<UserEntity?> fetchUserByEmailOrUsername(String input, String contrasena) async {
    final response = await supabase
      .from('persona')
      .select()
      .or('name_user.eq.$input, email.eq.$input');

    if (response.isEmpty) {
      throw Exception('Usuario no encontrado');
    }

    if (response.isNotEmpty) {
      final UserEntity persona = UserEntity.fromMap(response[0]);
      // Compara la contraseña
      if (persona.contrasena == contrasena) {
        return persona;
      }
    }
    return null;
  }

}
