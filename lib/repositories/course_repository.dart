import '../models/course.dart';
import '../services/course_api_service.dart';

// P6 Tahap 10: abstraksi data untuk Provider.
// P7 Tahap 4: sumber data diganti dari JSON asset ke REST API.
class CourseRepository {
  final CourseApiService service;

  CourseRepository(this.service);

  Future<List<Course>> getCourses() {
    return service.getCourses();
  }

  Future<Course> createCourse(Course course) => service.createCourse(course);

  Future<void> updateCourse(int id, Course course) =>
      service.updateCourse(id, course);

  Future<void> deleteCourse(int id) => service.deleteCourse(id);
}
