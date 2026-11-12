import 'package:flutter/foundation.dart';

import '../models/course.dart';
import '../repositories/course_repository.dart';

enum CourseLoadStatus { initial, loading, success, error }

// Tahap 5: state course dipisahkan ke ChangeNotifier.
// Tahap 11: memuat data lewat repository dan menyimpan loading/error/data.
class CourseProvider extends ChangeNotifier {
  final CourseRepository repository;

  CourseProvider(this.repository);

  List<Course> courses = [];
  bool isLoading = false;
  String? error;
  bool _loadedOnce = false;

  final Set<String> favorites = {};

  CourseLoadStatus get status {
    if (isLoading) return CourseLoadStatus.loading;
    if (error != null) return CourseLoadStatus.error;
    if (!_loadedOnce) return CourseLoadStatus.initial;
    return CourseLoadStatus.success;
  }

  Future<void> loadCourses() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      courses = await repository.getCourses();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      _loadedOnce = true;
      notifyListeners();
    }
  }

  // P7 Tahap 6: true selama request tulis berjalan; dipakai UI untuk
  // menonaktifkan tombol Simpan (mencegah submit ganda).
  bool isSaving = false;

  Future<T> _save<T>(Future<T> Function() action) async {
    isSaving = true;
    notifyListeners();
    try {
      final result = await action();
      // Ganti isi list dengan data terbaru dari server (bukan menambah).
      await loadCourses();
      return result;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  Future<Course> createCourse(Course course) =>
      _save(() => repository.createCourse(course));

  // P7 Tahap 7
  Future<void> updateCourse(int id, Course course) =>
      _save(() => repository.updateCourse(id, course));

  // Data terbaru berdasarkan code (code = kunci favorites).
  Course? courseByCode(String code) {
    for (final c in courses) {
      if (c.code == code) return c;
    }
    return null;
  }

  int get favoriteCount => favorites.length;

  // Tahap 13: dipakai FavoritesScreen.
  List<Course> get favoriteCourses =>
      courses.where((c) => favorites.contains(c.code)).toList();

  bool isFavorite(String code) => favorites.contains(code);

  void toggleFavorite(String code) {
    if (favorites.contains(code)) {
      favorites.remove(code);
    } else {
      favorites.add(code);
    }
    notifyListeners();
  }
}
