import 'package:compu_think/services/supabase_service.dart';
import 'package:compu_think/app/my_app.dart';
import 'package:compu_think/app/my_app2.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.init();
  runApp(const MyApp());
}

