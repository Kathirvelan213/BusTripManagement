import 'package:flutter/material.dart';
import 'package:flutter_app/components/nav_control/widgets/nav_bar.dart';
import 'package:flutter_app/components/pages/home/home_page.dart';
import 'package:flutter_app/components/pages/route_selection/route_selection_page.dart';
import 'package:flutter_app/components/pages/settings/settings_page.dart';
import 'package:flutter_app/components/pages/reminders/reminders_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  final routeNavigatorKey = GlobalKey<NavigatorState>();

  void handleTabSelection(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: [
          _RouteStack(), // Tab 0
          const RemindersPage(), // Tab 1
          const HomePage(), // Tab 2
          const SettingsPage(), // Tab 3
        ],
      ),
      bottomNavigationBar: NavBar(
        currentIndex: currentIndex,
        onTap: handleTabSelection,
      ),
    );
  }

  Widget _RouteStack() {
    return Navigator(
      key: routeNavigatorKey,

      // handle internal navigation stack inside this tab
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) {
            return const RouteSelectionPage();
          },
        );
      },
    );
  }
}
