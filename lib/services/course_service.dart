import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/course.dart';

// P6 Tahap 9: detail teknis sumber data (JSON asset) ada di service.
// Nanti dapat diganti API tanpa mengubah screen.
class CourseService {
  CourseService({this.delay = const Duration(milliseconds: 800)});

  // Simulasi waktu tunggu jaringan agar state loading terlihat.
  final Duration delay;

  static const String path = 'assets/data/student_data.json';

  Future<List<Course>> loadCourses() async {
    await Future<void>.delayed(delay);
    final jsonString = await rootBundle.loadString(path);
    final data = jsonDecode(jsonString) as Map<String, dynamic>;
    final list = data['courses'] as List<dynamic>;
    return list.map((e) => Course.fromJson(e as Map<String, dynamic>)).toList();
  }
}
