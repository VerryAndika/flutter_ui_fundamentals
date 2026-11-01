import '../models/course.dart';
import '../services/course_service.dart';

// P6 Tahap 10: abstraksi data untuk Provider. Provider tidak perlu tahu
// apakah data berasal dari JSON asset, REST API, atau database lokal.
class CourseRepository {
  final CourseService service;

  CourseRepository(this.service);

  Future<List<Course>> getCourses() {
    return service.loadCourses();
  }
}
