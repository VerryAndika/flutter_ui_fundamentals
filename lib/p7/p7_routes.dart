import 'package:flutter/material.dart';

import 'stages/tahap02_http_get.dart';
import 'stages/tahap03_model_json.dart';

// Pertemuan 7 - RESTful API, Backend Services & Database Integration.
// Halaman latihan per tahap, mis. /#/p7/tahap2 di web.
final Map<String, WidgetBuilder> p7Routes = {
  '/p7/tahap2': (_) => const HttpGetPage(),
  '/p7/tahap3': (_) => const ModelJsonPage(),
};
