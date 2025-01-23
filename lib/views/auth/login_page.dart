import 'package:compu_think/controllers/auth_controller.dart';
import 'package:compu_think/models/repositories/user_repository.dart';
import 'package:compu_think/services/supabase_service.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthController _authController = AuthController();

  bool _obscureText = true; // Controla si la contraseña es visible o no
  String _errorMessage = '';

  Future<void> _login() async {
    try {
      bool success = await _authController.signIn(
        _emailController.text,
        _passwordController.text,
      );

      if (success) {
        Navigator.pushReplacementNamed(context, '/Unidad');
      } else {
        // Mostrar error si el inicio de sesión falla
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Correo electrónico o contraseña incorrectos')),
        );
      }
    } catch (e) {
      // Mostrar error si hay algún problema con la consulta
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Imagen en la parte superior
            Image.asset(
              'assets/images/logo2.png', // Reemplaza con la ruta de tu imagen
              height: 120, // Ajusta la altura según lo necesites
            ),

            const SizedBox(height: 50), // Espacio después de la imagen

            // Campo de correo electrónico
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Correo electrónico o Username',
                prefixIcon: const Icon(Icons.mail), // Ícono de carta
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(30), // Bordes más redondeados
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Campo de contraseña con ícono y habilitador para ver contraseña
            TextField(
              controller: _passwordController,
              obscureText: _obscureText,
              autofillHints: const [], // Deshabilita el autocompletado
              decoration: InputDecoration(
                labelText: 'Contraseña',
                prefixIcon: const Icon(Icons.lock), // Ícono de candado
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText; // Cambia la visibilidad
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(30), // Bordes más redondeados
                ),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed:  _login,
              child: const Text('Iniciar sesión'),
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}