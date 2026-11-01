import 'package:flutter/material.dart';

import '../breakpoints.dart';
import '../course_data.dart';
import '../favorites.dart';
import '../widgets/course_card.dart';
import '../widgets/identity_header.dart';
import 'course_detail_page.dart';

// Destinasi Courses pada Course Explorer.
// Compact: list 1 kolom, medium: grid 2 kolom, expanded: grid 3 kolom.
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

  Future<void> _openDetail(Map<String, dynamic> course) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => CourseDetailPage(course: course)),
    );
    if (!mounted || result != true) return;
    setFavorite(course['code'] as String, true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${course['title']} ditambahkan ke favorite')),
    );
  }

  void _showInfo(Map<String, dynamic> course) {
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => ListTile(
        contentPadding: const EdgeInsets.all(24),
        leading: const Icon(Icons.info_outline),
        title: Text(course['title'] as String),
        subtitle: Text(
          '${course['code']} • ${course['credits']} SKS • '
          'progress ${course['progress']}%',
        ),
      ),
    );
  }

  Widget _card(Map<String, dynamic> course, Set<String> favorites) {
    final code = course['code'] as String;
    return CourseCard(
      course: course,
      favorite: favorites.contains(code),
      onTap: () => _openDetail(course),
      onLongPress: () => _showInfo(course),
      onFavoriteChanged: (value) => setFavorite(code, value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: coursesFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Gagal memuat course: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final courses = snapshot.data!;
        return ValueListenableBuilder<Set<String>>(
          valueListenable: favoriteCodes,
          builder: (context, favorites, _) => LayoutBuilder(
            builder: (context, constraints) {
              final columns = columnsFor(constraints.maxWidth);
              final Widget content = columns == 1
                  ? ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: courses.length,
                      itemBuilder: (_, i) => _card(courses[i], favorites),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        mainAxisExtent: 128,
                      ),
                      itemCount: courses.length,
                      itemBuilder: (_, i) => _card(courses[i], favorites),
                    );
              return Column(
                children: [
                  IdentityHeader(
                    subtitle:
                        '${courses.length} course • ${favorites.length} favorite',
                  ),
                  Expanded(child: content),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
