import 'package:compu_think/app/my_app.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await AppConfig.init();
  runApp(const MyApp());
}

