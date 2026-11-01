import 'package:flutter/material.dart';

import '../course_data.dart';
import '../widgets/course_card.dart';
import '../widgets/identity_header.dart';

// Destinasi Courses pada Course Explorer.
class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  late Future<List<Map<String, dynamic>>> coursesFuture;

  @override
  void initState() {
    super.initState();
    coursesFuture = loadCourses();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: coursesFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final courses = snapshot.data!;
        return Column(
          children: [
            const IdentityHeader(subtitle: 'Courses'),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: courses.length,
                itemBuilder: (context, index) =>
                    CourseCard(course: courses[index]),
              ),
            ),
          ],
        );
      },
    );
  }
}
