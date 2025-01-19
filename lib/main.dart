import 'package:compu_think/app/my_app.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://kctngztqqdikslkimirb.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtjdG5nenRxcWRpa3Nsa2ltaXJiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzY1MjgwMjMsImV4cCI6MjA1MjEwNDAyM30.3YZGUoCIGHtpUGQtBO0nIUq_KQWlF9ck5mS30sKtyxA',
  );
  runApp(const MyApp());
}

