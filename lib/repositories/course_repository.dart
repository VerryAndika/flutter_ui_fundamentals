import '../models/course.dart';
import '../services/course_data_source.dart';

// P6 Tahap 10: abstraksi data untuk Provider.
// P7 Tahap 9: bergantung pada kontrak CourseDataSource, bukan pada
// implementasi konkret (REST/Supabase).
class CourseRepository {
  CourseRepository(this.dataSource);

  final CourseDataSource dataSource;

  Future<List<Course>> getCourses() => dataSource.getCourses();

  Future<Course> createCourse(Course course) => dataSource.createCourse(course);

  Future<void> updateCourse(int id, Course course) =>
      dataSource.updateCourse(id, course);

  Future<void> deleteCourse(int id) => dataSource.deleteCourse(id);
}
