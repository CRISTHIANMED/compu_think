import 'package:compu_think/models/entities/user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserRepository {
  final SupabaseClient supabase;

  UserRepository(this.supabase);

  Future<UserEntity?> validateUser(String email, String password) async {
    final response = await supabase
        .from('persona')
        .select()
        .eq('email', email)
        .eq('contrasena', password)
        .single();

    if (response.isEmpty) {
      return UserEntity.fromMap(response);
    }
    return null; // Usuario no encontrado o contraseña incorrecta
  }
}
