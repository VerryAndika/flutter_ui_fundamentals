import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import '../widgets/identity_header.dart';
import 'course_detail_screen.dart';

// P6 Tahap 13: hanya menampilkan course yang ada di favorites provider.
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<CourseProvider>().favoriteCourses;
    return Column(
      children: [
        IdentityHeader(subtitle: '${favorites.length} favorite'),
        Expanded(
          child: favorites.isEmpty
              ? const Center(
                  child: Text('Belum ada favorite. Tandai dari Courses.'),
                )
              : ListView(
                  padding: const EdgeInsets.all(12),
                  children: [
                    for (final course in favorites)
                      CourseCard(
                        course: course,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CourseDetailScreen(course: course),
                          ),
                        ),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}
