// ignore_for_file: use_build_context_synchronously

import 'package:compu_think/controllers/auth_controller.dart';
import 'package:compu_think/controllers/unit_controller.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthController _authController = AuthController();
  final UnitController _unitController = UnitController();


  bool _obscureText = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _checkStoredCredentials();
  }

  Future<void> _checkStoredCredentials() async {
    bool hasCredentials = await _authController.checkStoredCredentials();
    if (hasCredentials) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/Unidad');
    }
  }

  Future<void> _login() async {
    String email = _emailController.text.trim().toLowerCase();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, complete todos los campos.';
      });
      return;
    }

    try {
      bool success = await _authController.login(email, password);

      if (success) {
        await _authController.storeCredentials(email, password);
        if (!mounted) return;

        final prefs = await SharedPreferences.getInstance();
        final idString = prefs.getString('id'); // Recupera el valor como String
        final int idPersona = idString != null ? int.parse(idString) : 0; // Convierte a int o asigna 0 si es nulo

        final idsUnidades = await _unitController.fetchAllUnitIds();
        
        _unitController.initializeUserUnits(idPersona,idsUnidades);
        Navigator.pushReplacementNamed(context, '/Unidad');
      } else {
        setState(() {
          _errorMessage = 'Usuario o contraseña incorrectos.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Ocurrió un error al intentar iniciar sesión: $e';
      });
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
            Image.asset(
              'assets/images/logo2.png',
              height: 120,
            ),
            const SizedBox(height: 50),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Correo electrónico o Username',
                prefixIcon: const Icon(Icons.mail),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: _obscureText,
              autofillHints: const [],
              decoration: InputDecoration(
                labelText: 'Contraseña',
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Iniciar sesión'),
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
