import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true; // Controla si la contraseña es visible o no

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
              onPressed:  () {
                Navigator.pushReplacementNamed
                (context, '/Tema'); // Navega a la ruta /tema
              },
              child: const Text('Iniciar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
