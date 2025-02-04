// ignore_for_file: avoid_print

import 'package:compu_think/models/repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  final UserRepository _userRepository = UserRepository();

  // Verifica si hay credenciales almacenadas
  Future<bool> checkStoredCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email');
      final password = prefs.getString('password');

      // Retornar true si las credenciales son válidas
      return email != null && password != null && email.isNotEmpty && password.isNotEmpty;
    } catch (e) {
      // Manejo de error
      print('Error al verificar credenciales: $e');
      return false;
    }
  }

  // Almacena las credenciales y datos del usuario
  Future<void> storeCredentials(String input, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final persona = await _userRepository.fetchUserByEmailOrUsername(input, password);

      if (persona != null) {
        // Almacenar los valores de forma segura
        final dataToStore = {
          'email': persona.email,
          'password': persona.contrasena,
          'id': persona.id.toString(),
          'nombre1': persona.nombre1,
          'nombre2': persona.nombre2 ?? '',
          'apellido1': persona.apellido1 ?? '',
          'apellido2': persona.apellido2 ?? '',
          'rol': persona.rol,
          'nUsuario': persona.nombreU ?? '',
        };

        for (var entry in dataToStore.entries) {
          await prefs.setString(entry.key, entry.value);
        }
      }
    } catch (e) {
      // Manejo de error
      print('Error al almacenar credenciales: $e');
    }
  }

  // Maneja el inicio de sesión verificando las credenciales
  Future<bool> login(String input, String password) async {
    try {
      final persona = await _userRepository.fetchUserByEmailOrUsername(input, password);
      return persona?.contrasena == password;
    } catch (e) {
      // Manejo de error
      print('Error en el inicio de sesión: $e');
      return false;
    }
  }

  // Borra las credenciales almacenadas
  Future<void> clearCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // Limpia todas las preferencias almacenadas
    } catch (e) {
      // Manejo de error
      print('Error al limpiar credenciales: $e');
    }
  }
}
