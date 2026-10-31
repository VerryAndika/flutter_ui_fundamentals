import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

// Tahap 12: membaca JSON statik dari asset lalu decode ke Map.
// Tahap 15 Kasus C: ubah sementara path ini (mis. 'student_dat.json')
// untuk melihat error state pada FutureBuilder, lalu kembalikan.
const String studentDataPath = 'assets/data/student_data.json';

Future<Map<String, dynamic>> loadStudentData() async {
  final jsonString = await rootBundle.loadString(studentDataPath);
  return jsonDecode(jsonString) as Map<String, dynamic>;
}
