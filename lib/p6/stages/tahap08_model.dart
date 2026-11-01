import 'package:flutter/material.dart';

import '../../models/course.dart';
import '../../widgets/identity_header.dart';

// Satu item JSON (sama seperti di assets/data/student_data.json).
const Map<String, dynamic> sampleCourseJson = {
  'code': 'MOB03',
  'title': 'Flutter UI Fundamentals',
  'credits': 3,
  'status': 'active',
  'progress': 60,
};

// Tahap 8: Map JSON -> object Course -> UI.
class CourseModelPage extends StatelessWidget {
  const CourseModelPage({super.key});

  @override
  Widget build(BuildContext context) {
    final course = Course.fromJson(sampleCourseJson);
    return Scaffold(
      appBar: AppBar(title: const Text('P6 Tahap 8 - Model Course')),
      body: ListView(
        children: [
          const IdentityHeader(subtitle: 'Course.fromJson'),
          ListTile(
            title: const Text('JSON (Map<String, dynamic>)'),
            subtitle: Text(sampleCourseJson.toString()),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.data_object),
            title: Text(course.title),
            subtitle: Text(
              'code: ${course.code}\ncredits: ${course.credits} SKS\n'
              'status: ${course.status} (${course.statusLabel})\n'
              'progress: ${course.progress}%',
            ),
            isThreeLine: true,
          ),
        ],
      ),
    );
  }
}
