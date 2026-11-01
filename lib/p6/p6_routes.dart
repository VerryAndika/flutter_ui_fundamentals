import 'package:flutter/material.dart';

import 'stages/tahap01_local_shared.dart';
import 'stages/tahap02_prop_drilling.dart';
import 'stages/tahap03_lifting_state.dart';
import 'stages/tahap04_value_notifier.dart';
import 'stages/tahap05_change_notifier.dart';
import 'stages/tahap06_provider_setup.dart';
import 'stages/tahap07_watch_read.dart';

// Pertemuan 6 - State Management & Mobile Application Architecture.
// Halaman latihan per tahap, mis. /#/p6/tahap1 di web.
final Map<String, WidgetBuilder> p6Routes = {
  '/p6/tahap1': (_) => const LocalSharedStatePage(),
  '/p6/tahap2': (_) => const PropDrillingPage(),
  '/p6/tahap3': (_) => const LiftingStatePage(),
  '/p6/tahap4': (_) => const ValueNotifierPage(),
  '/p6/tahap5': (_) => const ChangeNotifierPage(),
  '/p6/tahap6': (_) => const ProviderSetupPage(),
  '/p6/tahap7': (_) => const WatchReadPage(),
};
