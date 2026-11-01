import 'package:flutter/material.dart';
import 'package:flutter_sem3/screens/student_screen.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import 'meal_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
        tabs: [
          PersistentTabConfig(
            screen: StudentScreen(),
            item: ItemConfig(
              icon: Icon(Icons.person),
              title: "Messages",
              activeForegroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
              inactiveForegroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          PersistentTabConfig(
            screen: MealScreen(),
            item: ItemConfig(
              icon: Icon(Icons.home),
              title: "Home",
              activeForegroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
              inactiveForegroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          
          PersistentTabConfig(
            screen: SettingsScreen(),
            item: ItemConfig(
              icon: Icon(Icons.settings),
              title: "Settings",
              activeForegroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
              inactiveForegroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
        navBarBuilder: (navBarConfig) => Style9BottomNavBar(
          navBarConfig: navBarConfig,
          navBarDecoration: NavBarDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
          ),
        ),
      );
  }
}
