import 'package:compu_think/core/utils/navigation_helper.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        /*BottomNavigationBarItem(
          icon: Icon(Icons.emoji_events),
          label: 'Logros',
        ),*/
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Perfil',
        ),
      ],
      onTap: (index) {
        onItemTapped(context, index); // Llama a la función global
      },
    );
  }
}
