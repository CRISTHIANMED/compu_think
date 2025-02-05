// ignore_for_file: library_private_types_in_public_api

import 'package:compu_think/services/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<PostgrestResponse<List<Map<String, dynamic>>>> countUserComments(int idPersona, int idReto) async {
    final supabase = Supabase.instance.client;

  try {
    final count = await supabase
        .from('reto_comentario')
        .select()
        .eq('id_persona', idPersona)
        .eq('id_reto', idReto)
        .count();

    return count;

  } catch (e) {
    throw Exception("Error al contar comentarios: $e");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Supabase
  await SupabaseService.init();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supabase Test',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CommentCountScreen(idPersona: 1, idReto: 2),
    );
  }
}

class CommentCountScreen extends StatefulWidget {
  final int idPersona;
  final int idReto;

  const CommentCountScreen({super.key, required this.idPersona, required this.idReto});

  @override
  _CommentCountScreenState createState() => _CommentCountScreenState();
}

class _CommentCountScreenState extends State<CommentCountScreen> {
  late Future<int> _commentCount;

  @override
  Future<void> initState() async {
    super.initState();
    PostgrestResponse<List<Map<String, dynamic>>> _commentCount = await countUserComments(widget.idPersona, widget.idReto);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conteo de Comentarios')),
      body: Center(
        child: FutureBuilder<int>(
          future: _commentCount,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Text('Comentarios encontrados: ${snapshot.data}');
            }
          },
        ),
      ),
    );
  }
}