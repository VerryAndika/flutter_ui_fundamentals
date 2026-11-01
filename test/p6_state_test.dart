import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:flutter_ui_fundamentals/models/course.dart';
import 'package:flutter_ui_fundamentals/providers/course_provider.dart';
import 'package:flutter_ui_fundamentals/repositories/course_repository.dart';
import 'package:flutter_ui_fundamentals/screens/home_shell.dart';
import 'package:flutter_ui_fundamentals/services/course_service.dart';

// Repository palsu: data dari memori, tanpa membaca asset.
class FakeCourseRepository extends CourseRepository {
  FakeCourseRepository({this.fail = false}) : super(CourseService());

  final bool fail;

  @override
  Future<List<Course>> getCourses() async {
    if (fail) throw Exception('sumber data tidak tersedia');
    return const [
      Course(code: 'MOB01', title: 'Git & GitHub', credits: 2, status: 'done'),
      Course(
        code: 'MOB05',
        title: 'State Management',
        credits: 3,
        status: 'planned',
      ),
    ];
  }
}

void main() {
  test('Course.fromJson membaca field dari JSON', () {
    final course = Course.fromJson({
      'code': 'MOB03',
      'title': 'Flutter UI Fundamentals',
      'credits': 3,
      'status': 'active',
      'progress': 60,
    });
    expect(course.code, 'MOB03');
    expect(course.credits, 3);
    expect(course.statusLabel, 'Berjalan');
  });

  test('CourseProvider: initial -> loading -> success', () async {
    final provider = CourseProvider(FakeCourseRepository());
    expect(provider.status, CourseLoadStatus.initial);
    final future = provider.loadCourses();
    expect(provider.status, CourseLoadStatus.loading);
    await future;
    expect(provider.status, CourseLoadStatus.success);
    expect(provider.courses, hasLength(2));
  });

  test('CourseProvider: error disimpan saat repository gagal', () async {
    final provider = CourseProvider(FakeCourseRepository(fail: true));
    await provider.loadCourses();
    expect(provider.status, CourseLoadStatus.error);
    expect(provider.error, contains('sumber data tidak tersedia'));
  });

  testWidgets('Favorite dari Courses ikut tampil di tab Favorites', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(400, 800);
    addTearDown(tester.view.reset);

    final provider = CourseProvider(FakeCourseRepository());
    await provider.loadCourses();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: const MaterialApp(home: HomeShell()),
      ),
    );

    await tester.tap(find.text('Courses'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Jadikan favorite').last);
    await tester.pumpAndSettle();
    expect(provider.favorites, {'MOB05'});

    await tester.tap(find.text('Favorites'));
    await tester.pumpAndSettle();
    expect(find.text('State Management'), findsOneWidget);
    expect(find.text('Git & GitHub'), findsNothing);
  });
}
