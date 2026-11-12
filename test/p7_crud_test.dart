import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_ui_fundamentals/models/course.dart';
import 'package:flutter_ui_fundamentals/providers/course_provider.dart';
import 'package:flutter_ui_fundamentals/repositories/course_repository.dart';
import 'package:flutter_ui_fundamentals/services/course_data_source.dart';

// Data source di memori: membuktikan repository/provider tidak bergantung
// pada REST maupun Supabase (cukup memenuhi kontrak CourseDataSource).
class FakeDataSource implements CourseDataSource {
  final List<Course> rows = [
    const Course(id: 1, code: 'MOB01', title: 'Git & GitHub', credits: 2),
  ];
  int _nextId = 2;

  @override
  Future<List<Course>> getCourses() async => List.of(rows);

  @override
  Future<Course> createCourse(Course c) async {
    if (rows.any((r) => r.code == c.code)) {
      throw Exception('code sudah dipakai');
    }
    final created = Course(
      id: _nextId++,
      code: c.code,
      title: c.title,
      credits: c.credits,
      status: c.status,
    );
    rows.add(created);
    return created;
  }

  @override
  Future<void> updateCourse(int id, Course c) async {
    final i = rows.indexWhere((r) => r.id == id);
    rows[i] = Course(
      id: id,
      code: c.code,
      title: c.title,
      credits: c.credits,
      status: c.status,
    );
  }

  @override
  Future<void> deleteCourse(int id) async =>
      rows.removeWhere((r) => r.id == id);
}

void main() {
  test('Course.toJson hanya mengirim field yang diterima backend', () {
    const c = Course(id: 9, code: 'X1', title: 'T', credits: 2, progress: 50);
    expect(c.toJson(), {
      'code': 'X1',
      'title': 'T',
      'credits': 2,
      'status': 'planned',
    });
    expect(
      Course.fromJson({'id': 3, 'code': 'A', 'title': 'B', 'credits': 1})
          .status,
      'planned',
    );
  });

  test('CourseProvider CRUD lewat repository + data source palsu', () async {
    final source = FakeDataSource();
    final provider = CourseProvider(CourseRepository(source));
    await provider.loadCourses();
    expect(provider.courses, hasLength(1));

    final saving = <bool>[];
    provider.addListener(() => saving.add(provider.isSaving));
    final created = await provider.createCourse(
      const Course(code: 'VA01', title: 'REST API', credits: 3),
    );
    expect(created.id, 2);
    expect(provider.courses, hasLength(2));
    expect(saving.first, isTrue); // tombol Simpan dinonaktifkan dulu
    expect(provider.isSaving, isFalse);

    await provider.updateCourse(
      2,
      const Course(
        code: 'VA01',
        title: 'REST API v2',
        credits: 4,
        status: 'active',
      ),
    );
    expect(provider.courseByCode('VA01')!.title, 'REST API v2');

    provider.toggleFavorite('VA01');
    await provider.deleteCourse(provider.courseByCode('VA01')!);
    expect(provider.courses, hasLength(1));
    expect(provider.isFavorite('VA01'), isFalse); // tidak ada favorite yatim
  });

  test('Error backend diteruskan ke UI dan isSaving kembali false', () async {
    final provider = CourseProvider(CourseRepository(FakeDataSource()));
    await provider.loadCourses();
    await expectLater(
      provider.createCourse(
        const Course(code: 'MOB01', title: 'Dup', credits: 2),
      ),
      throwsA(isA<Exception>()),
    );
    expect(provider.isSaving, isFalse);
  });
}
