import 'package:flutter/material.dart';

import '../course_data.dart';
import '../favorites.dart';
import '../pages/course_detail_page.dart';
import '../widgets/identity_header.dart';

// Tahap 8-9: list course membuka CourseDetailPage dan menerima hasilnya.
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

  // Tahap 9: menunggu hasil dari CourseDetailPage.
  Future<void> _openDetail(Map<String, dynamic> course) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => CourseDetailPage(course: course)),
    );
    if (!mounted || result != true) return;
    setState(() => setFavorite(course['code'] as String, true));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${course['title']} ditambahkan ke favorite')),
    );
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
                    final code = course['code'] as String;
                    return ListTile(
                      leading: Icon(
                        isFavorite(code) ? Icons.favorite : Icons.menu_book,
                        color: isFavorite(code) ? Colors.pink : null,
                      ),
                      title: Text(course['title'] as String),
                      subtitle: Text('$code • ${course['credits']} SKS'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _openDetail(course),
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
