// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:compu_think/controllers/auth_controller.dart';
import 'package:compu_think/utils/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutPage extends StatefulWidget {
  const LogoutPage({super.key});

  @override
  _LogoutPageState createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  String userName = ""; // Nombre completo
  String userEmail = ""; // Correo electrónico
  final AuthController _authController = AuthController();

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Cargar datos del usuario al iniciar la página
  }

  // Método para cargar los datos del usuario desde SharedPreferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final nombre1 = prefs.getString('nombre1') ?? '';
    final nombre2 = prefs.getString('nombre2') ?? '';
    final apellido1 = prefs.getString('apellido1') ?? '';
    final apellido2 = prefs.getString('apellido2') ?? '';
    final email = prefs.getString('email') ?? '';

    // Construir el nombre completo y asignar el correo
    setState(() {
      userName = "$nombre1 $nombre2 $apellido1 $apellido2"
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();
      userEmail = email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Regresar a la pantalla anterior
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo en la parte superior
            Column(
              children: [
                Image.asset(
                  'assets/images/logo2.png', // Ruta del logo
                  height: 150,
                ),
                const SizedBox(height: 20),
              ],
            ),
            // Datos del usuario
            Column(
              children: [
                Text(
                  "Bienvenido, $userName",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  userEmail,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: 30),
            // Botón de cerrar sesión
            ElevatedButton(
              onPressed: () {
                // Acción para cerrar sesión
                _logout(context);
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Text("Cerrar sesión"),
            ),
          ],
        ),
      ),
      // Barra de navegación inferior
      bottomNavigationBar: const CustomBottomNavigationBar(
        currentIndex: 0,
      ),
    );
  }

  // Función para manejar la acción de cerrar sesión
  Future<void> _logout(BuildContext context) async {
    await _authController.clearCredentials();
    Navigator.pushReplacementNamed(
        context, '/'); // Vuelve a la pantalla de inicio
  }
}
