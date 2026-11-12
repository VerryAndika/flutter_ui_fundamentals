import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../widgets/identity_header.dart';
import 'course_form_screen.dart';

// P6 Tahap 13: status favorite di detail dibaca dari provider yang sama
// dengan list dan FavoritesScreen.
// P7 Tahap 7: data course diambil ulang dari provider (berdasarkan code)
// agar hasil edit langsung terlihat; course dari constructor jadi fallback.
class CourseDetailScreen extends StatelessWidget {
  const CourseDetailScreen({super.key, required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    final course =
        context.select<CourseProvider, Course?>(
          (p) => p.courseByCode(this.course.code),
        ) ??
        this.course;
    final favorite = context.select<CourseProvider, bool>(
      (p) => p.isFavorite(course.code),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(course.code),
        actions: [
          IconButton(
            tooltip: 'Edit',
            icon: const Icon(Icons.edit),
            onPressed: course.id == null
                ? null
                : () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CourseFormScreen(initial: course),
                    ),
                  ),
          ),
        ],
      ),
      body: ListView(
        children: [
          const IdentityHeader(subtitle: 'Detail course'),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              course.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.school),
            title: const Text('SKS'),
            trailing: Text('${course.credits}'),
          ),
          ListTile(
            leading: const Icon(Icons.flag),
            title: const Text('Status'),
            trailing: Text(course.statusLabel),
          ),
          ListTile(
            leading: Icon(
              favorite ? Icons.favorite : Icons.favorite_border,
              color: favorite ? Colors.pink : null,
            ),
            title: const Text('Favorite'),
            trailing: Text(favorite ? 'Ya' : 'Tidak'),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton.icon(
              icon: Icon(favorite ? Icons.heart_broken : Icons.favorite),
              label: Text(
                favorite ? 'Hapus dari favorite' : 'Tambah ke favorite',
              ),
              onPressed: () =>
                  context.read<CourseProvider>().toggleFavorite(course.code),
            ),
          ),
        ],
      ),
    );
  }
}
