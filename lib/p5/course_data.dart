import '../services/student_service.dart';

// Data course P5 memakai JSON statik dari Pertemuan 4.
Future<List<Map<String, dynamic>>> loadCourses() async {
  final data = await loadStudentData();
  return (data['courses'] as List<dynamic>).cast<Map<String, dynamic>>();
}
