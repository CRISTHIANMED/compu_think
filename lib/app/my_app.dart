import 'package:compu_think/presentation/screens/login_screen.dart';
import 'package:compu_think/presentation/screens/logout_screen.dart';
import 'package:compu_think/presentation/screens/unit_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyApp extends StatelessWidget {
  const MyApp ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unidad',
      debugShowCheckedModeBanner: false,  // Desactiva el banner de depuración
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/Tema': (context) => const UnitScreen(),
        '/Salir': (context) => const LogoutScreen(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _future = Supabase.instance.client
    .from('persona')
    .select();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabla Unidad'),
      ),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final unidades = snapshot.data
                as List<dynamic>; // Los datos se devuelven como una lista
            return ListView.builder(
              itemCount: unidades.length,
              itemBuilder: (context, index) {
                final unidad = unidades[index];
                return ListTile(title: Text(unidad['nombre_1']));
              },
            );
          } else {
            return const Center(
              child: Text('No hay datos disponibles'),
            );
          }
        },
      ),
    );
  }
}
