import 'package:compu_think/controllers/auth_controller.dart';
import 'package:compu_think/utils/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class LogoutPage extends StatefulWidget {
  const LogoutPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LogoutPageState createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  // Datos del usuario (puedes cargarlos dinámicamente desde un backend o localmente)
  String userName = "Cristhian Medina";
  String userEmail = "correo@ejemplo.com";
  final AuthController _authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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
    // Aquí puedes agregar la lógica para cerrar sesión (por ejemplo, eliminar tokens)
    await _authController.clearCredentials();
    Navigator.pushReplacementNamed(context, '/'); // Vuelve a la pantalla de inicio
  }
}
