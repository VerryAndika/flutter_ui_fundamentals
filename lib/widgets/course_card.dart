import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';

// Kartu course v2: menerima model Course, favorite dibaca dari provider.
class CourseCard extends StatelessWidget {
  const CourseCard({super.key, required this.course, this.onTap});

  final Course course;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final favorite = context.select<CourseProvider, bool>(
      (p) => p.isFavorite(course.code),
    );
    final (IconData icon, Color color) = switch (course.status) {
      'done' => (Icons.check_circle, Colors.green),
      'active' => (Icons.play_circle, Colors.orange),
      _ => (Icons.schedule, Colors.grey),
    };
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: color),
        title: Text(course.title, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          '${course.code} • ${course.credits} SKS • ${course.statusLabel}',
        ),
        trailing: IconButton(
          tooltip: favorite ? 'Hapus favorite' : 'Jadikan favorite',
          icon: Icon(
            favorite ? Icons.favorite : Icons.favorite_border,
            color: favorite ? Colors.pink : null,
          ),
          onPressed: () =>
              context.read<CourseProvider>().toggleFavorite(course.code),
        ),
      ),
    );
  }
}
