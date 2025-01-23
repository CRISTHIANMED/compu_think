import 'package:compu_think/models/entities/user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class AuthController {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<bool> signIn(String email, String password) async {
    final response = await supabase
        .from('persona')
        .select()
        .eq('email', email);

    if (response.isEmpty) {
      throw Exception('Usuario no encontrado');
    }

    final List data = response;
    if (data.isNotEmpty) {
      //final UserEntity persona = UserEntity.fromMap(data[0]);
      String dato = data[0]['contrasena'];
      // Compara la contraseña
      if (data[0]['contrasena'] == password) {
        return true;
      }
    }

    return false;
  }
}
