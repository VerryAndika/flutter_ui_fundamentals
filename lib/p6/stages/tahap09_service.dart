import 'package:flutter/material.dart';

import '../../models/course.dart';
import '../../widgets/identity_header.dart';
import '../../services/course_service.dart';

// Tahap 9: uji CourseService secara langsung (sementara, sebelum Provider).
class CourseServicePage extends StatefulWidget {
  const CourseServicePage({super.key});

  @override
  State<CourseServicePage> createState() => _CourseServicePageState();
}

class _CourseServicePageState extends State<CourseServicePage> {
  late final Future<List<Course>> coursesFuture;

  @override
  void initState() {
    super.initState();
    coursesFuture = CourseService().loadCourses().then((courses) {
      debugPrint('CourseService: ${courses.length} course dimuat');
      return courses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('P6 Tahap 9 - CourseService')),
      body: FutureBuilder<List<Course>>(
        future: coursesFuture,
        builder: (context, snapshot) {
          final courses = snapshot.data;
          return ListView(
            children: [
              const IdentityHeader(subtitle: 'CourseService.loadCourses()'),
              ListTile(
                title: Text(
                  courses == null
                      ? 'Memuat...'
                      : 'List<Course> berisi ${courses.length} item',
                ),
              ),
              for (final course in courses ?? const <Course>[])
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.menu_book),
                  title: Text(course.title),
                  subtitle: Text('${course.code} • ${course.credits} SKS'),
                ),
            ],
          );
        },
      ),
    );
  }
}
