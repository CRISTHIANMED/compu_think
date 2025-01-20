import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  
  
  static Future<void> init() async {
    try {
      await dotenv.load(fileName: '.env');
      await Supabase.initialize(
        url: dotenv.env['SUPABASE_URL']!,
        anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
      );
      print('Supabase initialized successfully.');
    } catch (e) {
      // Captura cualquier error que ocurra durante la inicialización
      print('Error initializing Supabase: $e');
      // Puedes agregar más lógica de manejo de errores aquí, como mostrar un mensaje al usuario
    }
  }
}