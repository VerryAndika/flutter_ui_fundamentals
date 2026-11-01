import 'package:flutter/material.dart';

import 'stages/tahap01_hardcoded.dart';
import 'stages/tahap02_mediaquery.dart';
import 'stages/tahap03_layoutbuilder.dart';
import 'stages/tahap04_flexible_wrap.dart';
import 'stages/tahap05_grid.dart';

// Pertemuan 5 - Responsive Layout, Navigation & User Interaction.
// Setiap tahap didaftarkan di sini sehingga dapat dibuka langsung,
// mis. /#/p5/tahap2 di web atau fuf://app/p5/tahap2 di Android.
final Map<String, WidgetBuilder> p5Routes = {
  '/p5/tahap1': (_) => const HardCodedWidthPage(),
  '/p5/tahap2': (_) => const MediaQueryPage(),
  '/p5/tahap3': (_) => const LayoutBuilderPage(),
  '/p5/tahap4': (_) => const FlexibleWrapPage(),
  '/p5/tahap5': (_) => const ResponsiveGridPage(),
};
