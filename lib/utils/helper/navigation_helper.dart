import 'package:flutter/material.dart';

void onItemTapped(BuildContext context, int index) {
  switch (index) {
    case 0:
      Navigator.pushReplacementNamed(context, '/Unidad');
      break;
    /*case 1:
      Navigator.pushReplacementNamed(context, '/');
      break;*/
    case 1:
      Navigator.pushReplacementNamed(context, '/Salir');
      break;
    default:
      throw Exception('Índice de navegación no válido: $index');
  }
}