// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:compu_think/controllers/auth_controller.dart';
import 'package:compu_think/controllers/challenge_controller.dart';
import 'package:compu_think/controllers/unit_controller.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthController _authController = AuthController();
  final UnitController _unitController = UnitController();
  final ChallengeController _challengeController = ChallengeController();

  bool _obscureText = true;
  String _errorMessage = '';
  bool _isLoading = false; // Controla el estado de carga

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

    setState(() {
      _isLoading = true; // Muestra el indicador de carga
      _errorMessage = '';
    });

    try {
      bool success = await _authController.login(email, password);

      if (success) {
        await _authController.storeCredentials(email, password);
        if (!mounted) return;

        final prefs = await SharedPreferences.getInstance();
        final idString = prefs.getString('id');
        final int idPersona = idString != null ? int.parse(idString) : 0;

        final idsUnidades = await _unitController.fetchAllUnitIds();
        final idsRetos = await _challengeController.fetchAllChallengeIds();

        _unitController.initializeUserUnits(idPersona, idsUnidades, idsRetos);
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
    } finally {
      setState(() {
        _isLoading = false; // Oculta el indicador de carga
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
            if (_isLoading) ...[
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Iniciando sesión, por favor espere...'),
                    ],
                  ),
                ),
              )
            ] else ...[
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
          ],
        ),
      ),
    );
  }
}
