// ignore_for_file: avoid_print

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseService {
  static SupabaseClient? _supabaseClient;

  // Inicializa Supabase
  static Future<void> init() async {
    try {
      // Carga las variables del archivo .env
      await dotenv.load(fileName: '.env');

      // Inicializa Supabase con la URL y la ANON_KEY desde el archivo .env
      await Supabase.initialize(
        url: dotenv.env['SUPABASE_URL']!,
        anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
      );

      // Asigna el cliente inicializado a _supabaseClient
      _supabaseClient = Supabase.instance.client;

      // Mensaje de éxito
      print('Supabase initialized successfully.');
    } catch (e) {
      // Captura cualquier error durante la inicialización
      print('Error initializing Supabase: $e');
    }
  }

  // Devuelve el cliente de Supabase
  static SupabaseClient get client {
    if (_supabaseClient == null) {
      throw Exception('SupabaseClient has not been initialized.');
    }
    return _supabaseClient!;
  }
}
