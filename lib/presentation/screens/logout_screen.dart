import 'package:compu_think/core/widgets/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

class LogoutScreen extends StatefulWidget {
  const LogoutScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LogoutScreenState createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  // Datos del usuario (puedes cargarlos dinámicamente desde un backend o localmente)
  String userName = "Cristhian Medina";
  String userEmail = "correo@ejemplo.com";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Logout"),
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
  void _logout(BuildContext context) {
    // Aquí puedes agregar la lógica para cerrar sesión (por ejemplo, eliminar tokens)
    Navigator.pushReplacementNamed(context, '/'); // Vuelve a la pantalla de inicio
  }
}
