import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

// Tahap 12: membaca JSON statik dari asset lalu decode ke Map.
// Tahap 15 Kasus C: route /#/tahap15-error memanggil fungsi ini dengan
// path yang salah ('student_dat.json') untuk memperlihatkan error state.
const String studentDataPath = 'assets/data/student_data.json';

Future<Map<String, dynamic>> loadStudentData([
  String path = studentDataPath,
]) async {
  final jsonString = await rootBundle.loadString(path);
  return jsonDecode(jsonString) as Map<String, dynamic>;
}
