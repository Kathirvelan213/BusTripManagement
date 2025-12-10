import 'package:flutter/material.dart';
import 'package:flutter_app/config/custom_colors.dart';

class NavBar extends StatefulWidget {
  NavBar({super.key, required this.currentIndex, required this.onTap});

  int currentIndex = 1;
  ValueChanged<int> onTap;
  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.route),
          label: 'Route',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Reminders',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      currentIndex: widget.currentIndex,
      unselectedItemColor: Colors.blueGrey,
      selectedItemColor: Theme.of(context).colorScheme.appPrimary2,
      onTap: widget.onTap,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
    );
  }
}
