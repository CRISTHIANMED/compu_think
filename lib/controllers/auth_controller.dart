import 'package:compu_think/models/entities/user_entity.dart';
import 'package:compu_think/models/repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  final UserRepository _userRepository = UserRepository();

  Future<bool> checkStoredCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? password = prefs.getString('password');

    // Retornar `true` si hay credenciales guardadas
    return email != null && password != null && email.isNotEmpty && password.isNotEmpty;
  }

  Future<void> storeCredentials(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  Future<bool> login(String input, String password) async {
    UserEntity? persona = await _userRepository.fetchUserByEmailOrUsername(input, password);
    return persona?.contrasena == password; 
  }

  Future<void> clearCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
  }
}
