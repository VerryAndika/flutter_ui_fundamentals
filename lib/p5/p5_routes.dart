import 'package:flutter/material.dart';

import 'responsive_shell.dart';
import 'stages/tahap01_hardcoded.dart';
import 'stages/tahap02_mediaquery.dart';
import 'stages/tahap03_layoutbuilder.dart';
import 'stages/tahap04_flexible_wrap.dart';
import 'stages/tahap05_grid.dart';
import 'stages/tahap06_scroll.dart';
import 'stages/tahap07_navigation.dart';
import 'stages/tahap08_course_list.dart';
import 'stages/tahap12_interaction.dart';

// Pertemuan 5 - Responsive Layout, Navigation & User Interaction.
// Setiap tahap didaftarkan di sini sehingga dapat dibuka langsung,
// mis. /#/p5/tahap2 di web atau fuf://app/p5/tahap2 di Android.
final Map<String, WidgetBuilder> p5Routes = {
  '/p5/tahap1': (_) => const HardCodedWidthPage(),
  '/p5/tahap2': (_) => const MediaQueryPage(),
  '/p5/tahap3': (_) => const LayoutBuilderPage(),
  '/p5/tahap4': (_) => const FlexibleWrapPage(),
  '/p5/tahap5': (_) => const ResponsiveGridPage(),
  '/p5/tahap6-noscroll': (_) => const ScrollBeforePage(),
  '/p5/tahap6': (_) => const ScrollAfterPage(),
  '/p5/tahap7': (_) => const NavHomePage(),
  '/p5/tahap8': (_) => const CourseListPage(),
  '/p5/tahap9': (_) => const CourseListPage(),
  '/p5/tahap10': (_) => const ResponsiveShell(),
  '/p5/tahap11': (_) => const ResponsiveShell(),
  '/p5/tahap12': (_) => const InteractionPage(),
};
