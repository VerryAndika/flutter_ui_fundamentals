import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'identity.dart';
import 'p5/p5_routes.dart';
import 'p5/responsive_shell.dart';
import 'providers/course_provider.dart';
import 'p6/p6_routes.dart';
import 'pages/dashboard_page.dart';
import 'pages/debugging_page.dart';
import 'pages/practice_page.dart';
import 'pages/stage_json_pages.dart';
import 'pages/stage_pages.dart';
import 'pages/topics_page.dart';
import 'repositories/course_repository.dart';
import 'screens/home_shell.dart';
import 'services/course_service.dart';

void main() {
  // P6 Tahap 6: CourseProvider tersedia untuk seluruh widget tree.
  runApp(
    ChangeNotifierProvider(
      // Tahap 11: Provider -> Repository -> Service, dimuat sekali di awal.
      create: (_) =>
          CourseProvider(CourseRepository(CourseService()))..loadCourses(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course Explorer v2 - $studentId - $studentName',
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

// Halaman utama = Course Explorer v2 (Pertemuan 6). Course Explorer
// Pertemuan 5 di /p5, Learning Dashboard Pertemuan 4 di /p4, dan route lain
// menyimpan hasil tiap tahap, mis. /#/tahap5 atau /#/p5/tahap3 di web.
final Map<String, WidgetBuilder> appRoutes = {
  '/': (_) => const HomeShell(),
  '/p5': (_) => const ResponsiveShell(),
  '/p4': (_) => const DashboardPage(),
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
  '/tahap15-overflow': (_) => const OverflowDemoPage(),
  ...p5Routes,
  ...p6Routes,
};
