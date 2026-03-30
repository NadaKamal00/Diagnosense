import 'package:flutter/material.dart';
import '../Widgets/custom_bottom_bar.dart';
import 'Home/home_screen.dart';
import 'Settings/settings_screen.dart';
import 'Tasks/task_screen.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  static _NavigationMenuState? of(BuildContext context) =>
      context.findAncestorStateOfType<_NavigationMenuState>();

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int currentIndex = 0;

  final List<GlobalKey<NavigatorState>> navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  void changePage(int index) {
    if (index == currentIndex) {
      navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() => currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      resizeToAvoidBottomInset: false,
      body: IndexedStack(
        index: currentIndex,
        children: [
          _buildTabNavigator(navigatorKeys[0], const HomeScreen()),
          _buildTabNavigator(navigatorKeys[1], const TaskScreen()),
          _buildTabNavigator(navigatorKeys[2], const SettingsScreen()),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: currentIndex,
        onTap: changePage,
      ),
    );
  }

  Widget _buildTabNavigator(GlobalKey<NavigatorState> key, Widget screen) {
    return Navigator(
      key: key,
      onGenerateRoute: (settings) => MaterialPageRoute(builder: (_) => screen),
    );
  }
}
