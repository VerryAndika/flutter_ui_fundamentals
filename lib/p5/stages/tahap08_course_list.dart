import 'package:flutter/material.dart';

import '../course_data.dart';
import '../pages/course_detail_page.dart';
import '../widgets/identity_header.dart';

// Tahap 8: list course, setiap item membuka CourseDetailPage.
class CourseListPage extends StatefulWidget {
  const CourseListPage({super.key});

  @override
  State<CourseListPage> createState() => _CourseListPageState();
}

class _CourseListPageState extends State<CourseListPage> {
  late Future<List<Map<String, dynamic>>> coursesFuture;

  @override
  void initState() {
    super.initState();
    coursesFuture = loadCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('P5 Tahap 8 - Course List')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: coursesFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final courses = snapshot.data!;
          return Column(
            children: [
              const IdentityHeader(subtitle: 'Ketuk course untuk detail'),
              Expanded(
                child: ListView.builder(
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    return ListTile(
                      leading: const Icon(Icons.menu_book),
                      title: Text(course['title'] as String),
                      subtitle: Text(
                        '${course['code']} • ${course['credits']} SKS',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CourseDetailPage(course: course),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
