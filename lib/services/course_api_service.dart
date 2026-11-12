import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/course.dart';

// P7 Tahap 4: semua komunikasi HTTP dengan REST API ada di service ini.
class CourseApiService {
  CourseApiService(this.baseUrl);

  final String baseUrl;

  static const _json = {'Content-Type': 'application/json'};

  // Pesan error dari body JSON backend: {"error": "...", "status": 409}.
  Exception _error(String action, http.Response response) {
    var detail = '';
    try {
      final body = jsonDecode(response.body);
      if (body is Map && body['error'] is String) detail = ': ${body['error']}';
    } catch (_) {}
    return Exception('Gagal $action (HTTP ${response.statusCode})$detail');
  }

  Future<List<Course>> getCourses() async {
    final response = await http.get(Uri.parse('$baseUrl/courses'));

    if (response.statusCode != 200) {
      throw _error('mengambil course', response);
    }

    final List data = jsonDecode(response.body) as List;
    return data.map((e) => Course.fromJson(e as Map<String, dynamic>)).toList();
  }

  // P7 Tahap 6: POST membuat resource baru (201 Created).
  Future<Course> createCourse(Course course) async {
    final response = await http.post(
      Uri.parse('$baseUrl/courses'),
      headers: _json,
      body: jsonEncode(course.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Course.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }

    throw _error('membuat course', response);
  }

  // P7 Tahap 7: PUT mengganti seluruh resource course.
  Future<void> updateCourse(int id, Course course) async {
    final response = await http.put(
      Uri.parse('$baseUrl/courses/$id'),
      headers: _json,
      body: jsonEncode(course.toJson()),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw _error('memperbarui course', response);
    }
  }

  // P7 Tahap 8: DELETE menghapus resource (204 No Content).
  Future<void> deleteCourse(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/courses/$id'));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw _error('menghapus course', response);
    }
  }
}
