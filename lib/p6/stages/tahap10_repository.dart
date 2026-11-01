import 'package:flutter/material.dart';

import '../../models/course.dart';
import '../../p5/widgets/identity_header.dart';
import '../../repositories/course_repository.dart';
import '../../services/course_service.dart';

// Tahap 10: data diambil lewat CourseRepository, bukan langsung service.
class CourseRepositoryPage extends StatefulWidget {
  const CourseRepositoryPage({super.key});

  @override
  State<CourseRepositoryPage> createState() => _CourseRepositoryPageState();
}

class _CourseRepositoryPageState extends State<CourseRepositoryPage> {
  final repository = CourseRepository(CourseService());
  late final Future<List<Course>> coursesFuture;

  @override
  void initState() {
    super.initState();
    coursesFuture = repository.getCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('P6 Tahap 10 - Repository')),
      body: FutureBuilder<List<Course>>(
        future: coursesFuture,
        builder: (context, snapshot) => ListView(
          children: [
            const IdentityHeader(subtitle: 'CourseRepository.getCourses()'),
            const ListTile(
              leading: Icon(Icons.account_tree_outlined),
              title: Text('UI → CourseRepository → CourseService → JSON'),
            ),
            if (!snapshot.hasData)
              const Center(child: CircularProgressIndicator())
            else
              for (final course in snapshot.data!)
                ListTile(
                  dense: true,
                  title: Text(course.title),
                  subtitle: Text('${course.code} • ${course.statusLabel}'),
                ),
          ],
        ),
      ),
    );
  }
}
