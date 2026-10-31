import 'package:flutter/material.dart';

import 'identity.dart';
import 'pages/dashboard_page.dart';
import 'pages/debugging_page.dart';
import 'pages/practice_page.dart';
import 'pages/stage_json_pages.dart';
import 'pages/stage_pages.dart';
import 'pages/topics_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Learning Dashboard - $studentId - $studentName',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      routes: appRoutes,
      // Saat dibuka langsung lewat URL (mis. /#/tahap5), tampilkan
      // halaman tahap itu saja tanpa menumpuk di atas dashboard.
      onGenerateInitialRoutes: (name) => [
        MaterialPageRoute(
          settings: RouteSettings(name: name),
          builder: appRoutes[name] ?? appRoutes['/']!,
        ),
      ],
    );
  }
}

// Halaman utama = Learning Dashboard (Tahap 14).
// Route lain menyimpan hasil tiap tahap, mis. /#/tahap5 di web.
final Map<String, WidgetBuilder> appRoutes = {
  '/': (_) => const DashboardPage(),
  '/tahap1': (_) => const Tahap1Page(),
  '/tahap2': (_) => const Tahap2Page(),
  '/tahap4': (_) => const Tahap4Page(),
  '/tahap5': (_) => const Tahap5Page(),
  '/tahap6': (_) => const Tahap6Page(),
  '/tahap7': (_) => const Tahap7Page(),
  '/tahap8': (_) => const Tahap8Page(),
  '/tahap9': (_) => const Tahap9Page(),
  '/tahap10': (_) => const Tahap10Page(),
  '/tahap11': (_) => const TopicsPage(),
  '/tahap12': (_) => const Tahap12Page(),
  '/tahap13': (_) => const Tahap13Page(),
  '/latihan': (_) => const PracticePage(),
  '/tahap15': (_) => const DebuggingPage(),
  '/tahap15-error': (_) =>
      const DashboardPage(dataPath: 'assets/data/student_dat.json'),
};
