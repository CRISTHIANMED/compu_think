
import 'package:compu_think/views/auth/login_page.dart';
import 'package:compu_think/views/auth/logout_page.dart';
import 'package:compu_think/views/home/challenges_page.dart';
import 'package:compu_think/views/home/contents_page.dart';
import 'package:compu_think/views/home/subtopics_page.dart';
import 'package:compu_think/views/home/units_page.dart';
import 'package:flutter/material.dart';


class MyApp extends StatelessWidget {
  const MyApp ({super.key});

  @override
  Widget build(BuildContext context) {
 
    return MaterialApp(
      title: 'Unidad',
      debugShowCheckedModeBanner: false,  // Desactiva el banner de depuración
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/Unidad': (context) => const UnitsPage(),
        '/Tema': (context) => const SubtopicsPage(),
        '/Contenido':  (context) => const ContentsPage(),
        '/Salir': (context) => const LogoutPage(),
        '/retos': (context) => const ChallengePage(),
        //'/test': (context) => const QuestionPage(),
      },
    );
  }
}