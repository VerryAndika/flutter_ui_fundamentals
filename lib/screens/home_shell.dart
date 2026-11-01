import 'package:flutter/material.dart';

import 'courses_screen.dart';
import 'favorites_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

// P6 Tahap 14: shell Course Explorer v2. Navigasi responsif dari
// Pertemuan 5 dipertahankan (NavigationBar < 840, NavigationRail >= 840).
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  // Local state: hanya shell yang perlu tahu tab aktif.
  int currentIndex = 0;

  static const pages = [
    HomeScreen(),
    CoursesScreen(),
    FavoritesScreen(),
    ProfileScreen(),
  ];

  static const destinations = [
    (Icons.home, 'Home'),
    (Icons.school, 'Courses'),
    (Icons.favorite, 'Favorites'),
    (Icons.person, 'Profile'),
  ];

  void _select(int index) => setState(() => currentIndex = index);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final appBar = AppBar(title: const Text('Course Explorer v2'));
        if (constraints.maxWidth < 840) {
          return Scaffold(
            appBar: appBar,
            body: pages[currentIndex],
            bottomNavigationBar: NavigationBar(
              selectedIndex: currentIndex,
              onDestinationSelected: _select,
              destinations: [
                for (final (icon, label) in destinations)
                  NavigationDestination(icon: Icon(icon), label: label),
              ],
            ),
          );
        }
        return Scaffold(
          appBar: appBar,
          body: Row(
            children: [
              NavigationRail(
                selectedIndex: currentIndex,
                onDestinationSelected: _select,
                labelType: NavigationRailLabelType.all,
                destinations: [
                  for (final (icon, label) in destinations)
                    NavigationRailDestination(
                      icon: Icon(icon),
                      label: Text(label),
                    ),
                ],
              ),
              const VerticalDivider(width: 1),
              Expanded(child: pages[currentIndex]),
            ],
          ),
        );
      },
    );
  }
}
