import '../models/course.dart';

// P7 Tahap 9: kontrak sumber data. Repository hanya mengenal kontrak ini,
// sehingga REST API, Supabase, atau data palsu (test) dapat ditukar.
abstract class CourseDataSource {
  Future<List<Course>> getCourses();
  Future<Course> createCourse(Course course);
  Future<void> updateCourse(int id, Course course);
  Future<void> deleteCourse(int id);
}
