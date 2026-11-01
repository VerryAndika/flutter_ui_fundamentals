import 'package:flutter/material.dart';

import 'pages/courses_page.dart';
import 'pages/home_page.dart';
import 'pages/profile_page.dart';

// Tahap 10-11: navigasi utama yang adaptif.
// Compact/medium (< 840) memakai NavigationBar, expanded memakai
// NavigationRail. selectedIndex disimpan di state shell sehingga page
// aktif tetap sama ketika layout berubah.
class ResponsiveShell extends StatefulWidget {
  const ResponsiveShell({super.key});

  @override
  State<ResponsiveShell> createState() => _ResponsiveShellState();
}

class _ResponsiveShellState extends State<ResponsiveShell> {
  int currentIndex = 0;

  static const pages = [HomePage(), CoursesPage(), ProfilePage()];

  void _select(int index) => setState(() => currentIndex = index);

  Widget buildNavigationBar() {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: _select,
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.school), label: 'Courses'),
        NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }

  Widget buildNavigationRail() {
    return NavigationRail(
      selectedIndex: currentIndex,
      onDestinationSelected: _select,
      labelType: NavigationRailLabelType.all,
      destinations: const [
        NavigationRailDestination(icon: Icon(Icons.home), label: Text('Home')),
        NavigationRailDestination(
          icon: Icon(Icons.school),
          label: Text('Courses'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.person),
          label: Text('Profile'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final appBar = AppBar(title: const Text('Course Explorer'));
        if (constraints.maxWidth < 840) {
          return Scaffold(
            appBar: appBar,
            body: pages[currentIndex],
            bottomNavigationBar: buildNavigationBar(),
          );
        }
        return Scaffold(
          appBar: appBar,
          body: Row(
            children: [
              buildNavigationRail(),
              const VerticalDivider(width: 1),
              Expanded(child: pages[currentIndex]),
            ],
          ),
        );
      },
    );
  }
}
